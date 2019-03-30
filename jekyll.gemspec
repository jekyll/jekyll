# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll/version"

Gem::Specification.new do |s|
  s.name          = "jekyll"
  s.version       = Jekyll::VERSION
  s.license       = "MIT"
  s.authors       = ["Tom Preston-Werner", "Parker Moore", "Matt Rogers"]
  s.email         = ["maintainers@jekyllrb.com"]
  s.homepage      = "https://jekyllrb.com"
  s.summary       = "A simple, blog aware, static site generator."
  s.description   = "Jekyll is a simple, blog aware, static site generator."

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r!^(exe|lib|rubocop)/|^.rubocop.yml$!)
  s.executables   = all_files.grep(%r!^exe/!) { |f| File.basename(f) }
  s.bindir        = "exe"
  s.require_paths = ["lib"]

  s.metadata      = {
    "bug_tracker_uri" => "https://github.com/jekyll/jekyll/issues",
    "changelog_uri"   => "https://github.com/jekyll/jekyll/releases",
    "homepage_uri"    => "https://jekyllrb.com",
    "source_code_uri" => "https://github.com/jekyll/jekyll",
  }

  s.rdoc_options     = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w(README.markdown LICENSE)

  s.required_ruby_version     = ">= 2.4.0"
  s.required_rubygems_version = ">= 2.7.0"

  s.add_runtime_dependency("addressable",           "~> 2.4")
  s.add_runtime_dependency("colorator",             "~> 1.0")
  s.add_runtime_dependency("em-websocket",          "~> 0.5")
  s.add_runtime_dependency("i18n",                  ">= 0.9.5", "< 2")
  s.add_runtime_dependency("jekyll-sass-converter", "~> 1.0")
  s.add_runtime_dependency("jekyll-watch",          "~> 2.0")
  s.add_runtime_dependency("kramdown",              "~> 2.1")
  s.add_runtime_dependency("kramdown-parser-gfm",   "~> 1.0")
  s.add_runtime_dependency("liquid",                "~> 4.0")
  s.add_runtime_dependency("mercenary",             "~> 0.3.3")
  s.add_runtime_dependency("pathutil",              "~> 0.9")
  s.add_runtime_dependency("rouge",                 "~> 3.0")
  s.add_runtime_dependency("safe_yaml",             "~> 1.0")

  s.post_install_message = <<~MSG
    ----------------------------------------------------------------------------------
    This version of Jekyll comes with some major changes.

    Most notably:
      * Our `link` tag now comes with the `relative_url` filter incorporated into it.
        You should no longer prepend `{{ site.baseurl }}` to `{% link foo.md %}`
        For further details: https://github.com/jekyll/jekyll/pull/6727

      * Our `post_url` tag now comes with the `relative_url` filter incorporated into it.
        You shouldn't prepend `{{ site.baseurl }}` to `{% post_url 2019-03-27-hello %}`
        For further details: https://github.com/jekyll/jekyll/pull/7589
    ----------------------------------------------------------------------------------
  MSG
end
