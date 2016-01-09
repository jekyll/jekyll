require "rspec/core/rake_task"
task :default => [:spec]
RSpec::Core::RakeTask.new :spec
task :test => :spec

#

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
