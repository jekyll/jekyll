# frozen_string_literal: true

source "https://rubygems.org"
gemspec :name => "jekyll"

gem "rake", "~> 12.0"

gem "rouge", ENV["ROUGE"] if ENV["ROUGE"]

group :development do
  gem "launchy", "~> 2.3"
  gem "pry"

  gem "pry-byebug" unless RUBY_ENGINE == "jruby"
end

#

group :test do
  gem "codeclimate-test-reporter", "~> 1.0.5"
  gem "cucumber", "~> 3.0"
  gem "httpclient"
  gem "jekyll_test_plugin"
  gem "jekyll_test_plugin_malicious"
  gem "nokogiri", "~> 1.9"

  # Ruby 3.1.0 shipped with `psych-4.0.3` which caused some of our Cucumber-based tests to fail.
  # TODO: Remove lock once we implement a way to use Psych 4 without breaking anything.
  # See https://github.com/jekyll/jekyll/pull/8918
  gem "psych", "~> 3.3"

  gem "rspec"
  gem "rspec-mocks"
  gem "rubocop", "~> 0.56.0"
  gem "test-dependency-theme", :path => File.expand_path("test/fixtures/test-dependency-theme", __dir__)
  gem "test-theme", :path => File.expand_path("test/fixtures/test-theme", __dir__)
  gem "test-theme-skinny", :path => File.expand_path("test/fixtures/test-theme-skinny", __dir__)
  gem "test-theme-symlink", :path => File.expand_path("test/fixtures/test-theme-symlink", __dir__)

  gem "webrick" if RUBY_VERSION >= "3"

  # http_parser.rb has stopped shipping jruby-compatible versions
  # latest compatible one was 0.6.0 https://rubygems.org/gems/http_parser.rb
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

  # Add gem 'matrix'
  # Ref: https://github.com/jekyll/jekyll/commit/d0eb07ba29dc7d5f52defab855bdb7a768cf824c
  gem "matrix"

  gem "mime-types", "~> 3.0"
  gem "rdoc", "~> 6.3.0"
  gem "tomlrb", "~> 2.0"

  if ENV["KRAMDOWN_VERSION"].nil? || ENV["KRAMDOWN_VERSION"].to_i >= 2
    gem "kramdown-syntax-coderay"
    gem "kramdown-parser-gfm"
  else
    gem "coderay", "~> 1.0"
  end

  platform :ruby, :mswin, :mingw, :x64_mingw do
    gem "classifier-reborn", "~> 2.2.0"
    gem "liquid-c", "~> 4.0"
    gem "pygments.rb", "~> 1.0"
    gem "rdiscount", "~> 2.0"
    gem "redcarpet", "~> 3.2", ">= 3.2.3"
    gem "yajl-ruby", "~> 1.3.1"
  end

<<<<<<< HEAD
  # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
  gem "tzinfo-data", :platforms => [:mingw, :mswin, :x64_mingw, :jruby]
=======
  # Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
  # and associated library
  platforms :jruby, :mswin, :mingw, :x64_mingw do
    gem "tzinfo", ENV["TZINFO_VERSION"] if ENV["TZINFO_VERSION"]
    gem "tzinfo-data"
  end
>>>>>>> 9c9cf3e82 (Support both tzinfo v1 and v2 alongwith non-half hour offsets. (#8880))
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
