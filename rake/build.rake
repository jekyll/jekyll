#!/bin/ruby
# Frozen-String-Literal: true
# Encoding: UTF-8

desc "Build #{name} v#{version} into pkg/"
task :build do
  mkdir_p "pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end
