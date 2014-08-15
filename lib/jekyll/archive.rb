module Jekyll
  class Archive
    include Convertible

    attr_accessor :posts, :type, :name
    attr_accessor :data, :content, :output
    attr_accessor :path, :ext
    attr_accessor :site

    # Attributes for Liquid templates
    ATTRIBUTES_FOR_LIQUID = %w[
      posts
      type
      name
    ]

    # Initialize a new Archive page
    #
    # site  - The Site object.
    # posts - The array of posts that belong in this archive.
    # type  - The type of archive. Can be one of "year", "category", or "tag"
    # name  - The name of the archive (e.g. "2014" or "my-category" or "my-tag").
    def initialize(site, posts, type, name)
      @site  = site
      @posts = posts
      @type  = type
      @name  = name

      # Use ".html" for file extension and url for path
      @ext  = ".html"
      @path = url

      @data = {
        "layout" => site.config['archive_layout']
      }
      @content = ""
    end

    # The template of the permalink.
    #
    # Returns the template String.
    def template
      case type
      when "year"
        "/archive/:name/"
      else
        "/:type/:name/"
      end
    end

    # Returns a hash of URL placeholder names (as symbols) mapping to the
    # desired placeholder replacements. For details see "url.rb".
    def url_placeholders
      { :name => @name, :type => @type.to_s }
    end

    # The generated relative url of this page. e.g. /about.html.
    #
    # Returns the String url.
    def url
      @url ||= URL.new({
        :template => template,
        :placeholders => url_placeholders,
        :permalink => nil
      }).to_s
    end

    # Add any necessary layouts to this post
    #
    # layouts      - The Hash of {"name" => "layout"}.
    # site_payload - The site payload Hash.
    #
    # Returns nothing.
    def render(layouts, site_payload)
      payload = Utils.deep_merge_hashes({
        "page" => to_liquid
      }, site_payload)

      do_layout(payload, layouts)
    end

    # Convert this Convertible's data to a Hash suitable for use by Liquid.
    #
    # Returns the Hash representation of this Convertible.
    def to_liquid(attrs = nil)
      further_data = Hash[(attrs || self.class::ATTRIBUTES_FOR_LIQUID).map { |attribute|
        [attribute, send(attribute)]
      }]

      Utils.deep_merge_hashes(data, further_data)
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
      "#<Jekyll:Archive @type=#{@type.to_s} @name=#{@name}>"
    end

    # Returns the Boolean of whether this Page is HTML or not.
    def html?
      true
    end
  end
end
