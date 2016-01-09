#!/bin/ruby
# Frozen-String-Literal: true
# Encoding: UTF-8

namespace :docs do
  desc "Release #{docs_name} v#{version}"
  task :release => :build do
    branch = `git branch`
    abort "You must be on the master branch" unless branch =~ /^\* master$/
    sh "gem push pkg/#{docs_name}-#{version}.gem"
  end

  #

  desc "Build #{docs_name} v#{version} into pkg/"
  task :build do
    mkdir_p "pkg"
    sh "gem build #{docs_name}.gemspec"
    sh "mv #{docs_name}-#{version}.gem pkg"
  end
end
