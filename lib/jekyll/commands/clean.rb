# frozen_string_literal: true

module Jekyll
  module Commands
    class Clean < Command
      class << self
        def init_with_program(prog)
          prog.command(:clean) do |c|
            c.syntax "clean [subcommand]"
            c.description "Clean the site " \
                  "(removes site output and metadata file) without building."

            add_build_options(c)

            c.action do |_, options|
              Jekyll::Commands::Clean.process(options)
            end
          end
        end

        def process(options)
          options = configuration_from_options(options)
          destination = options["destination"]
          metadata_file = File.join(options["source"], ".jekyll-metadata")
          cache_dir = File.join(options["source"], options["cache_dir"])
          sass_cache = ".sass-cache"

          remove(destination, :checker_func => :directory?)
          remove(metadata_file, :checker_func => :file?)
          remove(cache_dir, :checker_func => :directory?)
          remove(sass_cache, :checker_func => :directory?)
        end

        def remove(filename, checker_func: :file?)
          if File.public_send(checker_func, filename)
            Jekyll.logger.info "Cleaner:", "Removing #{filename}..."
            FileUtils.rm_rf(filename)
          else
            Jekyll.logger.info "Cleaner:", "Nothing to do for #{filename}."
          end
        end
      end
    end
  end
end
