require 'erb'

module Jekyll
  module Commands
    class New < Command
      class << self
        def init_with_program(prog)
          prog.command(:new) do |c|
            c.syntax 'new PATH'
            c.description 'Creates a new Jekyll site scaffold in PATH'

            c.option 'force', '--force', 'Force creation even if PATH already exists'
            c.option 'blank', '--blank', 'Creates scaffolding but with empty files'

            c.action do |args, options|
              Jekyll::Commands::New.process(args, options)
            end
          end
        end

        def process(args, options = {})
          raise ArgumentError.new('You must specify a path.') if args.empty?

          new_blog_path = File.expand_path(args.join(" "), Dir.pwd)
          FileUtils.mkdir_p new_blog_path
          if preserve_source_location?(new_blog_path, options)
            Jekyll.logger.abort_with "Conflict:", "#{new_blog_path} exists and is not empty."
          end

          if options["blank"]
            create_blank_site new_blog_path
          else
            create_sample_files new_blog_path

            File.open(File.expand_path(initialized_post_name, new_blog_path), "w") do |f|
              f.write(scaffold_post_content)
            end
          end

          Jekyll.logger.info "New jekyll site installed in #{new_blog_path}."
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
          "_posts/#{Time.now.strftime('%Y-%m-%d')}-welcome-to-jekyll.markdown"
        end

        private

        def preserve_source_location?(path, options)
          !options["force"] && !Dir["#{path}/**/*"].empty?
        end

        def create_sample_files(path)
          FileUtils.cp_r site_template + '/.', path
          FileUtils.rm File.expand_path(scaffold_path, path)
        end

        def site_template
          File.expand_path("../../site_template", File.dirname(__FILE__))
        end

        def scaffold_path
          "_posts/0000-00-00-welcome-to-jekyll.markdown.erb"
        end
      end
    end
  end
end
