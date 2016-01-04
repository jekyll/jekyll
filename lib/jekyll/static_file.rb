module Jekyll
  class StaticFile
    # The cache of last modification times [path] -> mtime.
    @@mtimes = {}

    attr_reader :relative_path, :extname

    # Initialize a new StaticFile.
    #
    # site - The Site.
    # base - The String path to the <source>.
    # dir  - The String path between <source> and the file.
    # name - The String filename of the file.
    def initialize(site, base, dir, name, collection = nil)
      @site = site
      @base = base
      @dir  = dir
      @name = name
      @collection = collection
      @relative_path = File.join(*[@dir, @name].compact)
      @extname = File.extname(@name)
    end

    # Returns source file path.
    def path
      File.join(*[@base, @dir, @name].compact)
    end

    # Obtain destination path.
    #
    # dest - The String path to the destination dir.
    #
    # Returns destination file path.
    def destination(dest)
      @site.in_dest_dir(*[dest, destination_rel_dir, @name].compact)
    end

    def destination_rel_dir
      if @collection
        File.dirname(url)
      else
        @dir
      end
    end

    def modified_time
      @modified_time ||= File.stat(path).mtime
    end

    # Returns last modification time for this file.
    def mtime
      modified_time.to_i
    end

    # Is source path modified?
    #
    # Returns true if modified since last write.
    def modified?
      @@mtimes[path] != mtime
    end

    # Whether to write the file to the filesystem
    #
    # Returns true unless the defaults for the destination path from
    # _config.yml contain `published: false`.
    def write?
      defaults.fetch('published', true)
    end

    # Write the static file to the destination directory (if modified).
    #
    # dest - The String path to the destination dir.
    #
    # Returns false if the file was not modified since last time (no-op).
    def write(dest)
      dest_path = destination(dest)

      return false if File.exist?(dest_path) && !modified?
      @@mtimes[path] = mtime

      FileUtils.mkdir_p(File.dirname(dest_path))
      FileUtils.rm(dest_path) if File.exist?(dest_path)
      FileUtils.cp(path, dest_path)
      File.utime(@@mtimes[path], @@mtimes[path], dest_path)

      true
    end

    # Reset the mtimes cache (for testing purposes).
    #
    # Returns nothing.
    def self.reset_cache
      @@mtimes = {}
      nil
    end

    def to_liquid
      {
        "extname"       => extname,
        "modified_time" => modified_time,
        "path"          => File.join("", relative_path)
      }
    end

    def placeholders
      {
        :collection => @collection.label,
        :path => relative_path[
          @collection.relative_directory.size..relative_path.size],
        :output_ext => '',
        :name => '',
        :title => ''
      }
    end

    # Applies a similar URL-building technique as Jekyll::Document that takes
    # the collection's URL template into account. The default URL template can
    # be overriden in the collection's configuration in _config.yml.
    def url
      @url ||= if @collection.nil?
                 relative_path
               else
                 ::Jekyll::URL.new({
                   :template => @collection.url_template,
                   :placeholders => placeholders
                 })
               end.to_s.gsub(/\/$/, '')
    end

    # Returns the type of the collection if present, nil otherwise.
    def type
      @type ||= @collection.nil? ? nil : @collection.label.to_sym
    end

    # Returns the front matter defaults defined for the file's URL and/or type
    # as defined in _config.yml.
    def defaults
      @defaults ||= @site.frontmatter_defaults.all url, type
    end
  end
end
