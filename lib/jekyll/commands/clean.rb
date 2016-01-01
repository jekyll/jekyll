module Jekyll
  module Commands
    class Clean < Command
      class << self

        def init_with_program(prog)
          prog.command(:clean) do |c|
            c.syntax 'clean [subcommand]'
            c.description 'Clean the site (removes site output and metadata file) without building.'

            c.action do |args, _|
              Jekyll::Commands::Clean.process({})
            end
          end
        end

        def process(options)
          options = configuration_from_options(options)
          destination = options['destination']
          metadata_file = File.join(options['source'], '.jekyll-metadata')

          if File.directory? destination
            Jekyll.logger.info "Cleaning #{destination}..."
            FileUtils.rm_rf(destination)
            Jekyll.logger.info "", "done."
          else
            Jekyll.logger.info "Nothing to do for #{destination}."
          end

          if File.file? metadata_file
            Jekyll.logger.info "Removing #{metadata_file}..."
            FileUtils.rm_rf(metadata_file)
            Jekyll.logger.info "", "done."
          else
            Jekyll.logger.info "Nothing to do for #{metadata_file}."
          end
        end

      end
    end
  end
end
