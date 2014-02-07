class LayoutReader
  attr_reader :site
  def initialize(site)
    @site = site
    @layouts = {}
  end

  def read
    layout_entries.each do |f|
      @layouts[layout_name(f)] = Layout.new(site, layout_directory, f)
    end

    @layouts
  end

  private

  def layout_entries
    entries = []
    within(layout_directory) do
      entries = EntryFilter.new(site).filter(Dir['**/*.*'])
    end
    entries
  end

  def layout_name(file)
    file.split(".")[0..-2].join(".")
  end

  def within(directory)
    return unless File.exists?(directory)
    Dir.chdir(directory) { yield }
  end

  def layout_directory
    File.join(site.source, site.config['layouts'])
  end


end
