require 'spec_helper'

describe XlfImporter do
  it 'has a version number' do
    expect(XlfImporter::VERSION).not_to be nil
  end

  describe '#stats' do
    it 'reports the stats of sample_alt_translation.xlf' do
      file_path = File.expand_path('../xlf_importer/spec/test_sample_files/sample_alt_translation.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path, encoding: 'UTF-8')
      expect(xlf.stats).to eq({:tu_count=>1, :seg_count=>3, :language_pairs=>[["en", "fr"], ["en", "es"]]})
    end

    it 'reports the stats of sample_alt_2.xlf' do
      file_path = File.expand_path('../xlf_importer/spec/test_sample_files/sample_alt_2.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path, encoding: 'UTF-8')
      expect(xlf.stats).to eq({:tu_count=>2, :seg_count=>5, :language_pairs=>[["en", "fr"], ["en", "es"]]})
    end

    it 'reports the stats of a UTF-16 XLIFF file' do
      file_path = File.expand_path('../xlf_importer/spec/test_sample_files/sample_utf-16.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path)
      expect(xlf.stats).to eq({:tu_count=>1, :seg_count=>3, :language_pairs=>[["en", "fr"], ["en", "es"]]})
    end
  end

  describe '#import' do
    it 'imports sample_alt_translation.xlf' do
      file_path = File.expand_path('../xlf_importer/spec/test_sample_files/sample_alt_translation.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path, encoding: 'UTF-8')
      expect(xlf.import[1][2][3]).to eq('es')
    end

    it 'imports sample_alt_2.xlf' do
      file_path = File.expand_path('../xlf_importer/spec/test_sample_files/sample_alt_2.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path, encoding: 'UTF-8')
      expect(xlf.import[0][1][0]).to eq(xlf.import[1][4][0])
    end

    it 'imports sample_alt_2.xlf' do
      file_path = File.expand_path('../xlf_importer/spec/test_sample_files/sample_alt_2.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path, encoding: 'UTF-8')
      expect(xlf.import[0].length).to eq(2)
    end

    it 'imports sample_alt_2.xlf' do
      file_path = File.expand_path('../xlf_importer/spec/test_sample_files/sample_alt_2.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path, encoding: 'UTF-8')
      expect(xlf.import[1][3][0]).to eq(xlf.import[0][1][0])
    end

    it 'imports a UTF-16 XLIFF file' do
      file_path = File.expand_path('../xlf_importer/spec/test_sample_files/sample_utf-16.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path)
      expect(xlf.import[1][0][4]).to eq("Hello world")
    end
  end
end
