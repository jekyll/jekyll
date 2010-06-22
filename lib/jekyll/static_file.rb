module Jekyll

  class StaticFile
    @@mtimes = Hash.new # the cache of last modification times [path] -> mtime

    # Initialize a new StaticFile.
    #   +site+ is the Site
    #   +base+ is the String path to the <source>
    #   +dir+ is the String path between <source> and the file
    #   +name+ is the String filename of the file
    #
    # Returns <StaticFile>
    def initialize(site, base, dir, name)
      @site = site
      @base = base
      @dir  = dir
      @name = name
    end

    # Obtains source file path.
    #
    # Returns source file path.
    def path
      File.join(@base, @dir, @name)
    end

    # Obtain destination path.
    #   +dest+ is the String path to the destination dir
    #
    # Returns destination file path.
    def destination(dest)
      File.join(dest, @dir, @name)
    end

    # Obtain mtime of the source path.
    #
    # Returns last modifiaction time for this file.
    def mtime
      File.stat(path).mtime.to_i
    end

    # Is source path modified?
    #
    # Returns true if modified since last write.
    def modified?
      @@mtimes[path] != mtime
    end

    # Write the static file to the destination directory (if modified).
    #   +dest+ is the String path to the destination dir
    #
    # Returns false if the file was not modified since last time (no-op).
    def write(dest)
      dest_path = destination(dest)
      dest_dir = File.join(dest, @dir)

      return false if File.exist? dest_path and !modified?
      @@mtimes[path] = mtime

      FileUtils.mkdir_p(dest_dir)
      FileUtils.cp(path, dest_path)

      true
    end

    # Reset the mtimes cache (for testing purposes).
    #
    # Returns nothing.
    def self.reset_cache
      @@mtimes = Hash.new

      nil
    end
  end

end
