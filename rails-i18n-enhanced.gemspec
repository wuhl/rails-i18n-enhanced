# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/i18n/enhanced/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-i18n-enhanced"
  spec.version       = Rails::I18n::Enhanced::VERSION
  spec.authors       = ["Wolfgang Uhl"]
  spec.email         = ["wolfgang.uhl@googlemail.com"]
  spec.description   = %q{Enhanced rails-i18n gem}
  spec.summary       = %q{Enhanced rails-i18n gem}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails-i18n'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
