# frozen_string_literal: true

class Jekyll::Converters::Markdown::RedcarpetParser
  module CommonMethods
    def add_code_tags(code, lang)
      code = code.to_s
      code = code.sub(
        %r!<pre>!,
        "<pre><code class=\"language-#{lang}\" data-lang=\"#{lang}\">"
      )
      code = code.sub(%r!</pre>!, "</code></pre>")
      code
    end
  end

  module WithPygments
    include CommonMethods
    def block_code(code, lang)
      Jekyll::External.require_with_graceful_fail("pygments")
      lang = lang && lang.split.first || "text"
      add_code_tags(
        Pygments.highlight(
          code,
          {
            :lexer   => lang,
            :options => { :encoding => "utf-8" },
          }
        ),
        lang
      )
    end
  end

  module WithoutHighlighting
    require "cgi"

    include CommonMethods

    def code_wrap(code)
      "<figure class=\"highlight\"><pre>#{CGI.escapeHTML(code)}</pre></figure>"
    end

    def block_code(code, lang)
      lang = lang && lang.split.first || "text"
      add_code_tags(code_wrap(code), lang)
    end
  end

  module WithRouge
    def block_code(code, lang)
      code = "<pre>#{super}</pre>"

      "<div class=\"highlight\">#{add_code_tags(code, lang)}</div>"
    end

    protected
    def rouge_formatter(_lexer)
      Jekyll::Utils::Rouge.html_formatter(:wrap => false)
    end
  end

  def initialize(config)
    Jekyll::External.require_with_graceful_fail("redcarpet")
    @config = config
    @redcarpet_extensions = {}
    @config["redcarpet"]["extensions"].each do |e|
      @redcarpet_extensions[e.to_sym] = true
    end

    @renderer ||= class_with_proper_highlighter(@config["highlighter"])
  end

  def class_with_proper_highlighter(highlighter)
    Class.new(Redcarpet::Render::HTML) do
      case highlighter
      when "pygments"
        include WithPygments
      when "rouge"
        Jekyll::External.require_with_graceful_fail(%w(
          rouge rouge/plugins/redcarpet
        ))

        unless Gem::Version.new(Rouge.version) > Gem::Version.new("1.3.0")
          abort "Please install Rouge 1.3.0 or greater and try running Jekyll again."
        end

        include Rouge::Plugins::Redcarpet
        include CommonMethods
        include WithRouge
      else
        include WithoutHighlighting
      end
    end
  end

  def convert(content)
    @redcarpet_extensions[:fenced_code_blocks] = \
      !@redcarpet_extensions[:no_fenced_code_blocks]
    if @redcarpet_extensions[:smart]
      @renderer.send :include, Redcarpet::Render::SmartyPants
    end
    markdown = Redcarpet::Markdown.new(
      @renderer.new(@redcarpet_extensions),
      @redcarpet_extensions
    )
    markdown.render(content)
  end
end
