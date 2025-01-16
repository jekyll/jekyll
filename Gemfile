# frozen_string_literal: true

source "https://rubygems.org"
gemspec :name => "jekyll"

gem "rake", "~> 13.0"

group :development do
  gem "launchy", "~> 2.3"
  gem "pry"

  gem "pry-byebug" unless RUBY_ENGINE == "jruby"
end

#

group :test do
  gem "activesupport", "< 7.1.0"
  gem "cucumber", "~> 9.0"
  gem "httpclient"
  gem "jekyll_test_plugin"
  gem "jekyll_test_plugin_malicious"
  gem "memory_profiler"

  # Runtime dependency of gem `httpclient`. _Needed only in Ruby 3.4+_.
  # Remove once gem `httpclient` ships with `mutex_m` listed as a dependency in its gemspec.
  gem "mutex_m", "~> 0.3" if RUBY_VERSION >= "3.4"

  gem "nokogiri", "~> 1.7"
  gem "rspec"
  gem "rspec-mocks"
  gem "rubocop", "~> 1.57.2"
  gem "rubocop-minitest"
  gem "rubocop-performance"
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "test-dependency-theme", :path => File.expand_path("test/fixtures/test-dependency-theme", __dir__)
  gem "test-theme", :path => File.expand_path("test/fixtures/test-theme", __dir__)
  gem "test-theme-skinny", :path => File.expand_path("test/fixtures/test-theme-skinny", __dir__)
  gem "test-theme-symlink", :path => File.expand_path("test/fixtures/test-theme-symlink", __dir__)
  gem "test-theme-w-empty-data", :path => File.expand_path("test/fixtures/test-theme-w-empty-data", __dir__)

  if RUBY_ENGINE == "jruby"
    gem "http_parser.rb", "~> 0.6.0"
    gem "jruby-openssl"
  end
end

#

group :test_legacy do
  gem "test-unit" if RUBY_PLATFORM =~ %r!cygwin!

  gem "minitest"
  gem "minitest-profile"
  gem "minitest-reporters"
  gem "shoulda-context"
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
  gem "matrix"
  gem "mime-types", "~> 3.0"
  gem "tomlrb"

  platforms :ruby, :mswin, :mingw, :x64_mingw do
    gem "classifier-reborn", "~> 2.2"
    gem "liquid-c", "~> 4.0"
    gem "yajl-ruby", "~> 1.4"
  end

  # Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
  # and associated library
  platforms :jruby, :mswin, :mingw, :x64_mingw do
    gem "tzinfo", ENV["TZINFO_VERSION"] if ENV["TZINFO_VERSION"]
    gem "tzinfo-data"
  end
end

#

group :rdoc, :optional => true do
  # Psych 5 has stopped bundling `libyaml` and expects it to be installed on the host system prior
  # to being invoked.
  # Since we don't have a direct dependency on the Psych gem (it gets included in the gem bundle as
  # a dependency of the `rdoc` gem), lock psych gem to v4.x instead of installing `libyaml` in our
  # development / CI environment.
  gem "psych", "~> 4.0"
  gem "rdoc", "~> 6.0"
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
