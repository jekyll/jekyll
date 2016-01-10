#!/bin/ruby
# Frozen-String-Literal: true
# Encoding: UTF-8

desc "Tag #{name} v#{version}"
task :tag do
  abort "You must be on the master." unless branch =~ /^\* master$/
  sh "git commit --allow-empty -m 'Release :gem: #{version}'"
  sh "git tag v#{version}"
  sh "git push --tags"
end
