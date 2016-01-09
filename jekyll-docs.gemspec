#!/bin/ruby
# Frozen-String-Literal: true
# Encoding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/version'

Gem::Specification.new do |spec|
  spec.name = 'jekyll-docs'
  spec.version = Jekyll::VERSION
  spec.authors = ['Parker Moore']
  spec.summary = %(Offline usage documentation for Jekyll.)
  spec.email = ['parkrmoore@gmail.com']
  spec.homepage = 'http://jekyllrb.com'
  spec.license = 'MIT'

  spec.add_dependency 'jekyll', Jekyll::VERSION
  spec.files = `git ls-files -z`.split("\x0").grep(%r!^site/!)
  spec.require_paths = ['lib']
end
