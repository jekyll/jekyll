# encoding: UTF-8

module Jekyll
  class Page < Document
    # A set of extensions that are considered HTML or HTML-like so we
    # should not alter them,  this includes .xhtml through XHTM5.
    HTML_EXTENSIONS = %w(
      .html
      .xhtml
      .htm
    ).freeze

    FORWARD_SLASH = '/'.freeze

    # Post-read step: don't try to force title for pages
    def post_read
      title = data['title']
      super
      data['title'] = title
    end

    # The template of the permalink.
    #
    # Returns the template String.
    def url_template
      if !html?
        "/:dir/:basename:output_ext"
      elsif index?
        "/:dir/"
      else
        Utils.add_permalink_suffix("/:dir/:basename", site.permalink_style)
      end
    end

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

    def file_dir
      file_dir = File.dirname(relative_path)
      file_dir.end_with?(FORWARD_SLASH) ? file_dir : "#{file_dir}/"
    end

    # Returns the Boolean of whether this Page is HTML or not.
    def html?
      HTML_EXTENSIONS.include?(output_ext)
    end

    # Returns the Boolean of whether this Page is an index file or not.
    def index?
      basename == 'index'
    end

    # Don't generate excerpts for pages
    def generate_excerpt?
      false
    end

    # Alias methods to maintain compatibility
    alias_method :name, :basename
    alias_method :basename, :basename_without_ext
    alias_method :ext, :output_ext
  end
end
