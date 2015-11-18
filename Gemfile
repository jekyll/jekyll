source 'https://rubygems.org'
gemspec name: 'jekyll'

gem 'rake', '~> 10.1'
group :development do
  gem 'rdoc', '~> 4.2'
  gem 'launchy', '~> 2.3'
  gem 'toml', '~> 0.1.0'
  gem 'pry'
end

group :test do
  gem 'redgreen', '~> 1.2'
  gem 'shoulda', '~> 3.5'
  gem 'cucumber', '~> 2.0', '< 2.1'
  gem 'simplecov', '~> 0.9'
  gem 'jekyll_test_plugin'
  gem 'jekyll_test_plugin_malicious'
  gem 'minitest-reporters'
  gem 'minitest-profile'
  gem 'minitest'
  gem 'rspec-mocks'

  if RUBY_PLATFORM =~ /cygwin/ || RUBY_VERSION.start_with?("2.2")
    gem 'test-unit'
  end

  if ENV['PROOF']
    gem 'html-proofer', '~> 2.0'
  end
end

group :benchmark do
  if ENV['BENCHMARK']
    gem 'ruby-prof'
    gem 'rbtrace'
    gem 'stackprof'
    gem 'benchmark-ips'
  end
end

gem 'jekyll-paginate', '~> 1.0'
gem 'jekyll-coffeescript', '~> 1.0'
gem 'jekyll-feed'
gem 'jekyll-gist', '~> 1.0'
gem 'mime-types', '~> 2.6'
gem 'kramdown', '~> 1.9'

platform :ruby, :mswin, :mingw do
  gem 'rdiscount', '~> 2.0'
  gem 'pygments.rb', '~> 0.6.0'
  gem 'redcarpet', '~> 3.2', '>= 3.2.3'
  gem 'classifier-reborn', '~> 2.0'
  gem 'liquid-c', '~> 3.0'
end
