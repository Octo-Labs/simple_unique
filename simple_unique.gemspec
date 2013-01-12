# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_unique/version'

Gem::Specification.new do |gem|
  gem.name          = "simple_unique"
  gem.version       = SimpleUnique::VERSION
  gem.authors       = ["Jeremy Green"]
  gem.email         = ["jeremy@octolabs.com"]
  gem.description   = %q{Validations for AWS::Record::Model}
  gem.summary       = %q{Validations for AWS::Record::Model}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "aws-sdk", "~> 1.8.0"
  gem.add_development_dependency "rspec", ">= 2.0.0"

end
