module Jekyll

  class BuildCommand < Command
    def self.process(options)
      opts = {}
      options.__hash__.map do |k,v|
        opts[k.to_s] = v
      end

      opts = Jekyll.configuration(opts)
      site = Jekyll::Site.new(opts)

      source = opts['source']
      destination = opts['destination']

      if opts['watch']
        self.watch(site, source, destination)
      else
        self.build(site, source, destination)
      end
    end

    # Private: Build the site from source into destination.
    #
    # site - A Jekyll::Site instance
    # source - A String of the source path
    # destination - A String of the destination path
    #
    # Returns nothing.
    def self.build(site, source, destination)
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
    # source - A String of the source path
    # destination - A String of the destination path
    #
    # Returns nothing.
    def self.watch(site, source, destination)
      require 'directory_watcher'

      puts "Auto-Regenerating enabled: #{source} -> #{destination}"

      dw = DirectoryWatcher.new(source)
      dw.interval = 1
      dw.glob = self.globs(source)

      dw.add_observer do |*args|
        t = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        puts "[#{t} regeneration: #{args.size} files changed"
        site.process
      end

      dw.start

      trap("SIGINT") do
        puts "Stopping auto-regeneration..."
        exit 0
      end

      loop { sleep 1000 }
    end
  end

end
