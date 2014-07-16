module Jekyll
  class Reader
    attr_reader :site

    # Create a new Reader.
    #
    # site - the instance of Jekyll::Site we're concerned with
    #
    # Returns nothing.
    def initialize(site)
      @site = site
    end

    # Reads in pages, posts, drafts, static files, data files, and collections.
    # **NOTE:** Mutates the `site` object.
    #
    # Returns nothing
    def read_all!
      read_directories
      read_data(site.config['data_source'])
      read_collections
    end

    # Read in all collections specified in the configuration
    #
    # Returns nothing.
    def read_collections
      site.collections.each do |_, collection|
        collection.read unless collection.label.eql?("data")
      end
    end

    # Recursively traverse directories to find posts, pages and static files
    # that will become part of the site according to the rules in
    # filter_entries.
    #
    # dir - The String relative path of the directory to read. Default: ''.
    #
    # Returns nothing.
    def read_directories(dir = '')
      base = Jekyll.sanitized_path(site.source, dir)
      entries = Dir.chdir(base) { filter_entries(Dir.entries('.'), base) }

      read_posts(dir)
      read_drafts(dir) if site.show_drafts

      entries.each do |f|
        absolute_path = File.join(base, f)
        if File.directory?(absolute_path)
          relative_path = File.join(dir, f)
          read_directories(relative_path) unless site.dest.sub(/\/$/, '') == absolute_path
        elsif has_yaml_header?(absolute_path)
          page = Page.new(site, site.source, dir, f)
          site.pages << page if site.publisher.publish?(page)
        else
          site.static_files << StaticFile.new(site, site.source, dir, f)
        end
      end
    end

    # Read all the files in <source>/<dir>/_posts and create a new Post
    # object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_posts(dir)
      posts = read_content(dir, '_posts', Post)
      (site.posts ||= []).concat posts.select {|post| site.publisher.publish?(post) }
    end

    # Read all the files in <source>/<dir>/_drafts and create a new Post
    # object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_drafts(dir)
      (site.drafts ||= []).concat read_content(dir, '_drafts', Draft)
    end

    # Read
    #
    # Returns an array of
    def read_content(dir, magic_dir, klass)
      get_entries(dir, magic_dir).map do |entry|
        klass.new(site, site.source, dir, entry) if klass.valid?(entry)
      end.reject do |entry|
        entry.nil?
      end
    end

    # Read and parse all yaml files under <source>/<dir>
    #
    # Returns nothing
    def read_data(dir)
      base = Jekyll.sanitized_path(site.source, dir)
      read_data_to(base, site.data)
    end

    # Read and parse all yaml files under <dir> and add them to the
    # <data> variable.
    #
    # dir - The string absolute path of the directory to read.
    # data - The variable to which data will be added.
    #
    # Returns nothing
    def read_data_to(dir, data)
      return unless safe_directory?(dir)

      entries = Dir.chdir(dir) do
        Dir['*.{yaml,yml,json}'] + Dir['*'].select { |fn| File.directory?(fn) }
      end

      entries.each do |entry|
        path = Jekyll.sanitized_path(dir, entry)
        next unless safe_file?(path)

        key = sanitize_filename(File.basename(entry, '.*'))
        if File.directory?(path)
          read_data_to(path, data[key] = {})
        else
          data[key] = SafeYAML.load_file(path)
        end
      end
    end

    # Read the entries from a particular directory for processing
    #
    # dir - The String relative path of the directory to read
    # subfolder - The String directory to read
    #
    # Returns the list of entries to process
    def get_entries(dir, subfolder)
      base = Jekyll.sanitized_path(site.source, File.join(dir, subfolder))
      return [] unless safe_directory?(base)
      entries = Dir.chdir(base) { filter_entries(Dir['**/*'], base) }
      entries.delete_if { |e| File.directory?(File.join(base, e)) }
    end

    # Filter out any files/directories that are hidden or backup files (start
    # with "." or "#" or end with "~"), or contain site content (start with "_"),
    # or are excluded in the site configuration, unless they are web server
    # files such as '.htaccess'.
    #
    # entries - The Array of String file/directory entries to filter.
    #
    # Returns the Array of filtered entries.
    def filter_entries(entries, base_directory = nil)
      EntryFilter.new(site, base_directory).filter(entries)
    end

    # Check if the beginning of the yaml header ('---') exists.
    #
    # path - the file path
    #
    # Returns true if the first 4 bytes of the file are '---<newline>'
    def has_yaml_header?(path)
      !!(File.open(path, 'rb') { |f| f.read(5) } =~ /\A---\r?\n/)
    end

    # A version of the filename which is considered a valid key.
    # It removes everything but [0-9a-zA-Z], underscores, spaces, and hyphens
    # It replaces contiguous strings of spaces with one underscore.
    #
    # name - the filename to 'sanitize'
    #
    # Returns the 'sanitized' filename.
    def sanitize_filename(name)
      name
        .gsub(/[^\w\s_-]+/, '')
        .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
        .gsub(/\s+/, '_')
    end

    # Determines whether the directory is safe.
    # Uses `#safe_file?` to determine safety, and also checks to make sure
    # it's a file on the file system.
    #
    # Returns true if the directory is safe by the definition above.
    def safe_directory?(dir)
      File.directory?(dir) && safe_file?(dir)
    end

    # Determines whether the file is safe.
    # A file is safe if it is indeed a directory on the FS, and if it either:
    #     1. The site's `safe` attribute is `false`.
    #     2. The site's `safe` attribute is `true` and the file is not a symlink.
    #
    # Returns true if the file is safe by the definition above.
    def safe_file?(path)
      !(File.symlink?(path) && site.safe)
    end
  end
end
