# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xlf_importer/version'

Gem::Specification.new do |spec|
  spec.name          = "xlf_importer"
  spec.version       = XlfImporter::VERSION
  spec.authors       = ["Kevin S. Dias"]
  spec.email         = ["diasks2@gmail.com"]

  spec.summary       = %q{XLIFF / XLF file importer}
  spec.description   = %q{Import the translation content of a XLIFF localisation file.}
  spec.homepage      = "https://github.com/diasks2/xlf_importer"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "libxml-ruby"
#   spec.add_runtime_dependency "pretty_strings", "~> 0.7.0"
#   spec.add_runtime_dependency "charlock_holmes_bundle_icu", "~> 0.6.9.2"
end
