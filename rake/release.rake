#!/bin/ruby
# Packaging tasks
# Frozen-String-Literal: true
# Encoding: UTF-8

desc "Release #{name} v#{version}"
task :release => [:tag, :build] do
  branch = `git branch`
  abort "You must be on the master." unless branch =~ /^\* master$/
  sh "git commit --allow-empty -m 'Release :gem: #{version}'"
  sh "gem push pkg/#{name}-#{version}.gem"
end
