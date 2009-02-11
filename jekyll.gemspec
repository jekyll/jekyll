# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jekyll}
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Preston-Werner"]
  s.date = %q{2009-02-10}
  s.default_executable = %q{jekyll}
  s.description = %q{Jekyll is a simple, blog aware, static site generator.}
  s.email = %q{tom@mojombo.com}
  s.executables = ["jekyll"]
  s.files = ["History.txt", "README.textile", "VERSION.yml", "bin/jekyll", "lib/jekyll", "lib/jekyll/albino.rb", "lib/jekyll/converters", "lib/jekyll/converters/csv.rb", "lib/jekyll/converters/mephisto.rb", "lib/jekyll/converters/mt.rb", "lib/jekyll/converters/textpattern.rb", "lib/jekyll/converters/typo.rb", "lib/jekyll/converters/wordpress.rb", "lib/jekyll/convertible.rb", "lib/jekyll/core_ext.rb", "lib/jekyll/filters.rb", "lib/jekyll/layout.rb", "lib/jekyll/page.rb", "lib/jekyll/post.rb", "lib/jekyll/site.rb", "lib/jekyll/tags", "lib/jekyll/tags/highlight.rb", "lib/jekyll/tags/include.rb", "lib/jekyll.rb", "test/dest", "test/dest/2008", "test/dest/2008/10", "test/dest/2008/10/18", "test/dest/2008/10/18/foo-bar.html", "test/dest/2008/11", "test/dest/2008/11/21", "test/dest/2008/11/21/complex.html", "test/dest/2008/12", "test/dest/2008/12/13", "test/dest/2008/12/13/include.html", "test/dest/_posts", "test/dest/_posts/2008-10-18-foo-bar.html", "test/dest/_posts/2008-11-21-complex.html", "test/dest/_posts/2008-12-03-permalinked-post.html", "test/dest/_posts/2008-12-13-include.html", "test/dest/category", "test/dest/category/2008", "test/dest/category/2008/09", "test/dest/category/2008/09/23", "test/dest/category/2008/09/23/categories.html", "test/dest/category/_posts", "test/dest/category/_posts/2008-9-23-categories.html", "test/dest/css", "test/dest/css/screen.css", "test/dest/foo", "test/dest/foo/2008", "test/dest/foo/2008/12", "test/dest/foo/2008/12/12", "test/dest/foo/2008/12/12/topical-post.html", "test/dest/foo/_posts", "test/dest/foo/_posts/bar", "test/dest/foo/_posts/bar/2008-12-12-topical-post.html", "test/dest/index.html", "test/dest/my_category", "test/dest/my_category/permalinked-post", "test/dest/z_category", "test/dest/z_category/2008", "test/dest/z_category/2008/09", "test/dest/z_category/2008/09/23", "test/dest/z_category/2008/09/23/categories.html", "test/dest/z_category/_posts", "test/dest/z_category/_posts/2008-9-23-categories.html", "test/helper.rb", "test/source", "test/source/_includes", "test/source/_includes/sig.markdown", "test/source/_layouts", "test/source/_layouts/default.html", "test/source/_layouts/simple.html", "test/source/_posts", "test/source/_posts/2008-10-18-foo-bar.textile", "test/source/_posts/2008-11-21-complex.textile", "test/source/_posts/2008-12-03-permalinked-post.textile", "test/source/_posts/2008-12-13-include.markdown", "test/source/category", "test/source/category/_posts", "test/source/category/_posts/2008-9-23-categories.textile", "test/source/css", "test/source/css/screen.css", "test/source/foo", "test/source/foo/_posts", "test/source/foo/_posts/bar", "test/source/foo/_posts/bar/2008-12-12-topical-post.textile", "test/source/index.html", "test/source/z_category", "test/source/z_category/_posts", "test/source/z_category/_posts/2008-9-23-categories.textile", "test/suite.rb", "test/test_filters.rb", "test/test_generated_site.rb", "test/test_jekyll.rb", "test/test_post.rb", "test/test_site.rb", "test/test_tags.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mojombo/jekyll}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jekyll}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Jekyll is a simple, blog aware, static site generator.}

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
