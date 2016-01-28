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

    # The template of the permalink.
    #
    # Returns the template String.
    def url_template
      # if !html?
      #   "/:path/:basename:output_ext"
      # elsif index?
      #   "/:path/"
      # else
      #   Utils.add_permalink_suffix("/:path/:basename", site.permalink_style)
      # end
      super
    end

    # Returns the Boolean of whether this Page is HTML or not.
    def html?
      HTML_EXTENSIONS.include?(output_ext)
    end

    # Returns the Boolean of whether this Page is an index file or not.
    def index?
      basename_without_ext == 'index'
    end
  end
end
