# XLIFF Importer

[![Gem Version](https://badge.fury.io/rb/xlf_importer.svg)](https://badge.fury.io/rb/xlf_importer) [![Build Status](https://travis-ci.org/diasks2/xlf_importer.png)](https://travis-ci.org/diasks2/xlf_importer) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/diasks2/xlf_importer/blob/master/LICENSE.txt)

This gem handles the importing and parsing of [.xlf files](http://docs.oasis-open.org/xliff/xliff-core/xliff-core.html). [XLIFF files](https://en.wikipedia.org/wiki/XLIFF) are xml files.

## Installation

Add this line to your application's Gemfile:

**Ruby**  
```
gem install xlf_importer
```

**Ruby on Rails**  
Add this line to your application’s Gemfile:  
```ruby 
gem 'xlf_importer'
```

## Usage

```ruby
# Get the high level stats of an XLIFF file
# Including the encoding is optional. If not included the gem will attempt to detect the encoding.
file_path = File.expand_path('../xlf_importer/spec/test_sample_files/sample_alt_translation.xlf')
XlfImporter::Xlf.new(file_path: file_path).stats
# => {:tu_count=>1, :seg_count=>3, :language_pairs=>[["en", "fr"], ["en", "es"]]}

# Extract the segments of an XLIFF file
# Result: [translation_units, segments]
# translation_units = [tu_id]
# segments = [tu_id, segment_role, word_count, language, segment_text]

XlfImporter::Xlf.new(file_path: file_path).import
# => [[["6234-1457917153-1"]], [["6234-1457917153-1", "source", 2, "en", "Hello world"], ["6234-1457917153-1", "target", 3, "fr", "Bonjour le monde"], ["6234-1457917153-1", "target", 2, "es", "Hola mundo"]]]
```

## Contributing

1. Fork it ( https://github.com/diasks2/xlf_importer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2016 Kevin S. Dias

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
