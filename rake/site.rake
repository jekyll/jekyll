#!/bin/ruby
# Frozen-String-Literal: true
# Encoding: UTF-8

namespace :site do
  desc "Generate and view the site locally"
  task :preview => [:history, :version_file] do
    require "launchy"
    require "jekyll"

    puts "Opening in browser..."
    Launchy.open("http://localhost:4000")
    sleep 4

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

  #

  desc "Generate the site"
  task :build => :generate
  task :generate => [:history, :version_file] do
    require "jekyll"
    Jekyll::Commands::Build.process({
      "source"      => File.expand_path("site"),
      "destination" => File.expand_path("site/_site")
    })
  end

  #

  desc "Update normalize.css library to the latest version and minify"
  task :update_normalize_css do
    Dir.chdir("site/_sass") do
      sh 'curl "http://necolas.github.io/normalize.css/latest/normalize.css" -o "normalize.scss"'
      sh 'sass "normalize.scss":"_normalize.scss" --style compressed'
      rm ['normalize.scss', Dir.glob('*.map')].flatten
    end
  end

  #

  desc "Commit the local site to the gh-pages branch and publish to GitHub Pages"
  task :publish => [:history, :version_file] do
    puts "Checking for gh-pages dir..."
    unless File.exist?("./gh-pages")
      $stdout.puts "Creating gh-pages dir..."
      sh "git clone git@github.com:jekyll/jekyll gh-pages"
    end

    #

    Dir.chdir('gh-pages') do
      sh "git checkout gh-pages"
      sh "git pull origin gh-pages"
    end

    #

    $stdout.puts "Cleaning gh-pages directory..."
    purge_exclude = %W(gh-pages/. gh-pages/.. gh-pages/.git gh-pages/.gitignore)
    FileList["gh-pages/{*,.*}"].exclude(*purge_exclude).each do |path|
      sh "rm -rf #{path}"
    end

    #

    ENV['JEKYLL_ENV'] = 'production'
    $stdout.puts "Building site into gh-pages branch..."
    require "jekyll"

    #

    Jekyll::Commands::Build.process({
      "sass"         => { "style" => "compressed" },
      "destination"  => File.expand_path("gh-pages"),
      "source"       => File.expand_path("site")
    })

    #

    File.write("gh-pages/.nojekyll", ":dog: food")
    $stdout.puts "Committing and pushing to GitHub Pages..."
    sha = `git rev-parse HEAD`.strip

    Dir.chdir("gh-pages") do
      sh "git add ."
      sh "git commit --allow-empty -m 'Updating to #{sha}.'"
      sh "git push origin gh-pages"
    end

    $stdout.puts 'Done.'
  end

  #

  desc "Create a nicely formatted history page for the jekyll site based on the repo history."
  task :history do
    if File.exist?("History.markdown")
      history_file = File.read("History.markdown")
      front_matter = {
        "layout" => "docs",
        "permalink" => "/docs/history/",
        "title" => "History"
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

  #

  desc "Write the site latest_version.txt file"
  task :version_file do
    unless version =~ /beta|rc|alpha/i
      File.write("site/latest_version.txt", version)
    end
  end

  #

  namespace :releases do
    desc "Create new release post"
    task :new, :version do |t, args|
      unless args.version
        raise "Specify a version: rake site:releases:new['1.2.3']"
      end

      today = Time.new.strftime('%Y-%m-%d')
      filename = "site/_posts/#{today}-jekyll-#{release.split('.').join('-')}-released.markdown"
      release = args.version.to_s

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
