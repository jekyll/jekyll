Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'jekyll'
  s.version           = '0.11.2'
  s.date              = '2011-12-27'
  s.rubyforge_project = 'jekyll'

  s.summary     = "A simple, blog aware, static site generator."
  s.description = "Jekyll is a simple, blog aware, static site generator."

  s.authors  = ["Tom Preston-Werner"]
  s.email    = 'tom@mojombo.com'
  s.homepage = 'http://github.com/mojombo/jekyll'

  s.require_paths = %w[lib]

  s.executables = ["jekyll"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.textile LICENSE]

  s.add_runtime_dependency('liquid', "~> 2.3")
  s.add_runtime_dependency('classifier', "~> 1.3")
  s.add_runtime_dependency('directory_watcher', "~> 1.1")
  s.add_runtime_dependency('maruku', "~> 0.5")
  s.add_runtime_dependency('kramdown', "~> 0.13.4")
  s.add_runtime_dependency('pygments.rb', "~> 0.2.12")

  s.add_development_dependency('rake', "~> 0.9")
  s.add_development_dependency('rdoc', "~> 3.11")
  s.add_development_dependency('redgreen', "~> 1.2")
  s.add_development_dependency('shoulda', "~> 2.11")
  s.add_development_dependency('rr', "~> 1.0")
  s.add_development_dependency('cucumber', "1.1")
  s.add_development_dependency('RedCloth', "~> 4.2")
  s.add_development_dependency('rdiscount', "~> 1.6")
  s.add_development_dependency('redcarpet', "~> 1.9")
  
  # = MANIFEST =
  s.files = %w[
    Gemfile
    History.txt
    LICENSE
    README.textile
    Rakefile
    bin/jekyll
    cucumber.yml
    features/create_sites.feature
    features/embed_filters.feature
    features/markdown.feature
    features/pagination.feature
    features/permalinks.feature
    features/post_data.feature
    features/site_configuration.feature
    features/site_data.feature
    features/step_definitions/jekyll_steps.rb
    features/support/env.rb
    jekyll.gemspec
    lib/jekyll.rb
    lib/jekyll/converter.rb
    lib/jekyll/converters/identity.rb
    lib/jekyll/converters/markdown.rb
    lib/jekyll/converters/textile.rb
    lib/jekyll/convertible.rb
    lib/jekyll/core_ext.rb
    lib/jekyll/errors.rb
    lib/jekyll/filters.rb
    lib/jekyll/generator.rb
    lib/jekyll/generators/pagination.rb
    lib/jekyll/layout.rb
    lib/jekyll/migrators/csv.rb
    lib/jekyll/migrators/drupal.rb
    lib/jekyll/migrators/enki.rb
    lib/jekyll/migrators/marley.rb
    lib/jekyll/migrators/mephisto.rb
    lib/jekyll/migrators/mt.rb
    lib/jekyll/migrators/posterous.rb
    lib/jekyll/migrators/textpattern.rb
    lib/jekyll/migrators/tumblr.rb
    lib/jekyll/migrators/typo.rb
    lib/jekyll/migrators/wordpress.rb
    lib/jekyll/migrators/wordpressdotcom.rb
    lib/jekyll/page.rb
    lib/jekyll/plugin.rb
    lib/jekyll/post.rb
    lib/jekyll/site.rb
    lib/jekyll/static_file.rb
    lib/jekyll/tags/highlight.rb
    lib/jekyll/tags/include.rb
    test/helper.rb
    test/source/.htaccess
    test/source/_includes/sig.markdown
    test/source/_layouts/default.html
    test/source/_layouts/simple.html
    test/source/_posts/2008-02-02-not-published.textile
    test/source/_posts/2008-02-02-published.textile
    test/source/_posts/2008-10-18-foo-bar.textile
    test/source/_posts/2008-11-21-complex.textile
    test/source/_posts/2008-12-03-permalinked-post.textile
    test/source/_posts/2008-12-13-include.markdown
    test/source/_posts/2009-01-27-array-categories.textile
    test/source/_posts/2009-01-27-categories.textile
    test/source/_posts/2009-01-27-category.textile
    test/source/_posts/2009-01-27-empty-categories.textile
    test/source/_posts/2009-01-27-empty-category.textile
    test/source/_posts/2009-03-12-hash-#1.markdown
    test/source/_posts/2009-05-18-empty-tag.textile
    test/source/_posts/2009-05-18-empty-tags.textile
    test/source/_posts/2009-05-18-tag.textile
    test/source/_posts/2009-05-18-tags.textile
    test/source/_posts/2009-06-22-empty-yaml.textile
    test/source/_posts/2009-06-22-no-yaml.textile
    test/source/_posts/2010-01-08-triple-dash.markdown
    test/source/_posts/2010-01-09-date-override.textile
    test/source/_posts/2010-01-09-time-override.textile
    test/source/_posts/2010-01-09-timezone-override.textile
    test/source/_posts/2010-01-16-override-data.textile
    test/source/_posts/2011-04-12-md-extension.md
    test/source/_posts/2011-04-12-text-extension.text
    test/source/about.html
    test/source/category/_posts/2008-9-23-categories.textile
    test/source/contacts.html
    test/source/css/screen.css
    test/source/deal.with.dots.html
    test/source/foo/_posts/bar/2008-12-12-topical-post.textile
    test/source/index.html
    test/source/sitemap.xml
    test/source/win/_posts/2009-05-24-yaml-linebreak.markdown
    test/source/z_category/_posts/2008-9-23-categories.textile
    test/suite.rb
    test/test_configuration.rb
    test/test_core_ext.rb
    test/test_filters.rb
    test/test_generated_site.rb
    test/test_kramdown.rb
    test/test_page.rb
    test/test_pager.rb
    test/test_post.rb
    test/test_rdiscount.rb
    test/test_redcarpet.rb
    test/test_site.rb
    test/test_tags.rb
    test/test_redcloth.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
