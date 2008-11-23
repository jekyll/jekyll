require 'rubygems'
require 'hoe'
require 'lib/jekyll'

Hoe.new('jekyll', Jekyll::VERSION) do |p|
  # p.rubyforge_name = 'jekyllx' # if different than lowercase project name
  p.developer('Tom Preston-Werner', 'tom@mojombo.com')
  p.summary = "Jekyll is a simple, blog aware, static site generator."
  p.extra_deps = ['RedCloth', 'liquid', 'classifier']
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
end
