# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/version'

Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '2.2.2'
  s.required_ruby_version = '>= 1.9.3'

  s.name              = 'jekyll'
  s.version           = Jekyll::VERSION
  s.license           = 'MIT'

  s.summary     = "A simple, blog aware, static site generator."
  s.description = "Jekyll is a simple, blog aware, static site generator."

  s.authors  = ["Tom Preston-Werner"]
  s.email    = 'tom@mojombo.com'
  s.homepage = 'https://github.com/jekyll/jekyll'

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r{^(bin|lib)/})
  s.executables   = all_files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.markdown LICENSE]

  s.add_runtime_dependency('liquid',    "~> 2.6.1")
  s.add_runtime_dependency('kramdown',  "~> 1.3")
  s.add_runtime_dependency('mercenary', "~> 0.3.3")
  s.add_runtime_dependency('safe_yaml', "~> 1.0")
  s.add_runtime_dependency('colorator', "~> 0.1")

  # Before 3.0 drops, phase the following gems out as dev dependencies
  # and gracefully handle their absence.
  s.add_runtime_dependency('pygments.rb', "~> 0.6.0")
  s.add_runtime_dependency('redcarpet', "~> 3.1")
  s.add_runtime_dependency('toml', '~> 0.1.0')
  s.add_runtime_dependency('jekyll-paginate', '~> 1.0')
  s.add_runtime_dependency('jekyll-gist', '~> 1.0')
  s.add_runtime_dependency('jekyll-coffeescript', '~> 1.0')
  s.add_runtime_dependency('jekyll-sass-converter', '~> 1.0')
  s.add_runtime_dependency('jekyll-watch', '~> 1.1')
  s.add_runtime_dependency('classifier-reborn', "~> 2.0")

  s.add_development_dependency('rake', "~> 10.1")
  s.add_development_dependency('rdoc', "~> 3.11")
  s.add_development_dependency('redgreen', "~> 1.2")
  s.add_development_dependency('shoulda', "~> 3.5")
  s.add_development_dependency('rr', "~> 1.1")
  s.add_development_dependency('cucumber', "1.3.11")
  s.add_development_dependency('RedCloth', "~> 4.2")
  s.add_development_dependency('maruku', "~> 0.7.0")
  s.add_development_dependency('rdiscount', "~> 1.6")
  s.add_development_dependency('launchy', "~> 2.3")
  s.add_development_dependency('simplecov', "~> 0.9")
  s.add_development_dependency('simplecov-gem-adapter', "~> 1.0.1")
  s.add_development_dependency('mime-types', "~> 1.5")
  s.add_development_dependency('activesupport', '~> 3.2.13')
  s.add_development_dependency('jekyll_test_plugin')
  s.add_development_dependency('jekyll_test_plugin_malicious')
  s.add_development_dependency('rouge', '~> 1.3')
end
