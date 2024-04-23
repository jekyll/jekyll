# frozen_string_literal: true

require "English"
require_relative "lib/jekyll/version"

Gem::Specification.new do |s|
  s.name          = "jekyll"
  s.version       = Jekyll::VERSION
  s.license       = "MIT"
  s.authors       = ["Tom Preston-Werner", "Parker Moore", "Matt Rogers"]
  s.email         = ["maintainers@jekyllrb.com"]
  s.homepage      = "https://jekyllrb.com"
  s.summary       = "A simple, blog aware, static site generator."
  s.description   = "Jekyll is a simple, blog aware, static site generator."

  all_files       = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.files         = all_files.grep(%r!^(exe|lib|rubocop)/|^.rubocop.yml$!)
  s.executables   = all_files.grep(%r!^exe/!) { |f| File.basename(f) }
  s.bindir        = "exe"
  s.require_paths = ["lib"]

  s.metadata      = {
    "source_code_uri" => "https://github.com/jekyll/jekyll",
    "bug_tracker_uri" => "https://github.com/jekyll/jekyll/issues",
    "changelog_uri"   => "https://github.com/jekyll/jekyll/releases",
    "homepage_uri"    => s.homepage,
  }

  s.rdoc_options     = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w(README.markdown LICENSE)

  s.required_ruby_version     = ">= 2.7.0"
  s.required_rubygems_version = ">= 2.7.0"

  s.add_dependency("csv",                           "~> 3.0")

  s.add_runtime_dependency("addressable",           "~> 2.4")
  s.add_runtime_dependency("colorator",             "~> 1.0")
  s.add_runtime_dependency("em-websocket",          "~> 0.5")
  s.add_runtime_dependency("i18n",                  "~> 1.0")
  s.add_runtime_dependency("jekyll-sass-converter", ">= 2.0", "< 4.0")
  s.add_runtime_dependency("jekyll-watch",          "~> 2.0")
  s.add_runtime_dependency("kramdown",              "~> 2.3", ">= 2.3.1")
  s.add_runtime_dependency("kramdown-parser-gfm",   "~> 1.0")
  s.add_runtime_dependency("liquid",                "~> 4.0")
  s.add_runtime_dependency("mercenary",             ">= 0.3.6", "< 0.5")
  s.add_runtime_dependency("pathutil",              "~> 0.9")
  s.add_runtime_dependency("rouge",                 ">= 3.0", "< 5.0")
  s.add_runtime_dependency("safe_yaml",             "~> 1.0")
  s.add_runtime_dependency("terminal-table",        ">= 1.8", "< 4.0")
  s.add_runtime_dependency("webrick",               "~> 1.7")
end
