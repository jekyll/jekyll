require 'rubygems'
require 'rake'
require 'rdoc'
require 'date'
require 'yaml'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))
require 'jekyll/version'

#############################################################################
#
# Helper functions
#
#############################################################################

def name
  "jekyll"
end

def version
  Jekyll::VERSION
end

def docs_name
  "#{name}-docs"
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{Gem::Version.new(version).to_s}.gem"
end

def normalize_bullets(markdown)
  markdown.gsub(/\n\s{2}\*{1}/, "\n-")
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

def custom_release_header_anchors(markdown)
  header_regexp = /^(\d{1,2})\.(\d{1,2})\.(\d{1,2}) \/ \d{4}-\d{2}-\d{2}/
  section_regexp = /^### \w+ \w+$/
  markdown.split(/^##\s/).map do |release_notes|
    _, major, minor, patch = *release_notes.match(header_regexp)
    release_notes
      .gsub(header_regexp, "\\0\n{: #v\\1-\\2-\\3}")
      .gsub(section_regexp) { |section| "#{section}\n{: ##{sluffigy(section)}-v#{major}-#{minor}-#{patch}}" }
  end.join("\n## ")
end

def sluffigy(header)
  header.gsub(/#/, '').strip.downcase.gsub(/\s+/, '-')
end

def remove_head_from_history(markdown)
  index = markdown =~ /^##\s+\d+\.\d+\.\d+/
  markdown[index..-1]
end

def converted_history(markdown)
  remove_head_from_history(
    custom_release_header_anchors(
      liquid_escape(
        linkify(
          normalize_bullets(markdown)))))
end

#############################################################################
#
# Standard tasks
#
#############################################################################

multitask :default => [:test, :features]

task :spec => :test
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
  task :preview => [:history, :version_file] do
    require "launchy"
    require "jekyll"

    # Yep, it's a hack! Wait a few seconds for the Jekyll site to generate and
    # then open it in a browser. Someday we can do better than this, I hope.
    Thread.new do
      sleep 4
      puts "Opening in browser..."
      Launchy.open("http://localhost:4000")
    end

    # Generate the site in server mode.
    puts "Running Jekyll..."
    options = {
      "source"      => File.expand_path("site"),
      "destination" => File.expand_path("site/_site"),
      "watch"       => true,
      "serving"     => true
    }
    Jekyll::Commands::Build.process(options)
    Jekyll::Commands::Serve.process(options)
  end

  desc "Generate the site"
  task :generate => [:history, :version_file] do
    require "jekyll"
    Jekyll::Commands::Build.process({
      "source"      => File.expand_path("site"),
      "destination" => File.expand_path("site/_site")
    })
  end

  desc "Update normalize.css library to the latest version and minify"
  task :update_normalize_css do
    Dir.chdir("site/_sass") do
      sh 'curl "http://necolas.github.io/normalize.css/latest/normalize.css" -o "normalize.scss"'
      sh 'sass "normalize.scss":"_normalize.scss" --style compressed'
      rm ['normalize.scss', Dir.glob('*.map')].flatten
    end
  end

  desc "Commit the local site to the gh-pages branch and publish to GitHub Pages"
  task :publish => [:history, :version_file] do
    # Ensure the gh-pages dir exists so we can generate into it.
    puts "Checking for gh-pages dir..."
    unless File.exist?("./gh-pages")
      puts "Creating gh-pages dir..."
      sh "git clone git@github.com:jekyll/jekyll gh-pages"
    end

    # Ensure latest gh-pages branch history.
    Dir.chdir('gh-pages') do
      sh "git checkout gh-pages"
      sh "git pull origin gh-pages"
    end

    # Proceed to purge all files in case we removed a file in this release.
    puts "Cleaning gh-pages directory..."
    purge_exclude = %w[
      gh-pages/.
      gh-pages/..
      gh-pages/.git
      gh-pages/.gitignore
    ]
    FileList["gh-pages/{*,.*}"].exclude(*purge_exclude).each do |path|
      sh "rm -rf #{path}"
    end

    # Copy site to gh-pages dir.
    puts "Building site into gh-pages branch..."
    ENV['JEKYLL_ENV'] = 'production'
    require "jekyll"
    Jekyll::Commands::Build.process({
      "source"       => File.expand_path("site"),
      "destination"  => File.expand_path("gh-pages"),
      "sass"         => { "style" => "compressed" }
    })

    File.open('gh-pages/.nojekyll', 'wb') { |f| f.puts(":dog: food.") }

    # Commit and push.
    puts "Committing and pushing to GitHub Pages..."
    sha = `git rev-parse HEAD`.strip
    Dir.chdir('gh-pages') do
      sh "git add ."
      sh "git commit --allow-empty -m 'Updating to #{sha}.'"
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
        "permalink" => "/docs/history/"
      }
      Dir.chdir('site/_docs/') do
        File.open("history.md", "w") do |file|
          file.write("#{front_matter.to_yaml}---\n\n")
          file.write(converted_history(history_file))
        end
      end
    else
      abort "You seem to have misplaced your History.markdown file. I can haz?"
    end
  end

  desc "Write the site latest_version.txt file"
  task :version_file do
    File.open('site/latest_version.txt', 'wb') { |f| f.puts(version) } unless version =~ /(beta|rc|alpha)/i
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
        post.puts("version: #{release}")
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

desc "Release #{name} v#{version}"
task :release => :build do
  unless `git branch` =~ /^\* 3\.0-stable$/
    puts "You must be on the 3.0-stable branch to release!"
    exit!
  end
  sh "git commit --allow-empty -m 'Release :gem: #{version}'"
  sh "git tag v#{version}"
  sh "git push origin 3.0-stable"
  sh "git push origin v#{version}"
  sh "gem push pkg/#{name}-#{version}.gem"
end

desc "Build #{name} v#{version} into pkg/"
task :build do
  mkdir_p "pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end

#############################################################################
#
# Packaging tasks for jekyll-docs
#
#############################################################################

namespace :docs do
  desc "Release #{docs_name} v#{version}"
  task :release => :build do
  unless `git branch` =~ /^\* 3\.0-stable$/
    puts "You must be on the 3.0-stable branch to release!"
      exit!
    end
    sh "gem push pkg/#{docs_name}-#{version}.gem"
  end

  desc "Build #{docs_name} v#{version} into pkg/"
  task :build do
    mkdir_p "pkg"
    sh "gem build #{docs_name}.gemspec"
    sh "mv #{docs_name}-#{version}.gem pkg"
  end
end
