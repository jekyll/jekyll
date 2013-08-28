# Public: Methods that generate a URL for a resource such as a Post or a Page.
#
# Examples
#
#   URL.new({
#     :template => /:categories/:title.html",
#     :placeholders => {:categories => "ruby", :title => "something"}
#   }).to_s
#
module Jekyll
  class URL

    # options - One of :permalink or :template must be supplied.
    #           :template     - The String used as template for URL generation,
    #                           for example "/:path/:basename:output_ext", where
    #                           a placeholder is prefixed with a colon.
    #           :placeholders - A hash containing the placeholders which will be
    #                           replaced when used inside the template. E.g.
    #                           { "year" => Time.now.strftime("%Y") } would replace
    #                           the placeholder ":year" with the current year.
    #           :permalink    - If supplied, no URL will be generated from the
    #                           template. Instead, the given permalink will be
    #                           used as URL.
    def initialize(options)
      @template = options[:template]
      @placeholders = options[:placeholders] || {}
      @permalink = options[:permalink]

      if (@template || @permalink).nil?
        raise ArgumentError, "One of :template or :permalink must be supplied."
      end
    end

    # The generated relative URL of the resource
    #
    # Returns the String URL
    def to_s
      sanitize_url(@permalink || generate_url)
    end

    # Internal: Generate the URL by replacing all placeholders with their
    # respective values
    #
    # Returns the _unsanitizied_ String URL
    def generate_url
      @placeholders.inject(@template) do |result, token|
        result.gsub(/:#{token.first}/, token.last)
      end
    end

    # Returns a sanitized String URL
    def sanitize_url(in_url)
      # Remove all double slashes
      url = in_url.gsub(/\/\//, "/")

      # Remove every URL segment that consists solely of dots
      url = url.split('/').reject{ |part| part =~ /^\.+$/ }.join('/')

      # Append a trailing slash to the URL if the unsanitized URL had one
      url += "/" if in_url =~ /\/$/

      # Always add a leading slash
      url.gsub!(/\A([^\/])/, '/\1')
      url
    end
  end
end
