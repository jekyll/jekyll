# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jekyll}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Preston-Werner"]
  s.date = %q{2009-04-07}
  s.default_executable = %q{jekyll}
  s.description = %q{Jekyll is a simple, blog aware, static site generator.}
  s.email = %q{tom@mojombo.com}
  s.executables = ["jekyll"]
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    "History.txt",
    "README.textile",
    "Rakefile",
    "VERSION.yml",
    "bin/jekyll",
    "lib/jekyll.rb",
    "lib/jekyll/albino.rb",
    "lib/jekyll/converters/csv.rb",
    "lib/jekyll/converters/mephisto.rb",
    "lib/jekyll/converters/mt.rb",
    "lib/jekyll/converters/textpattern.rb",
    "lib/jekyll/converters/typo.rb",
    "lib/jekyll/converters/wordpress.rb",
    "lib/jekyll/convertible.rb",
    "lib/jekyll/core_ext.rb",
    "lib/jekyll/filters.rb",
    "lib/jekyll/layout.rb",
    "lib/jekyll/page.rb",
    "lib/jekyll/post.rb",
    "lib/jekyll/site.rb",
    "lib/jekyll/tags/highlight.rb",
    "lib/jekyll/tags/include.rb",
    "test/helper.rb",
    "test/source/_includes/sig.markdown",
    "test/source/_layouts/default.html",
    "test/source/_layouts/simple.html",
    "test/source/_posts/2008-02-02-not-published.textile",
    "test/source/_posts/2008-02-02-published.textile",
    "test/source/_posts/2008-10-18-foo-bar.textile",
    "test/source/_posts/2008-11-21-complex.textile",
    "test/source/_posts/2008-12-03-permalinked-post.textile",
    "test/source/_posts/2008-12-13-include.markdown",
    "test/source/_posts/2009-01-27-array-categories.textile",
    "test/source/_posts/2009-01-27-categories.textile",
    "test/source/_posts/2009-01-27-category.textile",
    "test/source/category/_posts/2008-9-23-categories.textile",
    "test/source/css/screen.css",
    "test/source/foo/_posts/bar/2008-12-12-topical-post.textile",
    "test/source/index.html",
    "test/source/z_category/_posts/2008-9-23-categories.textile",
    "test/suite.rb",
    "test/test_filters.rb",
    "test/test_generated_site.rb",
    "test/test_post.rb",
    "test/test_site.rb",
    "test/test_tags.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mojombo/jekyll}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jekyll}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Jekyll is a simple, blog aware, static site generator.}
  s.test_files = [
    "test/helper.rb",
    "test/suite.rb",
    "test/test_filters.rb",
    "test/test_generated_site.rb",
    "test/test_post.rb",
    "test/test_site.rb",
    "test/test_tags.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<RedCloth>, [">= 4.0.4"])
      s.add_runtime_dependency(%q<liquid>, [">= 1.9.0"])
      s.add_runtime_dependency(%q<classifier>, [">= 1.3.1"])
      s.add_runtime_dependency(%q<maruku>, [">= 0.5.9"])
      s.add_runtime_dependency(%q<directory_watcher>, [">= 1.1.1"])
      s.add_runtime_dependency(%q<open4>, [">= 0.9.6"])
    else
      s.add_dependency(%q<RedCloth>, [">= 4.0.4"])
      s.add_dependency(%q<liquid>, [">= 1.9.0"])
      s.add_dependency(%q<classifier>, [">= 1.3.1"])
      s.add_dependency(%q<maruku>, [">= 0.5.9"])
      s.add_dependency(%q<directory_watcher>, [">= 1.1.1"])
      s.add_dependency(%q<open4>, [">= 0.9.6"])
    end
  else
    s.add_dependency(%q<RedCloth>, [">= 4.0.4"])
    s.add_dependency(%q<liquid>, [">= 1.9.0"])
    s.add_dependency(%q<classifier>, [">= 1.3.1"])
    s.add_dependency(%q<maruku>, [">= 0.5.9"])
    s.add_dependency(%q<directory_watcher>, [">= 1.1.1"])
    s.add_dependency(%q<open4>, [">= 0.9.6"])
  end
end
