require "uri"

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
    # Raises a Jekyll::Errors::InvalidURLError if the relative URL contains a colon
    def to_s
      sanitized_url = sanitize_url(generated_permalink || generated_url)
      if sanitized_url.include?(":")
        raise Jekyll::Errors::InvalidURLError,
          "The URL #{sanitized_url} is invalid because it contains a colon."
      else
        sanitized_url
      end
    end

    # Generates a URL from the permalink
    #
    # Returns the _unsanitized String URL
    def generated_permalink
      (@generated_permalink ||= generate_url(@permalink)) if @permalink
    end

    # Generates a URL from the template
    #
    # Returns the unsanitized String URL
    def generated_url
      @generated_url ||= generate_url(@template)
    end

    # Internal: Generate the URL by replacing all placeholders with their
    # respective values in the given template
    #
    # Returns the unsanitized String URL
    def generate_url(template)
      if @placeholders.is_a? Drops::UrlDrop
        generate_url_from_drop(template)
      else
        generate_url_from_hash(template)
      end
    end

    def generate_url_from_hash(template)
      @placeholders.inject(template) do |result, token|
        break result if result.index(":").nil?
        if token.last.nil?
          # Remove leading "/" to avoid generating urls with `//`
          result.gsub(%r!/:#{token.first}!, "")
        else
          result.gsub(%r!:#{token.first}!, self.class.escape_path(token.last))
        end
      end
    end

    def generate_url_from_drop(template)
      template.gsub(%r!:([a-z_]+)!) do |match|
        replacement = @placeholders.public_send(match.sub(":".freeze, "".freeze))
        if replacement.nil?
          "".freeze
        else
          self.class.escape_path(replacement)
        end
      end.gsub(%r!//!, "/".freeze)
    end

    # Returns a sanitized String URL, stripping "../../" and multiples of "/",
    # as well as the beginning "/" so we can enforce and ensure it.

    def sanitize_url(str)
      "/" + str.gsub(%r!/{2,}!, "/").gsub(%r!\.+/|\A/+!, "")
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
      # Because URI.escape doesn't escape "?", "[" and "]" by default,
      # specify unsafe string (except unreserved, sub-delims, ":", "@" and "/").
      #
      # URI path segment is defined in RFC 3986 as follows:
      #   segment       = *pchar
      #   pchar         = unreserved / pct-encoded / sub-delims / ":" / "@"
      #   unreserved    = ALPHA / DIGIT / "-" / "." / "_" / "~"
      #   pct-encoded   = "%" HEXDIG HEXDIG
      #   sub-delims    = "!" / "$" / "&" / "'" / "(" / ")"
      #                 / "*" / "+" / "," / ";" / "="
      URI.escape(path, %r{[^a-zA-Z\d\-._~!$&'()*+,;=:@\/]}).encode("utf-8")
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
      URI.unescape(path.encode("utf-8"))
    end
  end
end
