# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-docs'
  spec.version       = ENV.fetch('JEKYLL_VERSION')
  spec.authors       = ['Parker Moore']
  spec.email         = ['parkrmoore@gmail.com']
  spec.summary       = %q{Offline usage documentation for Jekyll.}
  spec.homepage      = 'http://jekyllrb.com'
  spec.license       = 'MIT'

  spec.files         = Dir['**/*'].grep(%r{^(lib|site)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'jekyll', ENV.fetch('JEKYLL_VERSION')

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
