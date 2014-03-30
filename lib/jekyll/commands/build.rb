module Jekyll
  module Commands
    class Build < Command

      class << self

        # Create the Mercenary command for the Jekyll CLI for this Command
        def init_with_program(prog)
          prog.command(:build) do |c|
            c.syntax      'build [options]'
            c.description 'Build your site'

            add_build_options(c)

            c.action do |args, options|
              options["serving"] = false
              Jekyll::Commands::Build.process(options)
            end
          end
        end

        # Build your jekyll site
        # Continuously watch if `watch` is set to true in the config.
        def process(options)
          options = configuration_from_options(options)
          site = Jekyll::Site.new(options)

          Jekyll.logger.log_level = Jekyll::Stevenson::ERROR if options['quiet']

          build(site, options)
          watch(site, options) if options['watch']
        end

        # Build your Jekyll site.
        #
        # site - the Jekyll::Site instance to build
        # options - the
        #
        # Returns nothing.
        def build(site, options)
          source      = options['source']
          destination = options['destination']
          Jekyll.logger.info "Source:", source
          Jekyll.logger.info "Destination:", destination
          Jekyll.logger.info "Generating..."
          process_site(site)
          Jekyll.logger.info "", "done."
        end

        # Private: Watch for file changes and rebuild the site.
        #
        # site - A Jekyll::Site instance
        # options - A Hash of options passed to the command
        #
        # Returns nothing.
        def watch(site, options)
          require 'listen'

          source      = options['source']
          destination = options['destination']

          begin
            dest    = Pathname.new(destination).relative_path_from(Pathname.new(source)).to_s
            ignored = Regexp.new(Regexp.escape(dest))
          rescue ArgumentError
            # Destination is outside the source, no need to ignore it.
            ignored = nil
          end

          Jekyll.logger.info "Auto-regeneration:", "enabled"

          listener = Listen.to(
            source, 
            :ignore => ignored, 
            :force_polling => options['force_polling']
          ) do |modified, added, removed|
            t = Time.now.strftime("%Y-%m-%d %H:%M:%S")
            n = modified.length + added.length + removed.length
            print Jekyll.logger.formatted_topic("Regenerating:") + "#{n} files at #{t} "
            process_site(site)
            puts  "...done."
          end
          listener.start

          unless options['serving']
            trap("INT") do
              listener.stop
              puts "     Halting auto-regeneration."
              exit 0
            end

            loop { sleep 1000 }
          end
        end

      end # end of class << self

    end
  end
end
