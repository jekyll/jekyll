# frozen_string_literal: true

#############################################################################
#
# Site tasks - https://jekyllrb.com
#
#############################################################################

namespace :site do
  task :generated_pages => [:history, :latest_version, :conduct, :contributing, :support]

  desc "Generate and view the site locally"
  task :preview => :generated_pages do
    require "launchy"
    require "jekyll"

    browser_launched = false
    Jekyll::Hooks.register :site, :post_write do |_site|
      next if browser_launched
      browser_launched = true
      Jekyll.logger.info "Opening in browser..."
      Launchy.open("http://localhost:4000")
    end

    # Generate the site in server mode.
    puts "Running Jekyll..."
    options = {
      "source"      => File.expand_path(docs_folder),
      "destination" => File.expand_path("#{docs_folder}/_site"),
      "incremental" => true,
      "profile"     => true,
      "watch"       => true,
      "serving"     => true,
    }
    Jekyll::Commands::Build.process(options)
    Jekyll::Commands::Serve.process(options)
  end

  desc "Generate the site"
  task :generate => :generated_pages do
    require "jekyll"
    Jekyll::Commands::Build.process({
      "profile"     => true,
      "source"      => File.expand_path(docs_folder),
      "destination" => File.expand_path("#{docs_folder}/_site"),
    })
  end
  task :build => :generate

  desc "Update normalize.css library to the latest version"
  task :update_normalize_css do
    Dir.chdir("#{docs_folder}/_sass") do
      sh 'curl "https://necolas.github.io/normalize.css/latest/normalize.css" -o "_normalize.scss"'
    end
  end

  desc "Generate generated pages and publish to GitHub Pages"
  task :publish => :generated_pages do
    puts "GitHub Pages now compiles our docs site on every push to the `master` branch. Cool, huh?"
    exit 1
  end

  desc "Create a nicely formatted history page for the jekyll site based on the repo history."
  task :history do
    siteify_file("History.markdown", { "title" => "History" })
  end

  desc "Copy the Code of Conduct"
  task :conduct do
    front_matter = {
      "redirect_from" => "/conduct/index.html",
      "editable"      => false,
    }
    siteify_file("CODE_OF_CONDUCT.markdown", front_matter)
  end

  desc "Copy the contributing file"
  task :contributing do
    siteify_file(".github/CONTRIBUTING.markdown", "title" => "Contributing")
  end

  desc "Copy the support file"
  task :support do
    siteify_file(".github/SUPPORT.markdown", "title" => "Support")
  end

  desc "Write the latest Jekyll version"
  task :latest_version do
    return if version =~ %r!(beta|rc|alpha)!i
    require "safe_yaml/load"
    config_file = File.join(docs_folder, "_config.yml")
    config = SafeYAML.load_file(config_file)
    config["version"] = version
    File.write(config_file, YAML.dump(config))
    File.open("#{docs_folder}/latest_version.txt", "wb") { |f| f.puts(version) }
  end

  namespace :releases do
    desc "Create new release post"
    task :new, :version do |_t, args|
      raise "Specify a version: rake site:releases:new['1.2.3']" unless args.version
      today = Time.new.strftime("%Y-%m-%d")
      release = args.version.to_s
      filename = "#{docs_folder}/_posts/#{today}-jekyll-#{release.split(".").join("-")}-released.markdown"

      File.open(filename, "wb") do |post|
        post.puts("---")
        post.puts("title: 'Jekyll #{release} Released'")
        post.puts("date: #{Time.new.strftime("%Y-%m-%d %H:%M:%S %z")}")
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
