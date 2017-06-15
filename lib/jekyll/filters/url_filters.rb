require "addressable/uri"

module Jekyll
  module Filters
    module URLFilters
      # Produces an absolute URL based on site.url and site.baseurl.
      #
      # input - the URL to make absolute.
      #
      # Returns the absolute URL as a String.
      def absolute_url(input)
        return if input.nil?
        return input if Addressable::URI.parse(input).absolute?
        return relative_url(input).to_s if site.config["url"].nil?
        Addressable::URI.parse(site.config["url"] + relative_url(input)).normalize.to_s
      end

      # Produces a URL relative to the domain root based on site.baseurl.
      #
      # input - the URL to make relative to the domain root
      #
      # Returns a URL relative to the domain root as a String.
      def relative_url(input)
        return if input.nil?
        return ensure_leading_slash(input.to_s) if sanitized_baseurl.nil?
        Addressable::URI.parse(
          ensure_leading_slash(sanitized_baseurl) + ensure_leading_slash(input.to_s)
        ).normalize.to_s
      end

      # Strips trailing `/index.html` from URLs to create pretty permalinks
      #
      # input - the URL with a possible `/index.html`
      #
      # Returns a URL with the trailing `/index.html` removed
      def strip_index(input)
        return if input.nil? || input.to_s.empty?
        input.sub(%r!/index\.html?$!, "/")
      end

      private

      def site
        @context.registers[:site]
      end

      def sanitized_baseurl
        site.config["baseurl"].to_s.chomp("/")
      end

      def ensure_leading_slash(input)
        return input if input.nil? || input.empty? || input.start_with?("/")
        "/#{input}"
      end

    end
  end
end
