Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'jekyll'
  s.version           = '1.2.1'
  s.license           = 'MIT'
  s.date              = '2013-09-14'
  s.rubyforge_project = 'jekyll'

  s.summary     = "A simple, blog aware, static site generator."
  s.description = "Jekyll is a simple, blog aware, static site generator."

  s.authors  = ["Tom Preston-Werner"]
  s.email    = 'tom@mojombo.com'
  s.homepage = 'http://github.com/mojombo/jekyll'

  s.require_paths = %w[lib]

  s.executables = ["jekyll"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.markdown LICENSE]

  s.add_runtime_dependency('liquid', "~> 2.5.2")
  s.add_runtime_dependency('classifier', "~> 1.3")
  s.add_runtime_dependency('listen', "~> 1.3")
  s.add_runtime_dependency('maruku', "~> 0.7.0.beta1")
  s.add_runtime_dependency('pygments.rb', "~> 0.5.0")
  s.add_runtime_dependency('commander', "~> 4.1.3")
  s.add_runtime_dependency('safe_yaml', "~> 0.9.7")
  s.add_runtime_dependency('colorator', "~> 0.1")
  s.add_runtime_dependency('redcarpet', "~> 2.3.0")

  s.add_development_dependency('rake', "~> 10.1")
  s.add_development_dependency('rdoc', "~> 3.11")
  s.add_development_dependency('redgreen', "~> 1.2")
  s.add_development_dependency('shoulda', "~> 3.3.2")
  s.add_development_dependency('rr', "~> 1.1")
  s.add_development_dependency('cucumber', "~> 1.3")
  s.add_development_dependency('RedCloth', "~> 4.2")
  s.add_development_dependency('kramdown', "~> 1.2")
  s.add_development_dependency('rdiscount', "~> 1.6")
  s.add_development_dependency('launchy', "~> 2.3")
  s.add_development_dependency('simplecov', "~> 0.7")
  s.add_development_dependency('simplecov-gem-adapter', "~> 1.0.1")
  s.add_development_dependency('coveralls', "~> 0.7.0")
  s.add_development_dependency('mime-types', "~> 1.5")
  s.add_development_dependency('activesupport', '~> 3.2.13')
  s.add_development_dependency('jekyll_test_plugin')

  # = MANIFEST =
  s.files = %w[
    CONTRIBUTING.markdown
    Gemfile
    History.markdown
    LICENSE
    README.markdown
    Rakefile
    bin/jekyll
    cucumber.yml
    features/create_sites.feature
    features/data.feature
    features/drafts.feature
    features/embed_filters.feature
    features/include_tag.feature
    features/markdown.feature
    features/pagination.feature
    features/permalinks.feature
    features/post_data.feature
    features/post_excerpts.feature
    features/site_configuration.feature
    features/site_data.feature
    features/step_definitions/jekyll_steps.rb
    features/support/env.rb
    jekyll.gemspec
    lib/jekyll.rb
    lib/jekyll/cleaner.rb
    lib/jekyll/command.rb
    lib/jekyll/commands/build.rb
    lib/jekyll/commands/doctor.rb
    lib/jekyll/commands/new.rb
    lib/jekyll/commands/serve.rb
    lib/jekyll/configuration.rb
    lib/jekyll/converter.rb
    lib/jekyll/converters/identity.rb
    lib/jekyll/converters/markdown.rb
    lib/jekyll/converters/markdown/kramdown_parser.rb
    lib/jekyll/converters/markdown/maruku_parser.rb
    lib/jekyll/converters/markdown/rdiscount_parser.rb
    lib/jekyll/converters/markdown/redcarpet_parser.rb
    lib/jekyll/converters/textile.rb
    lib/jekyll/convertible.rb
    lib/jekyll/core_ext.rb
    lib/jekyll/deprecator.rb
    lib/jekyll/draft.rb
    lib/jekyll/errors.rb
    lib/jekyll/excerpt.rb
    lib/jekyll/filters.rb
    lib/jekyll/generator.rb
    lib/jekyll/generators/pagination.rb
    lib/jekyll/layout.rb
    lib/jekyll/mime.types
    lib/jekyll/page.rb
    lib/jekyll/plugin.rb
    lib/jekyll/post.rb
    lib/jekyll/related_posts.rb
    lib/jekyll/site.rb
    lib/jekyll/static_file.rb
    lib/jekyll/stevenson.rb
    lib/jekyll/tags/gist.rb
    lib/jekyll/tags/highlight.rb
    lib/jekyll/tags/include.rb
    lib/jekyll/tags/post_url.rb
    lib/jekyll/url.rb
    lib/site_template/.gitignore
    lib/site_template/_config.yml
    lib/site_template/_layouts/default.html
    lib/site_template/_layouts/post.html
    lib/site_template/_posts/0000-00-00-welcome-to-jekyll.markdown.erb
    lib/site_template/css/main.css
    lib/site_template/css/syntax.css
    lib/site_template/index.html
    script/bootstrap
    site/.gitignore
    site/CNAME
    site/README
    site/_config.yml
    site/_includes/analytics.html
    site/_includes/docs_contents.html
    site/_includes/docs_contents_mobile.html
    site/_includes/docs_option.html
    site/_includes/docs_ul.html
    site/_includes/footer.html
    site/_includes/header.html
    site/_includes/news_contents.html
    site/_includes/news_contents_mobile.html
    site/_includes/news_item.html
    site/_includes/primary-nav-items.html
    site/_includes/section_nav.html
    site/_includes/top.html
    site/_layouts/default.html
    site/_layouts/docs.html
    site/_layouts/news.html
    site/_layouts/news_item.html
    site/_posts/2013-05-06-jekyll-1-0-0-released.markdown
    site/_posts/2013-05-08-jekyll-1-0-1-released.markdown
    site/_posts/2013-05-12-jekyll-1-0-2-released.markdown
    site/_posts/2013-06-07-jekyll-1-0-3-released.markdown
    site/_posts/2013-07-14-jekyll-1-1-0-released.markdown
    site/_posts/2013-07-24-jekyll-1-1-1-released.markdown
    site/_posts/2013-07-25-jekyll-1-0-4-released.markdown
    site/_posts/2013-07-25-jekyll-1-1-2-released.markdown
    site/_posts/2013-09-06-jekyll-1-2-0-released.markdown
    site/_posts/2013-09-14-jekyll-1-2-1-released.markdown
    site/css/gridism.css
    site/css/normalize.css
    site/css/pygments.css
    site/css/style.css
    site/docs/configuration.md
    site/docs/contributing.md
    site/docs/deployment-methods.md
    site/docs/drafts.md
    site/docs/extras.md
    site/docs/frontmatter.md
    site/docs/github-pages.md
    site/docs/heroku.md
    site/docs/history.md
    site/docs/index.md
    site/docs/installation.md
    site/docs/migrations.md
    site/docs/pages.md
    site/docs/pagination.md
    site/docs/permalinks.md
    site/docs/plugins.md
    site/docs/posts.md
    site/docs/quickstart.md
    site/docs/resources.md
    site/docs/sites.md
    site/docs/structure.md
    site/docs/templates.md
    site/docs/troubleshooting.md
    site/docs/upgrading.md
    site/docs/usage.md
    site/docs/variables.md
    site/favicon.png
    site/feed.xml
    site/freenode.txt
    site/img/article-footer.png
    site/img/footer-arrow.png
    site/img/footer-logo.png
    site/img/logo-2x.png
    site/img/octojekyll.png
    site/img/tube.png
    site/img/tube1x.png
    site/index.html
    site/js/modernizr-2.5.3.min.js
    site/news/index.html
    site/news/releases/index.html
    test/fixtures/broken_front_matter1.erb
    test/fixtures/broken_front_matter2.erb
    test/fixtures/broken_front_matter3.erb
    test/fixtures/exploit_front_matter.erb
    test/fixtures/front_matter.erb
    test/helper.rb
    test/source/+/foo.md
    test/source/.htaccess
    test/source/_data/members.yaml
    test/source/_includes/params.html
    test/source/_includes/sig.markdown
    test/source/_layouts/default.html
    test/source/_layouts/simple.html
    test/source/_plugins/dummy.rb
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
    test/source/_posts/2013-01-02-post-excerpt.markdown
    test/source/_posts/2013-01-12-nil-layout.textile
    test/source/_posts/2013-01-12-no-layout.textile
    test/source/_posts/2013-03-19-not-a-post.markdown/.gitkeep
    test/source/_posts/2013-04-11-custom-excerpt.markdown
    test/source/_posts/2013-05-10-number-category.textile
    test/source/_posts/2013-07-22-post-excerpt-with-layout.markdown
    test/source/_posts/2013-08-01-mkdn-extension.mkdn
    test/source/_posts/es/2008-11-21-nested.textile
    test/source/about.html
    test/source/category/_posts/2008-9-23-categories.textile
    test/source/contacts.html
    test/source/contacts/bar.html
    test/source/contacts/index.html
    test/source/css/screen.css
    test/source/deal.with.dots.html
    test/source/foo/_posts/bar/2008-12-12-topical-post.textile
    test/source/index.html
    test/source/sitemap.xml
    test/source/symlink-test/symlinked-dir
    test/source/symlink-test/symlinked-file
    test/source/win/_posts/2009-05-24-yaml-linebreak.markdown
    test/source/z_category/_posts/2008-9-23-categories.textile
    test/suite.rb
    test/test_command.rb
    test/test_configuration.rb
    test/test_convertible.rb
    test/test_core_ext.rb
    test/test_excerpt.rb
    test/test_filters.rb
    test/test_generated_site.rb
    test/test_kramdown.rb
    test/test_new_command.rb
    test/test_page.rb
    test/test_pager.rb
    test/test_post.rb
    test/test_rdiscount.rb
    test/test_redcarpet.rb
    test/test_redcloth.rb
    test/test_related_posts.rb
    test/test_site.rb
    test/test_tags.rb
    test/test_url.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
