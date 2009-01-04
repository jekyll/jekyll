require 'rubygems'
require 'hoe'
require 'lib/jekyll'

Hoe.new('jekyll', Jekyll::VERSION) do |p|
  p.developer('Tom Preston-Werner', 'tom@mojombo.com')
  p.summary = "Jekyll is a simple, blog aware, static site generator."
  p.extra_deps = ['RedCloth', 'liquid', 'classifier', 'maruku', 'directory_watcher', 'open4']
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/jekyll.rb"
end

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
