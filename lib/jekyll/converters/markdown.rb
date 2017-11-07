# frozen_string_literal: true

module Jekyll
  module Converters
    class Markdown < Converter
      highlighter_prefix "\n"
      highlighter_suffix "\n"
      safe true

      def setup
        return if @setup ||= false
        unless (@parser = get_processor)
          Jekyll.logger.error "Invalid Markdown processor given:", @config["markdown"]
          if @config["safe"]
            Jekyll.logger.info "", "Custom processors are not loaded in safe mode"
          end
          Jekyll.logger.error(
            "",
            "Available processors are: #{valid_processors.join(", ")}"
          )
          raise Errors::FatalException, "Bailing out; invalid Markdown processor."
        end

        @setup = true
      end

      # Rubocop does not allow reader methods to have names starting with `get_`
      # To ensure compatibility, this check has been disabled on this method
      #
      # rubocop:disable Naming/AccessorMethodName
      def get_processor
        case @config["markdown"].downcase
        when "redcarpet" then return RedcarpetParser.new(@config)
        when "kramdown"  then return KramdownParser.new(@config)
        when "rdiscount" then return RDiscountParser.new(@config)
        else
          custom_processor
        end
      end
      # rubocop:enable Naming/AccessorMethodName

      # Public: Provides you with a list of processors, the ones we
      # support internally and the ones that you have provided to us (if you
      # are not in safe mode.)

      def valid_processors
        %w(rdiscount kramdown redcarpet) + third_party_processors
      end

      # Public: A list of processors that you provide via plugins.
      # This is really only available if you are not in safe mode, if you are
      # in safe mode (re: GitHub) then there will be none.

      def third_party_processors
        self.class.constants - \
          %w(KramdownParser RDiscountParser RedcarpetParser PRIORITIES).map(
            &:to_sym
          )
      end

      def extname_list
        @extname_list ||= @config["markdown_ext"].split(",").map do |e|
          ".#{e.downcase}"
        end
      end

      def matches(ext)
        extname_list.include?(ext.downcase)
      end

      def output_ext(_ext)
        ".html"
      end

      def convert(content)
        setup
        @parser.convert(content)
      end

      private
      def custom_processor
        converter_name = @config["markdown"]
        if custom_class_allowed?(converter_name)
          self.class.const_get(converter_name).new(@config)
        end
      end

      # Private: Determine whether a class name is an allowed custom
      #   markdown class name.
      #
      # parser_name - the name of the parser class
      #
      # Returns true if the parser name contains only alphanumeric
      # characters and is defined within Jekyll::Converters::Markdown

      private
      def custom_class_allowed?(parser_name)
        parser_name !~ %r![^A-Za-z0-9_]! && self.class.constants.include?(
          parser_name.to_sym
        )
      end
    end
  end
end
