module Jekyll
  class EntryFilter
    attr_reader :site

    def initialize(site, base_directory = nil)
      @site = site
      @base_directory = derive_base_directory(@site, base_directory.to_s.dup)
    end

    def base_directory
      @base_directory.to_s
    end

    def derive_base_directory(site, base_dir)
      if base_dir.start_with?(site.source)
        base_dir[site.source] = ""
      end
      base_dir
    end

    def relative_to_source(entry)
      File.join(base_directory, entry)
    end

    def filter(entries)
      entries.reject do |e|
        unless included?(e)
          special?(e) || backup?(e) || excluded?(e) || symlink?(e) || docs?(e)
        end
      end
    end

    def included?(entry)
      glob_include?(site.include, entry)
    end

    def special?(entry)
      ['.', '_', '#'].include?(entry[0..0])
    end

    def backup?(entry)
      entry[-1..-1] == '~'
    end

    def excluded?(entry)
      excluded = glob_include?(site.exclude, relative_to_source(entry))
      Jekyll.logger.debug "excluded?(#{relative_to_source(entry)}) ==> #{excluded}"
      excluded
    end

    def symlink?(entry)
      File.symlink?(entry) && site.safe
    end

    def docs?(entry)
      glob_include(["README.*","CONTRIBUTING.*"], entry)
    end

    def ensure_leading_slash(path)
      path[0..0] == "/" ? path : "/#{path}"
    end

    # Returns true if path matches against any glob pattern.
    # Look for more detail about glob pattern in method File::fnmatch.
    def glob_include?(enum, e)
      entry = ensure_leading_slash(e)
      enum.any? do |exp|
        item = ensure_leading_slash(exp)
        Jekyll.logger.debug "glob_include?(#{entry})"
        Jekyll.logger.debug "    ==> File.fnmatch?(#{item}, #{entry}) == #{File.fnmatch?(item, entry)}"
        File.fnmatch?(item, entry)
      end
    end
  end
end
