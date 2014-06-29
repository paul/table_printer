# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'table_printer/version'

Gem::Specification.new do |spec|
  spec.name          = "table_printer"
  spec.version       = TablePrinter::VERSION
  spec.authors       = ["Paul Sadauskas"]
  spec.email         = ["psadauskas@gmail.com"]
  spec.summary       = %q{A simple ASCII table printer}
  spec.description   = %q{Prints a nice ACSII table for your data, with smart defaults about numbers and times}
  spec.homepage      = "https://github.com/paul/table_printer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end
