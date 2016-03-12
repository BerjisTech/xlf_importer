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

    it 'reports the stats of a UTF-8 XLIFF file' do
      file_path = File.expand_path('/Users/diasks2/Downloads/1.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path)
      expect(xlf.stats).to eq({:tu_count=>10, :seg_count=>20, :language_pairs=>[["it-IT", "ru-RU"]]})
    end

    it 'reports the stats of a UTF-8 XLIFF file' do
      file_path = File.expand_path('/Users/diasks2/Downloads/2.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path)
      expect(xlf.stats).to eq({:tu_count=>25, :seg_count=>50, :language_pairs=>[["it-IT", "ru-RU"]]})
    end

    it 'reports the stats of a UTF-8 XLIFF file' do
      file_path = File.expand_path('/Users/diasks2/Downloads/3.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path)
      expect(xlf.stats).to eq({:tu_count=>4, :seg_count=>8, :language_pairs=>[["it-IT", "ru-RU"]]})
    end

    it 'reports the stats of a UTF-8 XLIFF file' do
      file_path = File.expand_path('/Users/diasks2/Downloads/4.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path)
      expect(xlf.stats).to eq({:tu_count=>54, :seg_count=>108, :language_pairs=>[["it-IT", "ru-RU"]]})
    end

    it 'reports the stats of a UTF-8 XLIFF file' do
      file_path = File.expand_path('/Users/diasks2/Downloads/5.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path)
      expect(xlf.stats).to eq({:tu_count=>797, :seg_count=>1594, :language_pairs=>[["de-DE", "fr-FR"]]})
    end
  end

  describe '#import' do
    it 'imports a UTF-8 XLIFF file' do
      file_path = File.expand_path('/Users/diasks2/Downloads/1.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path)
      expect(xlf.import).to eq('')
    end

    it 'imports sample_alt_translation.xlf' do
      file_path = File.expand_path('../xlf_importer/spec/test_sample_files/sample_alt_translation.xlf')
      xlf = XlfImporter::Xlf.new(file_path: file_path, encoding: 'UTF-8')
      expect(xlf.import).to eq('')
    end
  end
end
