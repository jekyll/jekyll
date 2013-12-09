module Jekyll
  class EntryFilter
    attr_reader :site

    def initialize(site)
      @site = site
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
      site.exclude.glob_include?(entry)
    end

    def symlink?(entry)
      File.symlink?(entry) && site.safe
    end
  end
end
