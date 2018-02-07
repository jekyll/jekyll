# frozen_string_literal: true

def generate_master_jekyll_gemfile
  File.open("Gemfile", "wb") do |file|
    file.puts <<-RUBY
source "https://rubygems.org"

gem "jekyll", :git => "https://github.com/jekyll/jekyll.git", :branch => "master"
gem "minima", "~> 2.0"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.6"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

RUBY
  end
end

task :bench do
  Dir.chdir(docs_folder) do
    pr_start_time = Time.now
    sh "bundle exec jekyll build"
    pr_build_time = (Time.now - pr_start_time).to_i

    generate_master_jekyll_gemfile
    sh "BUNDLE_GEMFILE=Gemfile bundle install"
    master_start_time = Time.now
    sh "BUNDLE_GEMFILE=Gemfile bundle exec jekyll build"
    master_build_time = (Time.now - master_start_time).to_i

    Jekyll.logger.info ""
    Jekyll.logger.info "Net Build Time:", master_start_time - pr_start_time
    Jekyll.logger.info ""
  end
end
