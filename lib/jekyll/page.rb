# frozen_string_literal: true

module Jekyll
  class Page < PrimalPage
    # A set of extensions that are considered HTML or HTML-like so we
    # should not alter them,  this includes .xhtml through XHTM5.
    HTML_EXTENSIONS = %w(
      .html
      .xhtml
      .htm
    ).freeze

    # The generated directory into which the page will be placed
    # upon generation. This is derived from the permalink or, if
    # permalink is absent, will be '/'
    #
    # Returns the String destination directory.
    def dir
      return url if url.end_with?("/")
      url_dir = File.dirname(url)
      url_dir.end_with?("/") ? url_dir : "#{url_dir}/"
    end

    # The full path and filename of the post. Defined in the YAML of the post
    # body.
    #
    # Returns the String permalink or nil if none has been set.
    def permalink
      data["permalink"]
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
    alias_method :template, :url_template

    # The generated relative url of this page. e.g. /about.html.
    #
    # Returns the String url.
    def url
      @url ||= URL.new(
        :template     => url_template,
        :placeholders => url_placeholders,
        :permalink    => permalink
      ).to_s
    end

    # Returns a hash of URL placeholder names (as symbols) mapping to the
    # desired placeholder replacements. For details see "url.rb"
    def url_placeholders
      {
        :path       => @dir,
        :basename   => basename_without_ext,
        :output_ext => output_ext,
      }
    end

    # Add any necessary layouts to this post
    #
    # layouts      - The Hash of {"name" => "layout"}.
    # site_payload - The site payload Hash.
    #
    # Returns String rendered page.
    def render(layouts, site_payload)
      site_payload["page"] = to_liquid
      do_layout(site_payload, layouts)
    end

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
      basename_without_ext == "index"
    end

    def write?
      true
    end

    def type
      :pages
    end

    private

    def hook_owner
      :pages
    end
  end
end
