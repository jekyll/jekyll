# frozen_string_literal: true

module Jekyll
  module Converters
    # Markdown converter.
    # For more info on converters see https://jekyllrb.com/docs/plugins/converters/
    class Markdown < Converter
      highlighter_prefix "\n"
      highlighter_suffix "\n"
      safe true

      def setup
        return if @setup ||= false

        unless (@parser = get_processor)
          if @config["safe"]
            Jekyll.logger.warn "Build Warning:", "Custom processors are not loaded in safe mode"
          end

          Jekyll.logger.error "Markdown processor:",
                              "#{@config["markdown"].inspect} is not a valid Markdown processor."
          Jekyll.logger.error "", "Available processors are: #{valid_processors.join(", ")}"
          Jekyll.logger.error ""
          raise Errors::FatalException, "Invalid Markdown processor given: #{@config["markdown"]}"
        end

        @cache = Jekyll::Cache.new("Jekyll::Converters::Markdown")
        @setup = true
      end

      # RuboCop does not allow reader methods to have names starting with `get_`
      # To ensure compatibility, this check has been disabled on this method
      #
      # rubocop:disable Naming/AccessorMethodName
      def get_processor
        case @config["markdown"].downcase
        when "kramdown" then KramdownParser.new(@config)
        else
          custom_processor
        end
      end
      # rubocop:enable Naming/AccessorMethodName

      # Public: Provides you with a list of processors comprised of the ones we support internally
      # and the ones that you have provided to us (if they're whitelisted for use in safe mode).
      #
      # Returns an array of symbols.
      def valid_processors
        [:kramdown] + third_party_processors
      end

      # Public: A list of processors that you provide via plugins.
      #
      # Returns an array of symbols
      def third_party_processors
        self.class.constants - [:KramdownParser, :PRIORITIES]
      end

      # Does the given extension match this converter's list of acceptable extensions?
      # Takes one argument: the file's extension (including the dot).
      #
      # ext - The String extension to check.
      #
      # Returns true if it matches, false otherwise.
      def matches(ext)
        extname_list.include?(ext.downcase)
      end

      # Public: The extension to be given to the output file (including the dot).
      #
      # ext - The String extension or original file.
      #
      # Returns The String output file extension.
      def output_ext(_ext)
        ".html"
      end

      # Logic to do the content conversion.
      #
      # content - String content of file (without front matter).
      #
      # Returns a String of the converted content.
      def convert(content)
        setup
        @cache.getset(content) do
          @parser.convert(content)
        end
      end

      def extname_list
        @extname_list ||= @config["markdown_ext"].split(",").map! { |e| ".#{e.downcase}" }
      end

      private

      def custom_processor
        converter_name = @config["markdown"]
        self.class.const_get(converter_name).new(@config) if custom_class_allowed?(converter_name)
      end

      # Private: Determine whether a class name is an allowed custom
      #   markdown class name.
      #
      # parser_name - the name of the parser class
      #
      # Returns true if the parser name contains only alphanumeric characters and is defined
      # within Jekyll::Converters::Markdown
      def custom_class_allowed?(parser_name)
        parser_name !~ %r![^A-Za-z0-9_]! && self.class.constants.include?(parser_name.to_sym)
      end
    end
  end
end
