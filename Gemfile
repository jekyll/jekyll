source 'https://rubygems.org'
gemspec

gem 'rake', '~> 10.1'
gem 'rdoc', '~> 4.2'
gem 'redgreen', '~> 1.2'
gem 'shoulda', '~> 3.5'
gem 'rr', '~> 1.1'
gem 'cucumber', '1.3.18'
gem 'RedCloth', '~> 4.2'
gem 'maruku', '~> 0.7.0'
gem 'rdiscount', '~> 2.0'
gem 'launchy', '~> 2.3'
gem 'mime-types', '~> 2.4'
gem 'jekyll_test_plugin'
gem 'jekyll_test_plugin_malicious'
gem 'rouge', '~> 1.7'
gem 'liquid-c', '~> 0.0.3'
gem 'activesupport', ENV['ACTIVE_SUPPORT_VERSION'] || '~> 3.2.21'

group :test do
  gem 'simplecov-gem-adapter'
  gem 'simplecov'
  gem 'minitest-reporters'
  gem 'minitest'
end

if ENV['BENCHMARK']
  gem 'rbtrace'
  gem 'stackprof'
end

group :development do
  gem 'pry'
end
