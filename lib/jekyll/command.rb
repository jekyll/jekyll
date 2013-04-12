module Jekyll
  class Command
    def self.globs(source, destination)
      Dir.chdir(source) do
        dirs = Dir['*'].select { |x| File.directory?(x) }
        dirs -= [destination, File.expand_path(destination), File.basename(destination)]
        dirs = dirs.map { |x| "#{x}/**/*" }
        dirs += ['*']
      end
    end

    # Static: Run Site#process and catch errors
    #
    # site - the Jekyll::Site object
    #
    # Returns nothing
    def self.process_site(site)
      begin
        site.process
      rescue Jekyll::FatalException => e
        puts
        puts "ERROR: YOUR SITE COULD NOT BE BUILT:"
        puts "------------------------------------"
        puts e.message
        exit(1)
      end
    end
  end
end
