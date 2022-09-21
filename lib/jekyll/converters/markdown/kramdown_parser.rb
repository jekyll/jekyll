# frozen_string_literal: true

module Kramdown
  # A Kramdown::Document subclass meant to optimize memory usage from initializing
  # a kramdown document for parsing.
  #
  # The optimization is by using the same options Hash (and its derivatives) for
  # converting all Markdown documents in a Jekyll site.
  class JekyllDocument < Document
    class << self
      attr_reader :options, :parser

      # The implementation is basically the core logic in +Kramdown::Document#initialize+
      #
      # rubocop:disable Naming/MemoizedInstanceVariableName
      def setup(options)
        @cache ||= {}

        # reset variables on a subsequent set up with a different options Hash
        unless @cache[:id] == options.hash
          @options = @parser = nil
          @cache[:id] = options.hash
        end

        @options ||= Options.merge(options).freeze
        @parser  ||= begin
          parser_name = (@options[:input] || "kramdown").to_s
          parser_name = parser_name[0..0].upcase + parser_name[1..-1]
          try_require("parser", parser_name)

          if Parser.const_defined?(parser_name)
            Parser.const_get(parser_name)
          else
            raise Kramdown::Error, "kramdown has no parser to handle the specified " \
                                   "input format: #{@options[:input]}"
          end
        end
      end
      # rubocop:enable Naming/MemoizedInstanceVariableName

      private

      def try_require(type, name)
        require "kramdown/#{type}/#{Utils.snake_case(name)}"
      rescue LoadError
        false
      end
    end

    def initialize(source, options = {})
      JekyllDocument.setup(options)

      @options = JekyllDocument.options
      @root, @warnings = JekyllDocument.parser.parse(source, @options)
    end

    # Use Kramdown::Converter::Html class to convert this document into HTML.
    #
    # The implementation is basically an optimized version of core logic in
    # +Kramdown::Document#method_missing+ from kramdown-2.1.0.
    def to_html
      output, warnings = Kramdown::Converter::Html.convert(@root, @options)
      @warnings.concat(warnings)
      output
    end
  end
end

#

module Jekyll
  module Converters
    class Markdown
      class KramdownParser
        CODERAY_DEFAULTS = {
          "css"               => "style",
          "bold_every"        => 10,
          "line_numbers"      => "inline",
          "line_number_start" => 1,
          "tab_width"         => 4,
          "wrap"              => "div",
        }.freeze

        def initialize(config)
          @main_fallback_highlighter = config["highlighter"] || "rouge"
          @config = config["kramdown"] || {}
          @highlighter = nil
          setup
          load_dependencies
        end

        # Setup and normalize the configuration:
        #   * Create Kramdown if it doesn't exist.
        #   * Set syntax_highlighter, detecting enable_coderay and merging
        #       highlighter if none.
        #   * Merge kramdown[coderay] into syntax_highlighter_opts stripping coderay_.
        #   * Make sure `syntax_highlighter_opts` exists.

        def setup
          @config["syntax_highlighter"] ||= highlighter
          @config["syntax_highlighter_opts"] ||= {}
          @config["syntax_highlighter_opts"]["default_lang"] ||= "plaintext"
          @config["syntax_highlighter_opts"]["guess_lang"] = @config["guess_lang"]
          @config["coderay"] ||= {} # XXX: Legacy.
          modernize_coderay_config
        end

        def convert(content)
          document = Kramdown::JekyllDocument.new(content, @config)
          html_output = document.to_html
          if @config["show_warnings"]
            document.warnings.each do |warning|
              Jekyll.logger.warn "Kramdown warning:", warning
            end
          end
          html_output
        end

        private

        def load_dependencies
          require "kramdown-parser-gfm" if @config["input"] == "GFM"

          if highlighter == "coderay"
            Jekyll::External.require_with_graceful_fail("kramdown-syntax-coderay")
          end

          # `mathjax` engine is bundled within kramdown-2.x and will be handled by
          # kramdown itself.
          if (math_engine = @config["math_engine"]) && math_engine != "mathjax"
            Jekyll::External.require_with_graceful_fail("kramdown-math-#{math_engine}")
          end
        end

        # config[kramdown][syntax_highlighter] >
        #   config[kramdown][enable_coderay] >
        #   config[highlighter]
        # Where `enable_coderay` is now deprecated because Kramdown
        # supports Rouge now too.
        def highlighter
          return @highlighter if @highlighter

          if @config["syntax_highlighter"]
            return @highlighter = @config[
              "syntax_highlighter"
            ]
          end

          @highlighter = if @config.key?("enable_coderay") && @config["enable_coderay"]
                           Jekyll::Deprecator.deprecation_message(
                             "You are using 'enable_coderay', " \
                             "use syntax_highlighter: coderay in your configuration file."
                           )

                           "coderay"
                         else
                           @main_fallback_highlighter
                         end
        end

        def strip_coderay_prefix(hash)
          hash.each_with_object({}) do |(key, val), hsh|
            cleaned_key = key.to_s.delete_prefix("coderay_")

            if key != cleaned_key
              Jekyll::Deprecator.deprecation_message(
                "You are using '#{key}'. Normalizing to #{cleaned_key}."
              )
            end

            hsh[cleaned_key] = val
          end
        end

        # If our highlighter is CodeRay we go in to merge the CodeRay defaults
        # with your "coderay" key if it's there, deprecating it in the
        # process of you using it.
        def modernize_coderay_config
          unless @config["coderay"].empty?
            Jekyll::Deprecator.deprecation_message(
              "You are using 'kramdown.coderay' in your configuration, " \
              "please use 'syntax_highlighter_opts' instead."
            )

            @config["syntax_highlighter_opts"] = begin
              strip_coderay_prefix(
                @config["syntax_highlighter_opts"] \
                  .merge(CODERAY_DEFAULTS) \
                  .merge(@config["coderay"])
              )
            end
          end
        end
      end
    end
  end
end
