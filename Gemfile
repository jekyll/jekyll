# frozen_string_literal: true

source "https://rubygems.org"
gemspec :name => "jekyll"

# Temporarily lock JRuby builds on Travis CI to i18n-1.2.x until JRuby is able to handle
# refinements introduced in i18n-1.3.0
gem "i18n", "~> 1.2.0" if RUBY_ENGINE == "jruby"

gem "rake", "~> 12.0"

group :development do
  gem "launchy", "~> 2.3"
  gem "pry"

  gem "pry-byebug" unless RUBY_ENGINE == "jruby"
end

#

group :test do
  gem "cucumber", "~> 3.0"
  gem "httpclient"
  gem "jekyll_test_plugin"
  gem "jekyll_test_plugin_malicious"
  gem "nokogiri", "~> 1.7"
  gem "rspec"
  gem "rspec-mocks"
  gem "rubocop", "~> 0.68.0"
  gem "rubocop-performance"
  gem "test-dependency-theme", :path => File.expand_path("test/fixtures/test-dependency-theme", __dir__)
  gem "test-theme", :path => File.expand_path("test/fixtures/test-theme", __dir__)
  gem "test-theme-symlink", :path => File.expand_path("test/fixtures/test-theme-symlink", __dir__)

  gem "jruby-openssl" if RUBY_ENGINE == "jruby"
end

#

group :test_legacy do
  gem "test-unit" if RUBY_PLATFORM =~ %r!cygwin!

  gem "minitest"
  gem "minitest-profile"
  gem "minitest-reporters"
  gem "shoulda"
  gem "simplecov"
end

#

group :benchmark do
  if ENV["BENCHMARK"]
    gem "benchmark-ips"
    gem "rbtrace"
    gem "ruby-prof"
    gem "stackprof"
  end
end

#

group :jekyll_optional_dependencies do
  gem "jekyll-coffeescript"
  gem "jekyll-docs", :path => "../docs" if Dir.exist?("../docs") && ENV["JEKYLL_VERSION"]
  gem "jekyll-feed", "~> 0.9"
  gem "jekyll-gist"
  gem "jekyll-paginate"
  gem "jekyll-redirect-from"
  gem "kramdown-syntax-coderay"
  gem "mime-types", "~> 3.0"
  gem "rdoc", "~> 6.0"
  gem "tomlrb", "~> 1.2"

  platform :ruby, :mswin, :mingw, :x64_mingw do
    gem "classifier-reborn", "~> 2.2"
    gem "liquid-c", "~> 4.0"
    gem "yajl-ruby", "~> 1.4"
  end

  # Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
  # and associated library
  install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
    gem "tzinfo", "~> 1.2"
    gem "tzinfo-data"
  end
end

#

group :site do
  gem "html-proofer", "~> 3.4" if ENV["PROOF"]

  gem "jekyll-avatar"
  gem "jekyll-mentions"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
  gem "jemoji"
end
