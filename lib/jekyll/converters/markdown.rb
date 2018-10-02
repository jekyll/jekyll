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
          Jekyll.logger.error "Invalid Markdown processor given:", @config["markdown"]
          Jekyll.logger.info "", "Custom processors are not loaded in safe mode" if @config["safe"]
          Jekyll.logger.error(
            "",
            "Available processors are: #{valid_processors.join(", ")}"
          )
          raise Errors::FatalException, "Bailing out; invalid Markdown processor."
        end

        @cache = Jekyll::Cache.new("Jekyll::Converters::Markdown")

        @setup = true
      end

      # Rubocop does not allow reader methods to have names starting with `get_`
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

      # Public: Provides you with a list of processors, the ones we
      # support internally and the ones that you have provided to us (if you
      # are not in safe mode.)

      def valid_processors
        %w(kramdown) + third_party_processors
      end

      # Public: A list of processors that you provide via plugins.
      # This is really only available if you are not in safe mode, if you are
      # in safe mode (re: GitHub) then there will be none.

      def third_party_processors
        self.class.constants - \
          %w(KramdownParser PRIORITIES).map(
            &:to_sym
          )
      end

      def extname_list
        @extname_list ||= @config["markdown_ext"].split(",").map do |e|
          ".#{e.downcase}"
        end
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
      # Returns true if the parser name contains only alphanumeric
      # characters and is defined within Jekyll::Converters::Markdown
      def custom_class_allowed?(parser_name)
        parser_name !~ %r![^A-Za-z0-9_]! && self.class.constants.include?(
          parser_name.to_sym
        )
      end
    end
  end
end
