module Jekyll
  class EntryFilter
    attr_reader :site

    def initialize(site, base_directory = nil)
      @site = site
      @base_directory = derive_base_directory(@site, base_directory.dup)
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
          special?(e) || backup?(e) || excluded?(e) || symlink?(e)
        end
      end
    end

    def included?(entry)
      site.include.glob_include?(entry)
    end

    def special?(entry)
      ['.', '_', '#'].include?(entry[0..0])
    end

    def backup?(entry)
      entry[-1..-1] == '~'
    end

    def excluded?(entry)
      excluded = site.exclude.glob_include?(relative_to_source(entry))
      Jekyll.logger.debug "excluded?(#{relative_to_source(entry)}) ==> #{excluded}"
      excluded
    end

    def symlink?(entry)
      File.symlink?(entry) && site.safe
    end
  end
end
