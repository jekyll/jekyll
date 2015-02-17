module Jekyll
  class Page
    include Convertible

    attr_writer :dir
    attr_accessor :site, :pager
    attr_accessor :name, :ext, :basename
    attr_accessor :data, :content, :output

    # Attributes for Liquid templates
    ATTRIBUTES_FOR_LIQUID = %w[
      content
      dir
      name
      path
      url
    ]

    # Initialize a new Page.
    #
    # site - The Site object.
    # base - The String path to the source.
    # dir  - The String path between the source and the file.
    # name - The String filename of the file.
    def initialize(site, base, dir, name)
      @site = site
      @base = base
      @dir  = dir
      @name = name


      process(name)
      read_yaml(File.join(base, dir), name)

      data.default_proc = proc do |hash, key|
        site.frontmatter_defaults.find(File.join(dir, name), type, key)
      end
    end

    # The generated directory into which the page will be placed
    # upon generation. This is derived from the permalink or, if
    # permalink is absent, we be '/'
    #
    # Returns the String destination directory.
    def dir
      url[-1, 1] == '/' ? url : File.dirname(url)
    end

    # The full path and filename of the post. Defined in the YAML of the post
    # body.
    #
    # Returns the String permalink or nil if none has been set.
    def permalink
      return nil if data.nil? || data['permalink'].nil?
      if site.config['relative_permalinks']
        File.join(@dir, data['permalink'])
      else
        data['permalink']
      end
    end

    # The template of the permalink.
    #
    # Returns the template String.
    def template
      if site.permalink_style == :pretty
        if index? && html?
          "/:path/"
        elsif html?
          "/:path/:basename/"
        else
          "/:path/:basename:output_ext"
        end
      else
        "/:path/:basename:output_ext"
      end
    end

    # The generated relative url of this page. e.g. /about.html.
    #
    # Returns the String url.
    def url
      @url ||= URL.new({
        :template => template,
        :placeholders => url_placeholders,
        :permalink => permalink
      }).to_s
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
      self.basename = name[0 .. -ext.length - 1]
    end

    # Add any necessary layouts to this post
    #
    # layouts      - The Hash of {"name" => "layout"}.
    # site_payload - The site payload Hash.
    #
    # Returns nothing.
    def render(layouts, site_payload)
      payload = Utils.deep_merge_hashes({
        "page" => to_liquid,
        'paginator' => pager.to_liquid
      }, site_payload)

      do_layout(payload, layouts)
    end

    # The path to the source file
    #
    # Returns the path to the source file
    def path
      data.fetch('path') { relative_path.sub(/\A\//, '') }
    end

    # The path to the page source file, relative to the site source
    def relative_path
      File.join(*[@dir, @name].map(&:to_s).reject(&:empty?))
    end

    # Obtain destination path.
    #
    # dest - The String path to the destination dir.
    #
    # Returns the destination file path String.
    def destination(dest)
      path = site.in_dest_dir(dest, URL.unescape_path(url))
      path = File.join(path, "index.html") if url =~ /\/$/
      path
    end

    # Returns the object as a debug String.
    def inspect
      "#<Jekyll:Page @name=#{name.inspect}>"
    end

    # Returns the Boolean of whether this Page is HTML or not.
    def html?
      output_ext == '.html'
    end

    # Returns the Boolean of whether this Page is an index file or not.
    def index?
      basename == 'index'
    end

    def uses_relative_permalinks
      permalink && !@dir.empty? && site.config['relative_permalinks']
    end
  end
end
