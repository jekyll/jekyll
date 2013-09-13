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
        Jekyll.logger.info "Auto-regeneration:", "enabled"

        dw = self.setup_watcher(options['source'], options['destination'])
        dw.start

        unless options['serving']
          trap("INT") do
            puts "     Halting auto-regeneration."
            exit 0
          end

          loop { sleep 1000 }
        end
      end

      # Private: Create and configure a DirectoryWatcher instance
      #
      # source - the source path
      # destination - the destination path
      #
      # Returns a DirectoryWatcher instance
      def self.setup_watcher(source, destination)
        require 'directory_watcher'

        dw = DirectoryWatcher.new(source, :glob => self.globs(source, destination), :pre_load => true)
        dw.interval = 1

        dw.add_observer do |*args|
          t = Time.now.strftime("%Y-%m-%d %H:%M:%S")
          print Jekyll.logger.formatted_topic("Regenerating:") + "#{args.size} files at #{t} "
          self.process_site(site)
          puts  "...done."
        end

        dw
      end
    end
  end
end
