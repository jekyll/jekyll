module Jekyll
  class Page
    include Convertible

    attr_writer :dir
    attr_accessor :site, :pager
    attr_accessor :name, :ext, :basename
    attr_accessor :data, :content, :output

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

      self.process(name)
      self.read_yaml(File.join(base, dir), name)

      unless self.data.has_key?('layout')
        self.data['layout'] = site.default_layouts.find(File.join(dir, name), :page)
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
      self.data && self.data['permalink']
    end

    # The template of the permalink.
    #
    # Returns the template String.
    def template
      if self.site.permalink_style == :pretty
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
      return @url if @url

      url = if permalink
        if site.config['relative_permalinks']
          File.join(@dir, permalink)
        else
          permalink
        end
      else
        {
          "path"       => @dir,
          "basename"   => self.basename,
          "output_ext" => self.output_ext,
        }.inject(template) { |result, token|
          result.gsub(/:#{token.first}/, token.last)
        }.gsub(/\/\//, "/")
      end

      # sanitize url
      @url = url.split('/').reject{ |part| part =~ /^\.+$/ }.join('/')
      @url += "/" if url =~ /\/$/
      @url.gsub!(/\A([^\/])/, '/\1')
      @url
    end

    # Extract information from the page filename.
    #
    # name - The String filename of the page file.
    #
    # Returns nothing.
    def process(name)
      self.ext = File.extname(name)
      self.basename = name[0 .. -self.ext.length-1]
    end

    # Add any necessary layouts to this post
    #
    # layouts      - The Hash of {"name" => "layout"}.
    # site_payload - The site payload Hash.
    #
    # Returns nothing.
    def render(layouts, site_payload)
      payload = {
        "page" => self.to_liquid,
        'paginator' => pager.to_liquid
      }.deep_merge(site_payload)

      do_layout(payload, layouts)
    end

    # Convert this Page's data to a Hash suitable for use by Liquid.
    #
    # Returns the Hash representation of this Page.
    def to_liquid
      self.data.deep_merge({
        "url"        => self.url,
        "content"    => self.content,
        "path"       => self.data['path'] || path })
    end

    # The path to the source file
    #
    # Returns the path to the source file
    def path
      File.join(@dir, @name).sub(/\A\//, '')
    end

    # Obtain destination path.
    #
    # dest - The String path to the destination dir.
    #
    # Returns the destination file path String.
    def destination(dest)
      path = File.join(dest, self.url)
      path = File.join(path, "index.html") if self.url =~ /\/$/
      path
    end

    # Returns the object as a debug String.
    def inspect
      "#<Jekyll:Page @name=#{self.name.inspect}>"
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
      permalink && @dir != "" && site.config['relative_permalinks']
    end
  end
end
