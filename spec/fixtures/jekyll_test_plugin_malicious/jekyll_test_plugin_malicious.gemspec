# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll_test_plugin_malicious/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll_test_plugin_malicious"
  spec.version       = JekyllTestPluginMalicious::VERSION
  spec.authors       = ["Parker Moore"]
  spec.email         = ["parkrmoore@gmail.com"]
  spec.description   = %q{A malicious gem for Jekyll (for testing)}
  spec.summary       = %q{A malicious gem for Jekyll (for testing)}
  spec.homepage      = "https://github.com/jekyll/jekyll-test-plugin-malicious"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "jekyll"
end
