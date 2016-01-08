# Frozen-string-literal: true
# Encoding: utf-8

module Jekyll
  module Converters
    class Markdown
      class KramdownParser
        attr_accessor :config
        CODERAY_DEFAULTS = {
          "css" => "style",
          "bold_every" => 10,
          "line_numbers" => "inline",
          "line_number_start" => 1,
          "wrap" => "div",
          "tab_width" => 4
        }

        def initialize(config)
          Jekyll::External.require_with_graceful_fail "kramdown"
          @main_fallback_highlighter = config["highlighter"] || "rogue"
          @config = Marshal.load(Marshal.dump(config["kramdown"] || {}))
          setup
        end

        # Setup and normalize the configuration:
        #   * Create Kramdown if it doesn't exist.
        #   * Set syntax_highlighter, detecting enable_coderay and merging highlighter if none.
        #   * Merge kramdown[coderay] into syntax_highlighter_opts stripping coderay_.
        #   * Make sure `syntax_highlighter_opts` exists.

        def setup
          @config["syntax_highlighter"] ||= highlighter
          @config["syntax_highlighter_opts"] ||= {}
          @config["coderay"] ||= {} # XXX: Legacy.
          @coderay = @config.delete("coderay")
          modernize_coderay_config
        end

        #

        def convert(content)
          Kramdown::Document.new(content, @config.dup).to_html
        end

        # config[kramdown][syntax_higlighter] > config[kramdown][enable_coderay] > config[highlighter]
        # Where `enable_coderay` is now deprecated because Kramdown
        # supports Rouge now too.

        private
        def highlighter
          @highlighter ||= begin
            highlighter = @config["syntax_highlighter"]
            return highlighter if highlighter

            if @config.key?("enable_coderay") && @config["enable_coderay"]
              Jekyll::Deprecator.deprecation_message "You are using 'enable_coderay', use "\
                "syntax_highlighter: coderay in your configuration file."
              return "coderay"
            end

            @main_fallback_highlighter
          end
        end

        #

        private
        def strip_coderay_prefix(hash)
          hash.each_with_object({}) do |(key, val), hsh|
            cleaned_key = key.gsub(/\Acoderay_/, "")
            Jekyll::Deprecator.deprecation_message "Kramdown: You are using '#{key}'. " \
              "Normalizing to #{cleaned_key}." if key != cleaned_key
            hsh[cleaned_key] = val
          end
        end

        # If our highlighter is CodeRay we go in to merge the CodeRay defaults
        # with your "coderay" key if it's there, deprecating it in the
        # process of you using it.

        private
        def modernize_coderay_config
          if highlighter == "coderay"
            send_deprecation_message_if_using_old_opts
            @config["syntax_highlighter_opts"] = \
              begin
                strip_coderay_prefix(
                  CODERAY_DEFAULTS \
                    .merge(@config["syntax_highlighter_opts"]) \
                    .merge(@coderay)
                )
              end
          end
        end

        #

        def send_deprecation_message_if_using_old_opts
          unless @coderay.empty?
            Jekyll::Deprecator.deprecation_message "You are using 'kramdown.coderay' in your configuration, "\
              "please use 'syntax_highlighter_opts' instead."
          end
        end
      end
    end
  end
end
