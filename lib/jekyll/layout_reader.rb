class LayoutReader
  attr_reader :site
  def initialize(site)
    @site = site
    @layouts = {}
  end

  def read
      base = File.join(site.source, site.config['layouts'])
      return @layouts unless File.exists?(base)
      entries = []
      Dir.chdir(base) { entries = EntryFilter.new(site).filter(Dir['**/*.*']) }

      entries.each do |f|
        name = f.split(".")[0..-2].join(".")
        @layouts[name] = Layout.new(site, base, f)
      end

      @layouts
  end
end
