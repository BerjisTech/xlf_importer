require 'xlf_importer/version'
require 'xml'
require 'open-uri'
require 'pretty_strings'
require 'charlock_holmes'

module XlfImporter
  class Xlf
    attr_reader :file_path, :encoding
    def initialize(file_path:, **args)
      @file_path = file_path
      @content = File.read(open(@file_path)) if !args[:encoding].eql?('UTF-8')
      if args[:encoding].nil?
        @encoding = CharlockHolmes::EncodingDetector.detect(@content[0..100_000])[:encoding]
      else
        @encoding = args[:encoding].upcase
      end
      @doc = {
        source_language: "",
        target_language: "",
        tu: { id: "", counter: 0, vals: [] },
        seg: { lang: "", counter: 0, vals: [] },
        language_pairs: []
      }
      raise "Encoding type could not be determined. Please set an encoding of UTF-8, UTF-16LE, or UTF-16BE" if @encoding.nil?
      raise "Encoding type not supported. Please choose an encoding of UTF-8, UTF-16LE, or UTF-16BE" unless @encoding.eql?('UTF-8') || @encoding.eql?('UTF-16LE') || @encoding.eql?('UTF-16BE')
      @text = CharlockHolmes::Converter.convert(@content, @encoding, 'UTF-8') if !@encoding.eql?('UTF-8')
    end

    def stats
      if encoding.eql?('UTF-8')
        analyze_stats_utf_8
      else
        analyze_stats_utf_16
      end
      {tu_count: @doc[:tu][:counter], seg_count: @doc[:seg][:counter], language_pairs: @doc[:language_pairs].uniq}
    end

    def import
      reader = read_file
      parse_file(reader)
      [@doc[:tu][:vals], @doc[:seg][:vals]]
    end

    private

    def analyze_stats_utf_8
      File.readlines(@file_path).each do |line|
        analyze_line(line)
      end
    end

    def analyze_stats_utf_16
      @text.each_line do |line|
        analyze_line(line)
      end
    end

    def read_file
      if encoding.eql?('UTF-8')
        XML::Reader.io(open(file_path), options: XML::Parser::Options::NOERROR, encoding: XML::Encoding::UTF_8)
      else
        reader = @text.gsub(/(?<=encoding=").*(?=")/, 'utf-8').gsub(/&#x[0-1]?[0-9a-fA-F];/, ' ').gsub(/[\0-\x1f\x7f\u2028]/, ' ')
        XML::Reader.string(reader, options: XML::Parser::Options::NOERROR, encoding: XML::Encoding::UTF_8)
      end
    end

    def analyze_line(line)
      @doc[:source_language] = line.scan(/(?<=source-language=\S)\S+(?=")/)[0] if line.include?('source-language=') && !line.scan(/(?<=source-language=\S)\S+(?=")/).empty?
      @doc[:source_language] = line.scan(/(?<=source-language=\S)\S+(?=')/)[0] if line.include?('source-language=') && !line.scan(/(?<=source-language=\S)\S+(?=')/).empty?
      @doc[:target_language] = line.scan(/(?<=target-language=\S)\S+(?=")/)[0] if line.include?('target-language=') && !line.scan(/(?<=target-language=\S)\S+(?=")/).empty?
      @doc[:target_language] = line.scan(/(?<=target-language=\S)\S+(?=')/)[0] if line.include?('target-language=') && !line.scan(/(?<=target-language=\S)\S+(?=')/).empty?
      @doc[:tu][:counter] += line.scan(/<\/trans-unit/).count
      @doc[:seg][:counter] += line.scan(/<\/source/).count + line.scan(/<\/target/).count
      @doc[:language_pairs] << [@doc[:source_language], @doc[:target_language]] if !@doc[:source_language].empty? && !@doc[:target_language].empty?
      if line.include?('lang')
        @doc[:seg][:lang] = line.scan(/(?<=[^cn]lang=\S)\S+(?=")/)[0] if !line.scan(/(?<=[^cn]lang=\S)\S+(?=")/).empty?
        @doc[:seg][:lang] = line.scan(/(?<=[^cn]lang=\S)\S+(?=')/)[0] if !line.scan(/(?<=[^cn]lang=\S)\S+(?=')/).empty?
        if !@doc[:seg][:lang].nil? && !@doc[:seg][:lang].empty? && @doc[:source_language] != @doc[:seg][:lang]
          @doc[:language_pairs] << [@doc[:source_language], @doc[:seg][:lang]]
          @doc[:language_pairs] = @doc[:language_pairs].uniq
        end
      end
    end

    def parse_file(reader)
      tag_stack = []
      generate_unique_id
      while reader.read do
        tag_stack.delete_if { |d| d.bytes.to_a == [101, 112, 116] ||
                                  d.bytes.to_a == [98, 112, 116] ||
                                  d.bytes.to_a == [112, 114, 111, 112] ||
                                  d.bytes.to_a == [112, 104] }
        if !tag_stack.include?(reader.name)
          tag_stack.push(reader.name)
          eval_state_initial(tag_stack, reader)
        elsif tag_stack.last == reader.name
          d = tag_stack.dup.pop
          tag_stack.pop if d.bytes.to_a == [35, 116, 101, 120, 116]
          generate_unique_id if tag_stack.length > 3 && tag_stack.pop.bytes.to_a == [116, 117]
        end
      end
      reader.close
    end

    def eval_state_initial(tag_stack, reader)
      case tag_stack.last.bytes.to_a
      when [102, 105, 108, 101]
        @doc[:source_language] = reader.get_attribute("source-language") if @doc[:source_language].empty? && reader.has_attributes? && reader.get_attribute("source-language")
        @doc[:target_language] = reader.get_attribute("target-language") if @doc[:source_language].empty? && reader.has_attributes? && reader.get_attribute("target-language")
      when [116, 114, 97, 110, 115, 45, 117, 110, 105, 116]
        write_tu(reader)
        @doc[:tu][:counter] += 1
      when [115, 111, 117, 114, 99, 101] # source
        write_seg(reader, 'source', @doc[:source_language])
        @doc[:seg][:counter] += 1
      when [116, 97, 114, 103, 101, 116] # target
        write_seg(reader, 'target', @doc[:target_language])
        @doc[:seg][:counter] += 1
      end
    end

    def write_tu(reader)
      @doc[:tu][:vals] << [@doc[:tu][:id]]
    end

    def write_seg(reader, role, language)
      return if reader.read_string.nil?
      text = PrettyStrings::Cleaner.new(reader.read_string).pretty.gsub("\\","&#92;").gsub("'",%q(\\\'))
      word_count = text.gsub("\s+", ' ').split(' ').length
      @doc[:seg][:vals] << [@doc[:tu][:id], role, word_count, language, text]
    end

    def generate_unique_id
      @doc[:tu][:id] = [(1..4).map{rand(10)}.join(''), Time.now.to_i, @doc[:tu][:counter] += 1 ].join("-")
    end
  end
end
