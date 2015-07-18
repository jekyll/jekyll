source 'https://rubygems.org'
gemspec

gem 'pry'
gem 'toml', '~> 0.1.0'
gem 'jekyll-paginate', '~> 1.0'
gem 'jekyll-gist', '~> 1.0'
gem 'jekyll-coffeescript', '~> 1.0'

platform :ruby, :mswin, :mingw do
  gem 'pygments.rb', '~> 0.6.0'
  gem 'rdiscount', '~> 2.0'
  gem 'classifier-reborn', '~> 2.0'
  gem 'redcarpet', '~> 3.2', '>= 3.2.3'
  gem 'liquid-c', '~> 3.0'
end

if RUBY_PLATFORM =~ /cygwin/ || RUBY_VERSION.start_with?("2.2")
  gem 'test-unit'
end

gem 'rake', '~> 10.1'
gem 'rdoc', '~> 4.2'
gem 'redgreen', '~> 1.2'
gem 'shoulda', '~> 3.5'
gem 'cucumber', '~> 2.0'
gem 'launchy', '~> 2.3'
gem 'simplecov', '~> 0.9'
gem 'mime-types', '~> 2.6'
gem 'kramdown', '~> 1.7.0'
gem 'jekyll_test_plugin'
gem 'jekyll_test_plugin_malicious'
gem 'minitest-reporters'
gem 'minitest-profile'
gem 'minitest'
gem 'rspec-mocks'

if ENV['BENCHMARK']
  gem 'ruby-prof'
  gem 'rbtrace'
  gem 'stackprof'
  gem 'benchmark-ips'
end

if ENV['PROOF']
  gem 'html-proofer', '~> 2.0'
end
