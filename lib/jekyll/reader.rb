# encoding: UTF-8
require 'csv'

module Jekyll
  class Reader
    attr_reader :site

    def initialize(site)
      @site = site
    end

    # Public: Prefix a given path with the source directory.
    #
    # paths - (optional) path elements to a file or directory within the
    #         source directory
    #
    # Returns a path which is prefixed with the source directory.
    def in_source_dir(*paths)
      paths.reduce(site.source) do |base, path|
        Jekyll.sanitized_path(base, path)
      end
    end

    # Public: Prefix a given path with the destination directory.
    #
    # paths - (optional) path elements to a file or directory within the
    #         destination directory
    #
    # Returns a path which is prefixed with the destination directory.
    def in_dest_dir(*paths)
      paths.reduce(site.dest) do |base, path|
        Jekyll.sanitized_path(base, path)
      end
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
  end
end