Gem::Specification.new do |s|
  s.name = %q{jekyll}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Preston-Werner"]
  s.date = %q{2008-12-15}
  s.default_executable = %q{jekyll}
  s.email = ["tom@mojombo.com"]
  s.executables = ["jekyll"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.textile", "Rakefile", "bin/jekyll", "jekyll.gemspec", "lib/jekyll.rb", "lib/jekyll/albino.rb", "lib/jekyll/converters/csv.rb", "lib/jekyll/converters/mephisto.rb", "lib/jekyll/convertible.rb", "lib/jekyll/filters.rb", "lib/jekyll/layout.rb", "lib/jekyll/page.rb", "lib/jekyll/post.rb", "lib/jekyll/site.rb", "lib/jekyll/tags/highlight.rb", "lib/jekyll/tags/include.rb", "test/helper.rb", "test/source/_includes/sig.markdown", "test/source/_layouts/default.html", "test/source/_layouts/simple.html", "test/source/_posts/2008-10-18-foo-bar.textile", "test/source/_posts/2008-11-21-complex.textile", "test/source/_posts/2008-12-13-include.markdown", "test/source/css/screen.css", "test/source/index.html", "test/source/posts/2008-12-03-permalinked-post.textile", "test/suite.rb", "test/test_jekyll.rb", "test/test_post.rb", "test/test_site.rb"]
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jekyll}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Jekyll is a simple, blog aware, static site generator.}
  s.test_files = ["test/test_jekyll.rb", "test/test_post.rb", "test/test_site.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<RedCloth>, [">= 0"])
      s.add_runtime_dependency(%q<liquid>, [">= 0"])
      s.add_runtime_dependency(%q<classifier>, [">= 0"])
      s.add_runtime_dependency(%q<maruku>, [">= 0"])
      s.add_runtime_dependency(%q<directory_watcher>, [">= 0"])
      s.add_runtime_dependency(%q<open4>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<RedCloth>, [">= 0"])
      s.add_dependency(%q<liquid>, [">= 0"])
      s.add_dependency(%q<classifier>, [">= 0"])
      s.add_dependency(%q<maruku>, [">= 0"])
      s.add_dependency(%q<directory_watcher>, [">= 0"])
      s.add_dependency(%q<open4>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<RedCloth>, [">= 0"])
    s.add_dependency(%q<liquid>, [">= 0"])
    s.add_dependency(%q<classifier>, [">= 0"])
    s.add_dependency(%q<maruku>, [">= 0"])
    s.add_dependency(%q<directory_watcher>, [">= 0"])
    s.add_dependency(%q<open4>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
