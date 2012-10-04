require 'rubygems'
require 'rake'
require 'rdoc'
require 'date'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

#############################################################################
#
# Helper functions
#
#############################################################################

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  line = File.read("lib/#{name}.rb")[/^\s*VERSION\s*=\s*.*/]
  line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
end

def date
  Date.today.to_s
end

def rubyforge_project
  name
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'"}
end

#############################################################################
#
# Standard tasks
#
#############################################################################

task :default => [:test, :features]

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Generate RCov test coverage and open in your browser"
task :coverage do
  require 'rcov'
  sh "rm -fr coverage"
  sh "rcov test/test_*.rb"
  sh "open coverage/index.html"
end

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "#{name} #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end

#############################################################################
#
# Custom tasks (add your own tasks here)
#
#############################################################################

namespace :migrate do
  desc "Migrate from mephisto in the current directory"
  task :mephisto do
    sh %q(ruby -r './lib/jekyll/migrators/mephisto' -e 'Jekyll::Mephisto.postgres(:database => "#{ENV["DB"]}")')
  end
  desc "Migrate from Movable Type in the current directory"
  task :mt do
    sh %q(ruby -r './lib/jekyll/migrators/mt' -e 'Jekyll::MT.process("#{ENV["DB"]}", "#{ENV["USER"]}", "#{ENV["PASS"]}")')
  end
  desc "Migrate from Typo in the current directory"
  task :typo do
    sh %q(ruby -r './lib/jekyll/migrators/typo' -e 'Jekyll::Typo.process("#{ENV["DB"]}", "#{ENV["USER"]}", "#{ENV["PASS"]}")')
  end
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "--format progress"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

#############################################################################
#
# Packaging tasks
#
#############################################################################

task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "git commit --allow-empty -m 'Release #{version}'"
  sh "git tag v#{version}"
  sh "git push origin master"
  sh "git push origin v#{version}"
  sh "gem push pkg/#{name}-#{version}.gem"
end

task :build => :gemspec do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end

task :gemspec do
  # read spec file and split out manifest section
  spec = File.read(gemspec_file)
  head, manifest, tail = spec.split("  # = MANIFEST =\n")

  # replace name version and date
  replace_header(head, :name)
  replace_header(head, :version)
  replace_header(head, :date)
  #comment this out if your rubyforge_project has a different name
  replace_header(head, :rubyforge_project)

  # determine file list from git ls-files
  files = `git ls-files`.
    split("\n").
    sort.
    reject { |file| file =~ /^\./ }.
    reject { |file| file =~ /^(rdoc|pkg|coverage)/ }.
    map { |file| "    #{file}" }.
    join("\n")

  # piece file back together and write
  manifest = "  s.files = %w[\n#{files}\n  ]\n"
  spec = [head, manifest, tail].join("  # = MANIFEST =\n")
  File.open(gemspec_file, 'w') { |io| io.write(spec) }
  puts "Updated #{gemspec_file}"
end
