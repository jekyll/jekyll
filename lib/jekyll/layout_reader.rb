class LayoutReader
  attr_reader :site

  def initialize(site)
    @site = site
  end

  # Read all the files in <source>/<layouts> and create a new Layout object
  # with each one.
  #
  # Returns a Hash with layout names as keys and their disk location as values
  def collect
    layouts = {}
    with_layout_directory(site.source, site.config['layouts']) do |base|
      layout_entries(base).each do |f|
        layouts[layout_name(f)] = Layout.new(site, base, f)
      end
    end

    layouts
  end

  # Verifies the layout directory exists and yields it if it does.
  #
  # Returs nothing
  def with_layout_directory(source, layout_location)
    base = File.join(source, layout_location)
    yield base if File.exists?(base)
  end

  def layout_entries(base)
    Dir.chdir(base) { EntryFilter.new(site).filter(Dir['**/*.*']) }
  end

  def layout_name(f)
    File.basename(f, File.extname(f))
  end
end
