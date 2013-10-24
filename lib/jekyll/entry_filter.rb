module Jekyll
  class EntryFilter
    attr_reader :site
    def initialize(site)
      @site = site
    end

    # Filter out any files/directories that are hidden or backup files (start
    # with "." or "#" or end with "~"), or contain site content (start with "_"),
    # or are excluded in the site configuration, unless they are web server
    # files such as '.htaccess'.
    #
    # entries - The Array of String file/directory entries to filter.
    #
    # Returns the Array of filtered entries.
    def filter(entries)
      entries.reject do |e|
        unless included?(e)
          special?(e) || backup?(e) || excluded?(e) || unsafe?(e)
        end
      end
    end

    def special?(entry)
      entry.start_with?('_')
    end

    def backup?(entry)
      entry.start_with?('.', '#') || entry.end_with?('~')
    end

    def excluded?(entry)
      site.exclude.glob_include?(entry)
    end

    def unsafe?(entry)
      File.symlink?(entry) && site.safe
    end

    def included?(entry)
      site.include.glob_include?(entry)
    end
  end
end
