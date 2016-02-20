task :default => :init

def name
  "jekyll-docs".freeze
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

def version
  ENV.fetch('JEKYLL_VERSION')
end

task :init do
  sh "git clone git://github.com/jekyll/jekyll.git jekyll" unless Dir.exist? "jekyll/.git"
  Dir.chdir("jekyll") { sh "git checkout v#{version}" }
  rm_rf "site"
  cp_r "jekyll/site", "site"
end

task :teardown do
  rm_rf "site"
  rm_rf "jekyll"
end

#############################################################################
#
# Packaging tasks
#
#############################################################################

desc "Release #{name} v#{version}"
task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  unless `git diff`.empty?
    puts "We cannot proceed with uncommitted changes!"
    exit!
  end
  sh "gem push pkg/#{name}-#{version}.gem"
end

desc "Build #{name} v#{version} into pkg/"
task :build => :init do
  mkdir_p "pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end

desc "Install #{name} v#{version} into your gem folder."
task :install => :build do
  sh "gem install -l pkg/#{gem_file}"
end
