require 'rubygems'
require 'rake'
require 'rdoc'
require 'date'
require 'yaml'
require 'md2man/rakefile' if RUBY_VERSION > "1.9"

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

def file_date
  Date.today.strftime("%F")
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

def normalize_bullets(markdown)
  markdown.gsub(/\s{2}\*{1}/, "-")
end

def linkify_prs(markdown)
  markdown.gsub(/#(\d+)/) do |word|
    "[#{word}]({{ site.repository }}/issues/#{word.delete("#")})"
  end
end

def linkify_users(markdown)
  markdown.gsub(/(@\w+)/) do |username|
    "[#{username}](https://github.com/#{username.delete("@")})"
  end
end

def linkify(markdown)
  linkify_users(linkify_prs(markdown))
end

def liquid_escape(markdown)
  markdown.gsub(/(`{[{%].+[}%]}`)/, "{% raw %}\\1{% endraw %}")
end

def remove_head_from_history(markdown)
  index = markdown =~ /^##\s+\d+\.\d+\.\d+/
  markdown[index..-1]
end

def converted_history(markdown)
  remove_head_from_history(liquid_escape(linkify(normalize_bullets(markdown))))
end

#############################################################################
#
# Standard tasks
#
#############################################################################

if RUBY_VERSION > '1.9' && ENV["TRAVIS"] == "true"
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new

  task :default => [:test, :features, 'coveralls:push']
else
  task :default => [:test, :features]
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "#{name} #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) do |t|
    t.profile = "travis"
  end
  Cucumber::Rake::Task.new(:"features:html", "Run Cucumber features and produce HTML output") do |t|
    t.profile = "html_report"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end

#############################################################################
#
# Site tasks - http://jekyllrb.com
#
#############################################################################

namespace :site do
  desc "Generate and view the site locally"
  task :preview do
    require "launchy"

    # Yep, it's a hack! Wait a few seconds for the Jekyll site to generate and
    # then open it in a browser. Someday we can do better than this, I hope.
    Thread.new do
      sleep 4
      puts "Opening in browser..."
      Launchy.open("http://localhost:4000")
    end

    # Generate the site in server mode.
    puts "Running Jekyll..."
    Dir.chdir("site") do
      sh "#{File.expand_path('bin/jekyll', File.dirname(__FILE__))} serve --watch"
    end
  end

  desc "Update normalize.css library to the latest version and minify"
  task :update_normalize_css do
    Dir.chdir("site/css") do
      sh 'curl "http://necolas.github.io/normalize.css/latest/normalize.css" -o "normalize.scss"'
      sh 'sass "normalize.scss":"normalize.css" --style compressed'
      sh 'rm "normalize.scss"'
    end
  end

  desc "Commit the local site to the gh-pages branch and publish to GitHub Pages"
  task :publish => [:history] do
    # Ensure the gh-pages dir exists so we can generate into it.
    puts "Checking for gh-pages dir..."
    unless File.exist?("./gh-pages")
      puts "No gh-pages directory found. Run the following commands first:"
      puts "  `git clone git@github.com:mojombo/jekyll gh-pages"
      puts "  `cd gh-pages"
      puts "  `git checkout gh-pages`"
      exit(1)
    end

    # Ensure gh-pages branch is up to date.
    Dir.chdir('gh-pages') do
      sh "git pull origin gh-pages"
    end

    # Copy to gh-pages dir.
    puts "Copying site to gh-pages branch..."
    Dir.glob("site/*") do |path|
      next if path.include? "_site"
      sh "cp -R #{path} gh-pages/"
    end

    # Commit and push.
    puts "Committing and pushing to GitHub Pages..."
    sha = `git log`.match(/[a-z0-9]{40}/)[0]
    Dir.chdir('gh-pages') do
      sh "git add ."
      sh "git commit -m 'Updating to #{sha}.'"
      sh "git push origin gh-pages"
    end
    puts 'Done.'
  end

  desc "Create a nicely formatted history page for the jekyll site based on the repo history."
  task :history do
    if File.exist?("History.markdown")
      history_file = File.read("History.markdown")
      front_matter = {
        "layout" => "docs",
        "title" => "History",
        "permalink" => "/docs/history/",
        "prev_section" => "contributing"
      }
      Dir.chdir('site/docs/') do
        File.open("history.md", "w") do |file|
          file.write("#{front_matter.to_yaml}---\n\n")
          file.write(converted_history(history_file))
        end
      end
    else
      abort "You seem to have misplaced your History.markdown file. I can haz?"
    end
  end
  
  namespace :releases do
    desc "Create new release post"
    task :new, :version do |t, args|
      raise "Specify a version: rake site:releases:new['1.2.3']" unless args.version
      today = Time.new.strftime('%Y-%m-%d')
      release = args.version.to_s
      filename = "site/_posts/#{today}-jekyll-#{release.split('.').join('-')}-released.markdown"

      File.open(filename, "wb") do |post|
        post.puts("---")
        post.puts("layout: news_item")
        post.puts("title: 'Jekyll #{release} Released'")
        post.puts("date: #{Time.new.strftime('%Y-%m-%d %H:%M:%S %z')}")
        post.puts("author: ")
        post.puts("version: #{version}")
        post.puts("categories: [release]")
        post.puts("---")
        post.puts
        post.puts
      end

      puts "Created #{filename}"
    end
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

task :build => [:gemspec, "md2man:man"] do
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
