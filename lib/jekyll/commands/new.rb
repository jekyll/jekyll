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

            c.action do |args, options|
              Jekyll::Commands::New.process(args, options)
            end
          end
        end

        def process(args, options = {})
          raise ArgumentError, "You must specify a path." if args.empty?

          new_blog_title = args.join(" ")
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
            create_config_file(new_blog_title, new_blog_path)
          end

          Jekyll.logger.info "New jekyll site '#{new_blog_title}'" \
            " installed in #{new_blog_path}."

          bundle_install new_blog_path
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

        def create_config_file(title, path)
          @blog_title = title

          config_template = File.expand_path("_config.yml.erb", site_template)
          config_copy = ERB.new(File.read(config_template)).result(binding)

          create_file("_config.yml", path, config_copy)
        end

        def gemfile_content
          ERB.new(File.read(File.expand_path("Gemfile.erb", site_template))).result
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
          create_file("Gemfile", new_blog_path, gemfile_content)
          create_file(initialized_post_name, new_blog_path, scaffold_post_content)
        end

        def preserve_source_location?(path, options)
          !options["force"] && !Dir["#{path}/**/*"].empty?
        end

        def site_template
          File.expand_path("../../site_template", File.dirname(__FILE__))
        end

        def scaffold_path
          "_posts/0000-00-00-welcome-to-jekyll.markdown.erb"
        end

        def erb_files
          erb_file = File.join("*", "*.erb")
          Dir.glob(erb_file)
        end

        def create_file(file, path, content)
          File.open(File.expand_path(file, path), "w") do |f|
            f.write(content)
          end
        end

        def create_sample_files(path)
          FileUtils.cp_r site_template + "/.", path
          FileUtils.rm File.expand_path(scaffold_path, path)

          erb_files.each do |file|
            FileUtils.rm file
          end
        end

        def bundle_install(path)
          Jekyll::External.require_with_graceful_fail "bundler"
          $stdout.print "\nRun 'bundle install' with default theme? (Y/N)  "
          @ans = ENV["CI"] ? "N" : $stdin.gets.chomp
          until @ans == "Y" || @ans == "N"
            $stdout.print "Invalid input. Input 'Y' or 'N'  "
            @ans = $stdin.gets.chomp
          end
          stdinput(path)
        end

        def stdinput(path)
          if @ans == "Y"
            Jekyll.logger.info "Running bundle install in", path.to_s + "..."
            Dir.chdir(path.to_s) do
              system("bundle install")
            end
          elsif @ans == "N"
            Jekyll.logger.warn "\nBundle install skipped.\n" \
            "Edit your Gemfile and run 'bundle install' " \
            "from your new directory"
          end
        end
      end
    end
  end
end
