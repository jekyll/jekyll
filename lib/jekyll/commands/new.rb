# frozen_string_literal: true

require "erb"

module Jekyll
  module Commands
    class New < Command
      class << self
        def init_with_program(prog)
          prog.command(:new) do |c|
            c.syntax "new PATH"
            c.description "Creates a new Jekyll site scaffold in PATH"

            c.option "force", "--force", "Force creation even if PATH already exists"
            c.option "blank", "--blank", "Creates scaffolding but with empty files"
            c.option "skip-bundle", "--skip-bundle", "Skip 'bundle install'"

            c.action do |args, options|
              Jekyll::Commands::New.process(args, options)
            end
          end
        end

        def process(args, options = {})
          raise ArgumentError, "You must specify a path." if args.empty?

          new_blog_path = File.expand_path(args.join(" "), Dir.pwd)
          FileUtils.mkdir_p new_blog_path
          if preserve_source_location?(new_blog_path, options)
            Jekyll.logger.error "Conflict:", "#{new_blog_path} exists and is not empty."
            Jekyll.logger.abort_with "", "Ensure #{new_blog_path} is empty or else " \
                      "try again with `--force` to proceed and overwrite any files."
          end

          if options["blank"]
            create_blank_site new_blog_path
          else
            create_site new_blog_path
          end

          after_install(new_blog_path, options)
        end

        def create_blank_site(path)
          Dir.chdir(path) do
            FileUtils.mkdir(%w(_layouts _posts _drafts))
            FileUtils.touch("index.html")
          end
        end

        def scaffold_post_content
          ERB.new(File.read(File.expand_path(scaffold_path, site_template))).result
        end

        # Internal: Gets the filename of the sample post to be created
        #
        # Returns the filename of the sample post, as a String
        def initialized_post_name
          "_posts/#{Time.now.strftime("%Y-%m-%d")}-welcome-to-jekyll.markdown"
        end

        private

        def gemfile_contents
          <<-RUBY
source "https://rubygems.org"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "~> #{Jekyll::VERSION}"

# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima", "~> 2.0"

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.6"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.0", :install_if => Gem.win_platform?

# kramdown v2 ships without the gfm parser by default. If you're using
# kramdown v1, comment out this line.
gem "kramdown-parser-gfm"

RUBY
        end

        def create_site(new_blog_path)
          create_sample_files new_blog_path

          File.open(File.expand_path(initialized_post_name, new_blog_path), "w") do |f|
            f.write(scaffold_post_content)
          end

          File.open(File.expand_path("Gemfile", new_blog_path), "w") do |f|
            f.write(gemfile_contents)
          end
        end

        def preserve_source_location?(path, options)
          !options["force"] && !Dir["#{path}/**/*"].empty?
        end

        def create_sample_files(path)
          FileUtils.cp_r site_template + "/.", path
          FileUtils.chmod_R "u+w", path
          FileUtils.rm File.expand_path(scaffold_path, path)
        end

        def site_template
          File.expand_path("../../site_template", __dir__)
        end

        def scaffold_path
          "_posts/0000-00-00-welcome-to-jekyll.markdown.erb"
        end

        # After a new blog has been created, print a success notification and
        # then automatically execute bundle install from within the new blog dir
        # unless the user opts to generate a blank blog or skip 'bundle install'.

        def after_install(path, options = {})
          unless options["blank"] || options["skip-bundle"]
            begin
              require "bundler"
              bundle_install path
            rescue LoadError
              Jekyll.logger.info "Could not load Bundler. Bundle install skipped."
            end
          end

          Jekyll.logger.info "New jekyll site installed in #{path.cyan}."
          Jekyll.logger.info "Bundle install skipped." if options["skip-bundle"]
        end

        def bundle_install(path)
          Jekyll.logger.info "Running bundle install in #{path.cyan}..."
          Dir.chdir(path) do
            exe = Gem.bin_path("bundler", "bundle")
            process, output = Jekyll::Utils::Exec.run("ruby", exe, "install")

            output.to_s.each_line do |line|
              Jekyll.logger.info("Bundler:".green, line.strip) unless line.to_s.empty?
            end

            raise SystemExit unless process.success?
          end
        end
      end
    end
  end
end
