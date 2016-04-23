module Jekyll
  class Page < Document
    attr_writer :dir
    attr_accessor :pager
    attr_accessor :name, :ext, :basename
    attr_writer :data

    alias_method :extname, :ext

    FORWARD_SLASH = '/'.freeze

    # Compatibility
    #
    # Attributes for Liquid templates
    ATTRIBUTES_FOR_LIQUID = %w(
      content
      dir
      name
      path
      url
    )

    # A set of extensions that are considered HTML or HTML-like so we
    # should not alter them,  this includes .xhtml through XHTM5.
    HTML_EXTENSIONS = %W(
      .html
      .xhtml
      .htm
    )

    # Initialize a new Page.
    #
    # site - The Site object.
    # base - The String path to the source.
    # dir  - The String path between the source and the file.
    # name - The String filename of the file.
    def initialize(site, base, dir, name)
      @base = base
      @dir = dir
      @name = name

      full_path = site.in_source_dir(base, dir, name)
      super(full_path, {
        :site => site,
        :collection => site.pages
      })

      process(@name)
      read(path: full_path)
    end

    # Compatibility
    #
    # The generated directory into which the page will be placed
    # upon generation. This is derived from the permalink or, if
    # permalink is absent, we be '/'
    #
    # Returns the String destination directory.
    def dir
      if url.end_with?(FORWARD_SLASH)
        url
      else
        url_dir = File.dirname(url)
        url_dir.end_with?(FORWARD_SLASH) ? url_dir : "#{url_dir}/"
      end
    end

    # The template of the permalink.
    #
    # Returns the template String.
    def url_template
      if !html?
        "/:path/:basename:output_ext"
      elsif index?
        "/:path/"
      else
        Utils.add_permalink_suffix("/:path/:basename", site.permalink_style)
      end
    end

    # Returns a hash of URL placeholder names (as symbols) mapping to the
    # desired placeholder replacements. For details see "url.rb"
    def url_placeholders
      {
        :path       => @dir,
        :basename   => basename,
        :output_ext => output_ext
      }
    end

    # Extract information from the page filename.
    #
    # name - The String filename of the page file.
    #
    # Returns nothing.
    def process(name)
      self.ext = File.extname(name)
      self.basename = name[0..-ext.length - 1]

      # Invalidate URL
      @url = nil
      url
    end

    # Compatibility
    #
    # Render the page
    def render(layouts, site_payload)
      self.output = Jekyll::Renderer.new(@site, self, site_payload).run
    end

    # Compatibility
    #
    # The path to the source file
    #
    # Returns the path to the source file
    def path
      data.fetch('path') { relative_path.sub(/\A\//, '') }
    end

    # Compatiblity
    #
    # The path to the page source file, relative to the site source
    def relative_path
      File.join(*[@dir, @name].map(&:to_s).reject(&:empty?))
    end

    # Compatibility
    #
    # Obtain destination path.
    #
    # dest - The String path to the destination dir.
    #
    # Returns the destination file path String.
    def destination(dest)
      path = site.in_dest_dir(dest, URL.unescape_path(url))
      path = File.join(path, "index") if url.end_with?("/")
      path << output_ext unless path.end_with? output_ext
      path
    end

    # Returns the Boolean of whether this Page is HTML or not.
    def html?
      HTML_EXTENSIONS.include?(output_ext)
    end

    # Returns the Boolean of whether this Page is an index file or not.
    def index?
      basename == 'index'
    end

    def trigger_hooks(hook_name, *args)
      Jekyll::Hooks.trigger :pages, hook_name, self, *args
    end

    # Don't generate excerpts for pages
    def generate_excerpt?
      false
    end

    # Determine whether the file should be rendered with Liquid.
    #
    # Always returns true.
    def render_with_liquid?
      true
    end

    # Don't generate a title
    def post_read
      original = data['title']
      super
      data['title'] = original
    end

    # Compatibility
    #
    # Accessor for data properties by Liquid.
    #
    # property - The String name of the property to retrieve.
    #
    # Returns the String value or nil if the property isn't included.
    def [](property)
      if self.class::ATTRIBUTES_FOR_LIQUID.include?(property)
        send(property)
      else
        data[property]
      end
    end

  end
end
