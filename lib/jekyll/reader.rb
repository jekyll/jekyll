# frozen_string_literal: true

module Jekyll
  class Reader
    attr_reader :site

    def initialize(site)
      @site = site
    end

    # Read Site data from disk and load it into internal data structures.
    #
    # Returns nothing.
    def read
      @site.layouts = LayoutReader.new(site).read
      read_directories
      read_included_excludes
      sort_files!
      @site.data = DataReader.new(site).read(site.config["data_dir"])
      CollectionReader.new(site).read
      ThemeAssetsReader.new(site).read
    end

    # Sorts posts, pages, and static files.
    def sort_files!
      site.collections.each_value { |c| c.docs.sort! }
      site.pages.sort_by!(&:name)
      site.static_files.sort_by!(&:relative_path)
    end

    # Recursively traverse directories to find pages and static files
    # that will become part of the site according to the rules in
    # filter_entries.
    #
    # dir - The String relative path of the directory to read. Default: ''.
    #
    # Returns nothing.
    def read_directories(dir = "")
      base = site.in_source_dir(dir)

      return unless File.directory?(base)

      dot_dirs = []
      dot_pages = []
      dot_static_files = []

      dot = Dir.chdir(base) { filter_entries(Dir.entries("."), base) }
      dot.each do |entry|
        file_path = @site.in_source_dir(base, entry)
        if File.directory?(file_path)
          dot_dirs << entry
        elsif Utils.has_yaml_header?(file_path)
          dot_pages << entry
        else
          dot_static_files << entry
        end
      end

      retrieve_posts(dir)
      retrieve_dirs(base, dir, dot_dirs)
      retrieve_pages(dir, dot_pages)
      retrieve_static_files(dir, dot_static_files)
    end

    # Retrieves all the posts(posts/drafts) from the given directory
    # and add them to the site and sort them.
    #
    # dir - The String representing the directory to retrieve the posts from.
    #
    # Returns nothing.
    def retrieve_posts(dir)
      return if outside_configured_directory?(dir)

      site.posts.docs.concat(post_reader.read_posts(dir))
      site.posts.docs.concat(post_reader.read_drafts(dir)) if site.show_drafts
    end

    # Recursively traverse directories with the read_directories function.
    #
    # base - The String representing the site's base directory.
    # dir - The String representing the directory to traverse down.
    # dot_dirs - The Array of subdirectories in the dir.
    #
    # Returns nothing.
    def retrieve_dirs(_base, dir, dot_dirs)
      dot_dirs.each do |file|
        dir_path = site.in_source_dir(dir, file)
        rel_path = PathManager.join(dir, file)
        @site.reader.read_directories(rel_path) unless @site.dest.chomp("/") == dir_path
      end
    end

    # Retrieve all the pages from the current directory,
    # add them to the site and sort them.
    #
    # dir - The String representing the directory retrieve the pages from.
    # dot_pages - The Array of pages in the dir.
    #
    # Returns nothing.
    def retrieve_pages(dir, dot_pages)
      site.pages.concat(PageReader.new(site, dir).read(dot_pages))
    end

    # Retrieve all the static files from the current directory,
    # add them to the site and sort them.
    #
    # dir - The directory retrieve the static files from.
    # dot_static_files - The static files in the dir.
    #
    # Returns nothing.
    def retrieve_static_files(dir, dot_static_files)
      site.static_files.concat(StaticFileReader.new(site, dir).read(dot_static_files))
    end

    # Filter out any files/directories that are hidden or backup files (start
    # with "." or "#" or end with "~"), or contain site content (start with "_"),
    # or are excluded in the site configuration, unless they are web server
    # files such as '.htaccess'.
    #
    # entries - The Array of String file/directory entries to filter.
    # base_directory - The string representing the optional base directory.
    #
    # Returns the Array of filtered entries.
    def filter_entries(entries, base_directory = nil)
      EntryFilter.new(site, base_directory).filter(entries)
    end

    # Read the entries from a particular directory for processing
    #
    # dir - The String representing the relative path of the directory to read.
    # subfolder - The String representing the directory to read.
    #
    # Returns the list of entries to process
    def get_entries(dir, subfolder)
      base = site.in_source_dir(dir, subfolder)
      return [] unless File.exist?(base)

      entries = Dir.chdir(base) { filter_entries(Dir["**/*"], base) }
      entries.delete_if { |e| File.directory?(site.in_source_dir(base, e)) }
    end

    private

    # Internal
    #
    # Determine if the directory is supposed to contain posts and drafts.
    # If the user has defined a custom collections_dir, then attempt to read
    # posts and drafts only from within that directory.
    #
    # Returns true if a custom collections_dir has been set but current directory lies
    # outside that directory.
    def outside_configured_directory?(dir)
      collections_dir = site.config["collections_dir"]
      !collections_dir.empty? && !dir.start_with?("/#{collections_dir}")
    end

    # Create a single PostReader instance to retrieve drafts and posts from all valid
    # directories in current site.
    def post_reader
      @post_reader ||= PostReader.new(site)
    end

    def read_included_excludes
      entry_filter = EntryFilter.new(site)

      site.include.each do |entry|
        entry_path = site.in_source_dir(entry)
        next if File.directory?(entry_path)
        next if entry_filter.symlink?(entry_path)

        read_included_file(entry_path) if File.file?(entry_path)
      end
    end

    def read_included_file(entry_path)
      if Utils.has_yaml_header?(entry_path)
        conditionally_generate_entry(entry_path, site.pages, PageReader)
      else
        conditionally_generate_entry(entry_path, site.static_files, StaticFileReader)
      end
    end

    def conditionally_generate_entry(entry_path, container, reader)
      return if container.find { |item| site.in_source_dir(item.relative_path) == entry_path }

      dir, files = File.split(entry_path)
      dir.sub!(site.source, "")
      files = Array(files)
      container.concat(reader.new(site, dir).read(files))
    end
  end
end
