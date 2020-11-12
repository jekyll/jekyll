# frozen_string_literal: true

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
          result.gsub("/:#{token.first}", "")
        else
          result.gsub(":#{token.first}", self.class.escape_path(token.last))
        end
      end
    end

    # We include underscores in keys to allow for 'i_month' and so forth.
    # This poses a problem for keys which are followed by an underscore
    # but the underscore is not part of the key, e.g. '/:month_:day'.
    # That should be :month and :day, but our key extraction regexp isn't
    # smart enough to know that so we have to make it an explicit
    # possibility.
    def possible_keys(key)
      if key.end_with?("_")
        [key, key.chomp("_")]
      else
        [key]
      end
    end

    def generate_url_from_drop(template)
      template.gsub(%r!:([a-z_]+)!) do |match|
        name = Regexp.last_match(1)
        pool = name.end_with?("_") ? [name, name.chomp!("_")] : [name]

        winner = pool.find { |key| @placeholders.key?(key) }
        if winner.nil?
          raise NoMethodError,
                "The URL template doesn't have #{pool.join(" or ")} keys. "\
                "Check your permalink template!"
        end

        value = @placeholders[winner]
        value = "" if value.nil?
        replacement = self.class.escape_path(value)

        match.sub!(":#{winner}", replacement)
      end
    end

    # Returns a sanitized String URL, stripping "../../" and multiples of "/",
    # as well as the beginning "/" so we can enforce and ensure it.
    def sanitize_url(str)
      "/#{str}".gsub("..", "/").tap do |result|
        result.gsub!("./", "")
        result.squeeze!("/")
      end
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
      return path if path.empty? || %r!^[a-zA-Z0-9./-]+$!.match?(path)

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
      Addressable::URI.encode(path).encode("utf-8").sub("#", "%23")
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
      path = path.encode("utf-8")
      return path unless path.include?("%")

      Addressable::URI.unencode(path)
    end
  end
end
