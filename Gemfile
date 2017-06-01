source "https://rubygems.org"
gemspec :name => "jekyll"

gem "rake", "~> 12.0"

# Dependency of jekyll-mentions. RubyGems in Ruby 2.1 doesn't shield us from this.
gem "activesupport", "~> 4.2", :groups => [:test_legacy, :site] if RUBY_VERSION < "2.2.2"

group :development do
  gem "launchy", "~> 2.3"
  gem "pry"

  unless RUBY_ENGINE == "jruby"
    gem "pry-byebug"
  end
end

#

group :test do
  gem "codeclimate-test-reporter", "~> 1.0.5"
  gem "cucumber", "~> 2.1"
  gem "jekyll_test_plugin"
  gem "jekyll_test_plugin_malicious"
  gem "nokogiri"
  gem "rspec"
  gem "rspec-mocks"
  gem "rubocop", "~> 0.48.1"
  gem "test-dependency-theme", :path => File.expand_path("./test/fixtures/test-dependency-theme", File.dirname(__FILE__))
  gem "test-theme", :path => File.expand_path("./test/fixtures/test-theme", File.dirname(__FILE__))

  gem "jruby-openssl" if RUBY_ENGINE == "jruby"
end

#

group :test_legacy do
  if RUBY_PLATFORM =~ %r!cygwin! || RUBY_VERSION.start_with?("2.2")
    gem "test-unit"
  end

  gem "minitest"
  gem "minitest-profile"
  gem "minitest-reporters"
  gem "redgreen"
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
  gem "coderay", "~> 1.1.0"
  gem "jekyll-coffeescript"
  gem "jekyll-docs", :path => "../docs" if Dir.exist?("../docs") && ENV["JEKYLL_VERSION"]
  gem "jekyll-feed"
  gem "jekyll-gist"
  gem "jekyll-paginate"
  gem "jekyll-redirect-from"
  gem "kramdown", "~> 1.9"
  gem "mime-types", "~> 3.0"
  gem "rdoc", "~> 5.0"
  gem "toml", "~> 0.1.0"

  platform :ruby, :mswin, :mingw, :x64_mingw do
    gem "classifier-reborn", "~> 2.1.0"
    gem "liquid-c", "~> 3.0"
    gem "pygments.rb", "~> 0.6.0"
    gem "rdiscount", "~> 2.0"
    gem "redcarpet", "~> 3.2", ">= 3.2.3"
    gem "yajl-ruby", "~> 1.2"
  end

  # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
  gem "tzinfo-data", :platforms => [:mingw, :mswin, :x64_mingw, :jruby]
end

#

group :site do
  if ENV["PROOF"]
    gem "html-proofer", "~> 3.4"
  end

  gem "jekyll-avatar"
  gem "jekyll-mentions"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
  gem "jemoji"
end
