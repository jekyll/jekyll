class LayoutReader
  attr_reader :site, :layouts
  def initialize(site)
    @site = site
    @layouts = {}
  end

  # Read all the files in <source>/<layouts> and create a new Layout object
  # with each one.
  #
  # Returns a Hash with layout names as keys and their disk location as values
  def collect
    with_layout_directory(site.source, site.config['layouts']) do |base|
      layout_entries(base).each do |f|
        layouts[layout_name(f)] = Layout.new(site, base, f)
      end
    end

    layouts
  end

  # Filter out any files/directories that are hidden or backup files (start
  # with "." or "#" or end with "~"), or contain site content (start with "_"),
  # or are excluded in the site configuration, unless they are web server
  # files such as '.htaccess'.
  #
  # entries - The Array of String file/directory entries to filter.
  #
  # Returns the Array of filtered entries.
  def filter_entries(entries)
    entries.reject do |e|
      unless site.include.glob_include?(e)
        ['.', '_', '#'].include?(e[0..0]) ||
          e[-1..-1] == '~' ||
          site.exclude.glob_include?(e) ||
          (File.symlink?(e) && site.safe)
      end
    end
  end

  # Verifies the layout directory exists and yields it if it does.
  #
  # Returs nothing
  def with_layout_directory(source, layout_location)
    base = File.join(source, layout_location)
    yield base if File.exists?(base)
  end

  def layout_entries(base)
    Dir.chdir(base) { filter_entries(Dir['*.*']) }
  end

  def layout_name(f)
    File.basename(f, File.extname(f))
  end
end
