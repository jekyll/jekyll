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
            Jekyll.logger.abort_with "Conflict:",
                      "#{new_blog_path} exists and is not empty."
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

        def create_site(new_blog_path)
          create_sample_files new_blog_path
        end

        def preserve_source_location?(path, options)
          !options["force"] && !Dir["#{path}/**/*"].empty?
        end

        def create_sample_files(path)
          FileUtils.mkdir_p(File.expand_path("_posts", path))

          static_files = %w(index.md about.md _config.yml .gitignore)
          static_files.each do |file|
            write_file(file, template(file), path)
          end

          write_file("Gemfile", template("Gemfile.erb"), path)
          write_file(initialized_post_name, template(scaffold_path), path)
        end

        def write_file(filename, contents, path)
          full_path = File.expand_path(filename, path)
          File.write(full_path, contents)
        end

        def template(filename)
          erb ||= ThemeBuilder::ERBRenderer.new(self)
          erb.render(File.read(File.expand_path(filename, site_template)))
        end

        def site_template
          File.expand_path("../../site_template", File.dirname(__FILE__))
        end

        def scaffold_path
          "_posts/0000-00-00-welcome-to-jekyll.markdown.erb"
        end

        # After a new blog has been created, print a success notification and
        # then automatically execute bundle install from within the new blog dir
        # unless the user opts to generate a blank blog or skip 'bundle install'.

        def after_install(path, options = {})
          Jekyll.logger.info "New jekyll site installed in #{path.cyan}."
          Jekyll.logger.info "Bundle install skipped." if options["skip-bundle"]

          unless options["blank"] || options["skip-bundle"]
            bundle_install path
          end
        end

        def bundle_install(path)
          Jekyll::External.require_with_graceful_fail "bundler"
          Jekyll.logger.info "Running bundle install in #{path.cyan}..."
          Dir.chdir(path) do
            if ENV["CI"]
              system("bundle", "install", "--quiet")
            else
              system("bundle", "install")
            end
          end
        end
      end
    end
  end
end
