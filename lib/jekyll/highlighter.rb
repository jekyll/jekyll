module Jekyll
  module Highlighter
    class << self
      def render_pygments(code, lang, options)
        require 'pygments'
        options[:encoding] = 'utf-8'

        highlighted_code = Pygments.highlight(code, :lexer => lang, :options => options)

        if highlighted_code.nil?
          Jekyll.logger.error "There was an error highlighting your code:"
          puts
          Jekyll.logger.error code
          puts
          Jekyll.logger.error "While attempting to convert the above code, Pygments.rb" +
            " returned an unacceptable value."
          Jekyll.logger.error "This is usually a timeout problem solved by running `jekyll build` again."
          raise ArgumentError.new("Pygments.rb returned an unacceptable value when attempting to highlight some code.")
        end

        add_code_tag(highlighted_code, lang)
      end

      def render_rouge(code, lang, options)
        require 'rouge'
        formatter = Rouge::Formatters::HTML.new(line_numbers: options[:linenos], wrap: false)
        lexer = Rouge::Lexer.find_fancy(lang, code) || Rouge::Lexers::PlainText
        code = formatter.format(lexer.lex(code))
        add_code_tag("<div class=\"highlight\"><pre>#{code}</pre></div>", lang)
      end

      def render_codehighlighter(code, lang)
        add_code_tag("<div class=\"highlight\"><pre>#{h(code).strip}</pre></div>", lang)
      end

      def get_config(config, options={})
        config = Utils.symbolize_hash_keys(config["tags"] && config["tags"]["highlight"] || {})
        options = Utils.deep_merge_hashes(config, options)
        options[:linenos] = "inline" if options.key?(:linenos) and options[:linenos] == true
        options
      end

      def add_code_tag(code, lang)
        # Add nested <code> tags to code blocks
        code = code.sub(/<pre>\n*/, "<pre><code class=\"language-#{lang.to_s.gsub("+", "-")}\" data-lang=\"#{lang.to_s}\">")
        code = code.sub(/\n*<\/pre>/,"</code></pre>")
        code.strip
      end
    end
  end
end
