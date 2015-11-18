# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-docs'
  spec.version       = Jekyll::VERSION
  spec.authors       = ['Parker Moore']
  spec.email         = ['parkrmoore@gmail.com']
  spec.summary       = %q{Offline usage documentation for Jekyll.}
  spec.homepage      = 'http://jekyllrb.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").grep(%r{^site/})
  spec.require_paths = ['lib']

  spec.add_dependency 'jekyll', Jekyll::VERSION

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
