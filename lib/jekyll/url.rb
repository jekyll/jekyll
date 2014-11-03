require 'uri'

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
      @template     = options[:template]
      @placeholders = options[:placeholders] || {}
      @permalink    = options[:permalink]

      if (@template || @permalink).nil?
        raise ArgumentError, "One of :template or :permalink must be supplied."
      end
    end

    # The generated relative URL of the resource
    #
    # Returns the String URL
    def to_s
      sanitize_url(generated_permalink || generated_url)
    end

    # Generates a URL from the permalink
    #
    # Returns the _unsanitized String URL
    def generated_permalink
      (@generated_permlink ||= generate_url(@permalink)) if @permalink
    end

    # Generates a URL from the template
    #
    # Returns the _unsanitized String URL
    def generated_url
      @generated_url ||= generate_url(@template)
    end

    # Internal: Generate the URL by replacing all placeholders with their
    # respective values in the given template
    #
    # Returns the _unsanitizied_ String URL
    def generate_url(template)
      @placeholders.inject(template) do |result, token|
        break result if result.index(':').nil?
        result.gsub(/:#{token.first}/, self.class.escape_path(token.last))
      end
    end

    # Returns a sanitized String URL
    def sanitize_url(in_url)
      url = in_url \
        # Remove all double slashes
        .gsub(/\/\//, '/') \
        # Remove every URL segment that consists solely of dots
        .split('/').reject{ |part| part =~ /^\.+$/ }.join('/') \
        # Always add a leading slash
        .gsub(/\A([^\/])/, '/\1')

      # Append a trailing slash to the URL if the unsanitized URL had one
      url << "/" if in_url[-1].eql?('/')

      url
    end

    # Escapes a path to be a valid URL path segment
    #
    # path - The path to be escaped.
    #
    # Examples:
    #
    #   URL.escape_path("/a b")
    #   # => "/a%20b"
    #
    # Returns the escaped path.
    def self.escape_path(path)
      # Because URI.escape doesn't escape '?', '[' and ']' by default,
      # specify unsafe string (except unreserved, sub-delims, ":", "@" and "/").
      #
      # URI path segment is defined in RFC 3986 as follows:
      #   segment       = *pchar
      #   pchar         = unreserved / pct-encoded / sub-delims / ":" / "@"
      #   unreserved    = ALPHA / DIGIT / "-" / "." / "_" / "~"
      #   pct-encoded   = "%" HEXDIG HEXDIG
      #   sub-delims    = "!" / "$" / "&" / "'" / "(" / ")"
      #                 / "*" / "+" / "," / ";" / "="
      URI.escape(path, /[^a-zA-Z\d\-._~!$&\'()*+,;=:@\/]/).encode('utf-8')
    end

    # Unescapes a URL path segment
    #
    # path - The path to be unescaped.
    #
    # Examples:
    #
    #   URL.unescape_path("/a%20b")
    #   # => "/a b"
    #
    # Returns the unescaped path.
    def self.unescape_path(path)
      URI.unescape(path.encode('utf-8'))
    end
  end
end
