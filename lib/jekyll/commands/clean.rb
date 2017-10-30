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
          remove(File.join(options["source"], ".sass-cache"))
          remove(File.join(options["source"], ".jekyll-metadata"))
          remove(options["destination"])
        end

        def remove(filename)
          if File.exists?(filename)
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
