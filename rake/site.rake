#############################################################################
#
# Site tasks - http://jekyllrb.com
#
#############################################################################

namespace :site do
  task :generated_pages => [:history, :version_file, :conduct, :contributing]

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
      "source"      => File.expand_path(docs_folder),
      "destination" => File.expand_path("#{docs_folder}/_site"),
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
      "profile" => true,
      "source"      => File.expand_path(docs_folder),
      "destination" => File.expand_path("#{docs_folder}/_site")
    })
  end
  task :build => :generate

  desc "Update normalize.css library to the latest version and minify"
  task :update_normalize_css do
    Dir.chdir("#{docs_folder}/_sass") do
      sh 'curl "http://necolas.github.io/normalize.css/latest/normalize.css" -o "normalize.scss"'
      sh 'sass "normalize.scss":"_normalize.scss" --style compressed'
      rm ['normalize.scss', Dir.glob('*.map')].flatten
    end
  end

  desc "Generate generated pages and publish to GitHub Pages"
  task :publish => :generated_pages do
    puts "Committing and pushing to GitHub Pages..."
    sha = `git rev-parse HEAD`.strip
    Dir.chdir('gh-pages') do
      sh "git add docs/"
      sh "git commit --allow-empty -m 'Generating pages for #{sha}.'"
      sh "git push origin master"
    end
    puts 'Done.'
  end

  desc "Create a nicely formatted history page for the jekyll site based on the repo history."
  task :history do
    siteify_file('History.markdown', { "title" => "History" })
  end

  desc "Copy the Code of Conduct"
  task :conduct do
    front_matter = {
      "redirect_from" => "/conduct/index.html",
      "editable"      => false
    }
    siteify_file('CONDUCT.markdown', front_matter)
  end

  desc "Copy the contributing file"
  task :contributing do
    siteify_file('.github/CONTRIBUTING.markdown', "title" => "Contributing")
  end

  desc "Write the site latest_version.txt file"
  task :version_file do
    File.open("#{docs_folder}/latest_version.txt", 'wb') { |f| f.puts(version) } unless version =~ /(beta|rc|alpha)/i
  end

  namespace :releases do
    desc "Create new release post"
    task :new, :version do |t, args|
      raise "Specify a version: rake site:releases:new['1.2.3']" unless args.version
      today = Time.new.strftime('%Y-%m-%d')
      release = args.version.to_s
      filename = "#{docs_folder}/_posts/#{today}-jekyll-#{release.split('.').join('-')}-released.markdown"

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
