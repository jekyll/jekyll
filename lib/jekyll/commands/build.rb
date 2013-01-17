module Jekyll

  class BuildCommand < Command
    def self.process(options)
      site = Jekyll::Site.new(options)

      source = options['source']
      destination = options['destination']

      if options['watch']
        self.watch(site, options)
      else
        self.build(site, options)
      end
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
      puts "Building site: #{source} -> #{destination}"
      begin
        site.process
      rescue Jekyll::FatalException => e
        puts
        puts "ERROR: YOUR SITE COULD NOT BE BUILT:"
        puts "------------------------------------"
        puts e.message
        exit(1)
      end
      puts "Successfully generated site: #{source} -> #{destination}"
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

      puts "Auto-Regenerating enabled: #{source} -> #{destination}"

      dw = DirectoryWatcher.new(source)
      dw.interval = 1
      dw.glob = self.globs(source)

      dw.add_observer do |*args|
        t = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        puts "[#{t}] regeneration: #{args.size} files changed"
        site.process
      end

      dw.start

      unless options['serving']
        trap("INT") do
          puts "Stopping auto-regeneration..."
          exit 0
        end

        loop { sleep 1000 }
      end
    end
  end

end
