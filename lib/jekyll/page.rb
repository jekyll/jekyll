module Jekyll
  class Page < Document
    attr_accessor :pager

    # Attributes for Liquid templates
    ATTRIBUTES_FOR_LIQUID = %w[
      content
      dir
      name
      path
      url
    ]

    # The generated directory into which the page will be placed
    # upon generation. This is derived from the permalink or, if
    # permalink is absent, we be '/'
    #
    # Returns the String destination directory.
    def dir
      url[-1, 1] == '/' ? url : File.dirname(url)
    end

    def name
      basename
    end

    def dir
      relative_directory
    end

    # The full path and filename of the post. Defined in the YAML of the post
    # body.
    #
    # Returns the String permalink or nil if none has been set.
    def permalink
      return nil if data.nil? || data['permalink'].nil?
      if site.config['relative_permalinks']
        File.join(dir, data['permalink'])
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
        :template     => template,
        :placeholders => url_placeholders,
        :permalink    => permalink
      }).to_s
    end

    # Returns a hash of URL placeholder names (as symbols) mapping to the
    # desired placeholder replacements. For details see "url.rb"
    def url_placeholders
      {
        :path       => relative_directory,
        :basename   => basename('.*'),
        :output_ext => output_ext
      }
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

    # Obtain destination path.
    #
    # dest - The String path to the destination dir.
    #
    # Returns the destination file path String.
    def destination(dest)
      path = Jekyll.sanitized_path(dest, URL.unescape_path(url))
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
      basename('.*') == 'index'
    end

    def uses_relative_permalinks
      permalink && !dir.empty? && site.config['relative_permalinks']
    end
  end
end
