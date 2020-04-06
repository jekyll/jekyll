# Frozen-string-literal: true

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
          make_accessible
        end

        def convert(content)
          document = Kramdown::Document.new(content, @config)
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
          return if Kramdown::VERSION.to_i < 2
          if @config["input"] == "GFM"
            Jekyll::External.require_with_graceful_fail("kramdown-parser-gfm")
          end

          if highlighter == "coderay"
            Jekyll::External.require_with_graceful_fail("kramdown-syntax-coderay")
          end

          # `mathjax` emgine is bundled within kramdown-2.x and will be handled by
          # kramdown itself.
          if (math_engine = @config["math_engine"]) && math_engine != "mathjax"
            Jekyll::External.require_with_graceful_fail("kramdown-math-#{math_engine}")
          end
        end

        def make_accessible(hash = @config)
          hash.keys.each do |key|
            hash[key.to_sym] = hash[key]
            make_accessible(hash[key]) if hash[key].is_a?(Hash)
          end
        end

        # config[kramdown][syntax_higlighter] >
        #   config[kramdown][enable_coderay] >
        #   config[highlighter]
        # Where `enable_coderay` is now deprecated because Kramdown
        # supports Rouge now too.

        private
        def highlighter
          return @highlighter if @highlighter

          if @config["syntax_highlighter"]
            return @highlighter = @config[
              "syntax_highlighter"
            ]
          end

          @highlighter = begin
            if @config.key?("enable_coderay") && @config["enable_coderay"]
              Jekyll::Deprecator.deprecation_message(
                "You are using 'enable_coderay', " \
                "use syntax_highlighter: coderay in your configuration file."
              )

              "coderay"
            else
              @main_fallback_highlighter
            end
          end
        end

        private
        def strip_coderay_prefix(hash)
          hash.each_with_object({}) do |(key, val), hsh|
            cleaned_key = key.to_s.gsub(%r!\Acoderay_!, "")

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

        private
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
