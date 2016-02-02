#############################################################################
#
# Site tasks - http://jekyllrb.com
#
#############################################################################

namespace :site do
  task :generated_pages => [:history, :version_file, :conduct]

  desc "Generate and view the site locally"
  task :preview => :generated_pages do
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
  task :generate => :generated_pages do
    require "jekyll"
    Jekyll::Commands::Build.process({
      "source"      => File.expand_path("site"),
      "destination" => File.expand_path("site/_site")
    })
  end
  task :build => :generate

  desc "Update normalize.css library to the latest version and minify"
  task :update_normalize_css do
    Dir.chdir("site/_sass") do
      sh 'curl "http://necolas.github.io/normalize.css/latest/normalize.css" -o "normalize.scss"'
      sh 'sass "normalize.scss":"_normalize.scss" --style compressed'
      rm ['normalize.scss', Dir.glob('*.map')].flatten
    end
  end

  desc "Commit the local site to the gh-pages branch and publish to GitHub Pages"
  task :publish => :generated_pages do
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

  desc "Copy the Code of Conduct"
  task :conduct do
    code_of_conduct = File.read("CONDUCT.markdown")
    header, _, body = code_of_conduct.partition("\n\n")
    front_matter = {
      "layout"        => "docs",
      "title"         => header.sub('# Contributor ', ''),
      "permalink"     => "/docs/conduct/",
      "redirect_from" => "/conduct/index.html",
      "editable"      => false
    }
    Dir.chdir('site/_docs') do
      File.open("conduct.md", "w") do |file|
        file.write("#{front_matter.to_yaml}---\n\n")
        file.write(body)
      end
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
