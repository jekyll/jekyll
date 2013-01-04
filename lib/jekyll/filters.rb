require 'uri'

module Jekyll

  module Filters
    # Convert a Textile string into HTML output.
    #
    # input - The Textile String to convert.
    #
    # Returns the HTML formatted String.
    def textilize(input)
      site = @context.registers[:site]
      converter = site.getConverterImpl(Jekyll::TextileConverter)
      converter.convert(input)
    end

    # Convert a Markdown string into HTML output.
    #
    # input - The Markdown String to convert.
    #
    # Returns the HTML formatted String.
    def markdownify(input)
      site = @context.registers[:site]
      converter = site.getConverterImpl(Jekyll::MarkdownConverter)
      converter.convert(input)
    end

    # Format a date in short format e.g. "27 Jan 2011".
    #
    # date - the Time to format.
    #
    # Returns the formatting String.
    def date_to_string(date)
      date.strftime("%d %b %Y")
    end

    # Format a date in long format e.g. "27 January 2011".
    #
    # date - The Time to format.
    #
    # Returns the formatted String.
    def date_to_long_string(date)
      date.strftime("%d %B %Y")
    end

    # Format a date for use in XML.
    #
    # date - The Time to format.
    #
    # Examples
    #
    #   date_to_xmlschema(Time.now)
    #   # => "2011-04-24T20:34:46+08:00"
    #
    # Returns the formatted String.
    def date_to_xmlschema(date)
      date.xmlschema
    end

    # XML escape a string for use. Replaces any special characters with
    # appropriate HTML entity replacements.
    #
    # input - The String to escape.
    #
    # Examples
    #
    #   xml_escape('foo "bar" <baz>')
    #   # => "foo &quot;bar&quot; &lt;baz&gt;"
    #
    # Returns the escaped String.
    def xml_escape(input)
      CGI.escapeHTML(input)
    end

    # CGI escape a string for use in a URL. Replaces any special characters
    # with appropriate %XX replacements.
    #
    # input - The String to escape.
    #
    # Examples
    #
    #   cgi_escape('foo,bar;baz?')
    #   # => "foo%2Cbar%3Bbaz%3F"
    #
    # Returns the escaped String.
    def cgi_escape(input)
      CGI::escape(input)
    end

    def uri_escape(input)
      URI.escape(input)
    end

    # Count the number of words in the input string.
    #
    # input - The String on which to operate.
    #
    # Returns the Integer word count.
    def number_of_words(input)
      input.split.length
    end

    # Join an array of things into a string by separating with commes and the
    # word "and" for the last one.
    #
    # array - The Array of Strings to join.
    #
    # Examples
    #
    #   array_to_sentence_string(["apples", "oranges", "grapes"])
    #   # => "apples, oranges, and grapes"
    #
    # Returns the formatted String.
    def array_to_sentence_string(array)
      connector = "and"
      case array.length
      when 0
        ""
      when 1
        array[0].to_s
      when 2
        "#{array[0]} #{connector} #{array[1]}"
      else
        "#{array[0...-1].join(', ')}, #{connector} #{array[-1]}"
      end
    end

  end
end
