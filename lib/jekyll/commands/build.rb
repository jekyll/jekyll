module Jekyll
  module Commands
    class Build < Command
      def self.process(options)
        site = Jekyll::Site.new(options)

        self.build(site, options)
        self.watch(site, options) if options['watch']
      end

      # Private: Build the site from source into destination.
      #
      # site - A Jekyll::Site instance
      # options - A Hash of options passed to the command
      #
      # Returns nothing.
      def self.build(site, options)
        source = options['source']
        destination = options['destination']
        Jekyll.logger.info "Source:", source
        Jekyll.logger.info "Destination:", destination
        print Jekyll.logger.formatted_topic "Generating..."
        self.process_site(site)
        puts "done."
      end

      # Private: Watch for file changes and rebuild the site.
      #
      # site - A Jekyll::Site instance
      # options - A Hash of options passed to the command
      #
      # Returns nothing.
      def self.watch(site, options)
        require 'listen'
        require 'pathname'

        source = options['source']
        destination = Pathname.new(options['destination'])
                              .relative_path_from(Pathname.new(source))
                              .to_path

        Jekyll.logger.info "Auto-regeneration:", "enabled"

        Listen.to(source, :ignore => %r{#{Regexp.escape(destination)}}) do |modified, added, removed|
          t = Time.now.strftime("%Y-%m-%d %H:%M:%S")
          n = modified.length + added.length + removed.length
          print Jekyll.logger.formatted_topic("Regenerating:") + "#{n} files at #{t} "
          self.process_site(site)
          puts  "...done."
        end

        unless options['serving']
          trap("INT") do
            puts "     Halting auto-regeneration."
            exit 0
          end

          loop { sleep 1000 }
        end
      end
    end
  end
end
