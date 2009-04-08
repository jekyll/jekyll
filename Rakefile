require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  gem 'jeweler', '>= 0.11.0'
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "jekyll"
    s.summary = %Q{Jekyll is a simple, blog aware, static site generator.}
    s.email = "tom@mojombo.com"
    s.homepage = "http://github.com/mojombo/jekyll"
    s.description = "Jekyll is a simple, blog aware, static site generator."
    s.authors = ["Tom Preston-Werner"]
    s.rubyforge_project = "jekyll"
    s.files.exclude 'test/dest'
    s.test_files.exclude 'test/dest'
    s.add_dependency('RedCloth', '>= 4.0.4')
    s.add_dependency('liquid', '>= 1.9.0')
    s.add_dependency('classifier', '>= 1.3.1')
    s.add_dependency('maruku', '>= 0.5.9')
    s.add_dependency('directory_watcher', '>= 1.1.1')
    s.add_dependency('open4', '>= 0.9.6')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler --version '>= 0.11.0'"
  exit(1)
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/test_*.rb'
  t.verbose = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'jekyll'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/test_*.rb']
    t.verbose = true
  end
rescue LoadError
end

task :default => [:test, :features]

# console

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r jekyll.rb"
end

# converters

namespace :convert do
  desc "Migrate from mephisto in the current directory"
  task :mephisto do
    sh %q(ruby -r './lib/jekyll/converters/mephisto' -e 'Jekyll::Mephisto.postgres(:database => "#{ENV["DB"]}")')
  end
  desc "Migrate from Movable Type in the current directory"
  task :mt do
    sh %q(ruby -r './lib/jekyll/converters/mt' -e 'Jekyll::MT.process("#{ENV["DB"]}", "#{ENV["USER"]}", "#{ENV["PASS"]}")')
  end
  desc "Migrate from Typo in the current directory"
  task :typo do
    sh %q(ruby -r './lib/jekyll/converters/typo' -e 'Jekyll::Typo.process("#{ENV["DB"]}", "#{ENV["USER"]}", "#{ENV["PASS"]}")')
  end
end

begin
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "--format pretty"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
