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
        Jekyll::Stevenson.info "Source:", source
        Jekyll::Stevenson.info "Destination:", destination
        print Jekyll::Stevenson.formatted_topic "Generating..."
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
        require 'directory_watcher'

        source = options['source']
        destination = options['destination']

        Jekyll::Stevenson.info "Auto-regeneration:", "enabled"

        dw = DirectoryWatcher.new(source, :glob => self.globs(source, destination), :pre_load => true)
        dw.interval = 1

        dw.add_observer do |*args|
          t = Time.now.strftime("%Y-%m-%d %H:%M:%S")
          print Jekyll::Stevenson.formatted_topic("Regenerating:") + "#{args.size} files at #{t} "
          self.process_site(site)
          puts  "...done."
        end

        dw.start

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
