# encoding: UTF-8
require 'csv'

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
      @site.data = DataReader.new(site).read(site.config['data_source'])
      CollectionReader.new(site).read
    end

    # Recursively traverse directories to find posts, pages and static files
    # that will become part of the site according to the rules in
    # filter_entries.
    #
    # dir - The String relative path of the directory to read. Default: ''.
    #
    # Returns nothing.
    def read_directories(dir = '')
      retrieve_posts(dir)

      # Obtain sub-directories in order to recursively read them.
      base = site.in_source_dir(dir)
      dot = Dir.chdir(base) { filter_entries(Dir.entries('.'), base) }
      dot_dirs = dot.select{ |file| File.directory?(@site.in_source_dir(base,file)) }
      retrieve_dirs(base, dir, dot_dirs)

      dot_files = (dot - dot_dirs)

      # Obtain all the pages.
      dot_pages = dot_files.select{ |file| Utils.has_yaml_header?(@site.in_source_dir(base,file)) }
      retrieve_pages(dir, dot_pages)

      # Assume the remaining files to be static files.
      dot_static_files = dot_files - dot_pages
      retrieve_static_files(dir, dot_static_files)
    end

    # Retrieves all the posts(posts/drafts) from the given directory
    # and add them to the site and sort them.
    #
    # Returns nothing.
    def retrieve_posts(dir)
      site.posts.concat(PostReader.new(site).read(dir))
      site.posts.concat(DraftReader.new(site).read(dir)) if site.show_drafts
      site.posts.sort!
    end

    # Recursively traverse directories with the read_directories function.
    #
    # Returns nothing.
    def retrieve_dirs(base, dir, dot_dirs)
      dot_dirs.map { |file|
        dir_path = site.in_source_dir(dir,file)
        rel_path = File.join(dir, file)
        @site.reader.read_directories(rel_path) unless @site.dest.sub(/\/$/, '') == dir_path
      }
    end

    # Retrieve all the pages from the current directory,
    # add them to the site and sort them.
    #
    # Returns nothing.
    def retrieve_pages(dir, dot_pages)
      site.pages.concat(PageReader.new(site, dir).read(dot_pages))
      site.pages.sort_by!(&:name)
    end

    # Retrieve all the static files from the current directory,
    # add them to the site and sort them.
    #
    # Returns nothing.
    def retrieve_static_files(dir, dot_static_files)
      site.static_files.concat(StaticFileReader.new(site, dir).read(dot_static_files))
      site.static_files.sort_by!(&:relative_path)
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

    # Read the entries from a particular directory for processing
    #
    # dir - The String relative path of the directory to read
    # subfolder - The String directory to read
    #
    # Returns the list of entries to process
    def get_entries(dir, subfolder)
      base = site.in_source_dir(dir, subfolder)
      return [] unless File.exist?(base)
      entries = Dir.chdir(base) { filter_entries(Dir['**/*'], base) }
      entries.delete_if { |e| File.directory?(site.in_source_dir(base, e)) }
    end
  end
end
