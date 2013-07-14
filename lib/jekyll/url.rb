# The URL module provides methods that generate a URL for a resource in which they're
# included, such as a Post or a Page.
#
# Requires
#
#   self.permalink  - If a permalink is set in the included instance, that permalink
#                     will be returned instead of any URL that might've been generated
#
#   self.url_placeholders - Placeholders that may be used in the URL, which will be replaced
#                         with the values when the URL is generated. Must return a Hash
#                         mapping placeholder names to their values. For example, if this
#                         method returned
#
#                           { "year" => Time.now.strftime("%Y") }
#
#                         Every occurrence of ":year" (note the colon) would be replaced with
#                         the current year.
#
#

module Jekyll
  module URL

    # The generated relative url of this page. e.g. /about.html.
    #
    # Returns the String url.
    def url
      @url ||= sanitize_url(permalink || generate_url)
    end

    # Generate the URL by replacing all placeholders with their respective values
    #
    # Returns the _unsanitizied_ String URL
    def generate_url
      url_placeholders.inject(template) { |result, token|
        result.gsub(/:#{token.first}/, token.last)
      }
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
