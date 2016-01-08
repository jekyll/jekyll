source "https://rubygems.org"
gemspec :name => :jekyll

gem "rake", "~> 10.1"
group :development do
  unless ENV["CI"]
    gem "pry", :require => false
    gem "rubocop", {
      :github => "bbatsov/rubocop",
      :branch => :master, :require => false
    }
  end
end

group( :doc) { gem "rdoc", "~> 4.2" } # `--without doc`
group(:util) { gem "launchy", "~> 2.3" } # `--without util`
group(:site) { gem "html-proofer" } # `--without site`

# `--without benchmark`
group :benchmark do
  gem "rbtrace"
  gem "ruby-prof"
  gem "benchmark-ips"
  gem "stackprof"
end

group :test do
  gem "redgreen", "~> 1.2"
  gem "shoulda", "~> 3.5"
  gem "cucumber", "~> 2.1"
  gem "simplecov", "~> 0.9"
  gem "jekyll_test_plugin"
  gem "jekyll_test_plugin_malicious"
  gem "minitest-reporters"
  gem "minitest-profile"
  gem "rspec-mocks"
  gem "minitest"
  gem "nokogiri"

  if RUBY_PLATFORM =~ /cygwin/ || RUBY_VERSION.start_with?("2.2")
    gem "test-unit"
  end
end

group :optional_jekyll_dependencies do
  gem "toml", "~> 0.1.0"
  gem "jekyll-paginate", "~> 1.0"
  gem "jekyll-coffeescript", "~> 1.0"
  gem "jekyll-feed", "~> 0.1.3"
  gem "jekyll-redirect-from", "~> 0.9.1"
  gem "jekyll-gist", "~> 1.0"
  gem "mime-types", "~> 3.0"
  gem "kramdown", "~> 1.9"

  platform :ruby, :mswin, :mingw do
    gem "rdiscount", "~> 2.0"
    gem "pygments.rb", "~> 0.6.0"
    gem "redcarpet", "~> 3.2", ">= 3.2.3"
    gem "classifier-reborn", "~> 2.0"
    gem "liquid-c", "~> 3.0"
  end
end
