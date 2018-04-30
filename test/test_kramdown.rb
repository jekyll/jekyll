# frozen_string_literal: true

require "helper"

class TestKramdown < JekyllUnitTest
  context "kramdown" do
    setup do
      @config = {
        "markdown" => "kramdown",
        "kramdown" => {
          "smart_quotes"            => "lsquo,rsquo,ldquo,rdquo",
          "entity_output"           => "as_char",
          "toc_levels"              => "1..6",
          "auto_ids"                => false,
          "footnote_nr"             => 1,
          "show_warnings"           => true,

          "syntax_highlighter"      => "rouge",
          "syntax_highlighter_opts" => {
            "bold_every" => 8,
            "css"        => :class,
            "css_class"  => "highlight",
            "formatter"  => Jekyll::Utils::Rouge.html_formatter.class,
          },
        },
      }
      @kramdown_config_keys = @config["kramdown"].keys
      @syntax_highlighter_opts_config_keys = \
        @config["kramdown"]["syntax_highlighter_opts"].keys

      @config = Jekyll.configuration(@config)
      @markdown = Converters::Markdown.new(@config)
      @markdown.setup
    end

    should "fill symbolized keys into config for compatibility with kramdown" do
      kramdown_config = @markdown.instance_variable_get(:@parser)
        .instance_variable_get(:@config)

      @kramdown_config_keys.each do |key|
        assert kramdown_config.key?(key.to_sym),
          "Expected #{kramdown_config} to include key #{key.to_sym.inspect}"
      end

      @syntax_highlighter_opts_config_keys.each do |key|
        assert kramdown_config["syntax_highlighter_opts"].key?(key.to_sym),
          "Expected #{kramdown_config["syntax_highlighter_opts"]} to include " \
          "key #{key.to_sym.inspect}"
      end

      assert_equal kramdown_config["smart_quotes"], kramdown_config[:smart_quotes]
      assert_equal kramdown_config["syntax_highlighter_opts"]["css"],
        kramdown_config[:syntax_highlighter_opts][:css]
    end

    should "run Kramdown" do
      assert_equal "<h1>Some Header</h1>", @markdown.convert("# Some Header #").strip
    end

    should "should log kramdown warnings" do
      allow_any_instance_of(Kramdown::Document).to receive(:warnings).and_return(["foo"])
      expect(Jekyll.logger).to receive(:warn).with("Kramdown warning:", "foo")
      @markdown.convert("Something")
    end

    context "when asked to convert smart quotes" do
      should "convert" do
        assert_match(
          %r!<p>(&#8220;|“)Pit(&#8217;|’)hy(&#8221;|”)<\/p>!,
          @markdown.convert(%("Pit'hy")).strip
        )
      end

      should "support custom types" do
        override = {
          "highlighter" => nil,
          "kramdown"    => {
            "smart_quotes" => "lsaquo,rsaquo,laquo,raquo",
          },
        }

        markdown = Converters::Markdown.new(Utils.deep_merge_hashes(@config, override))
        assert_match %r!<p>(&#171;|«)Pit(&#8250;|›)hy(&#187;|»)<\/p>!, \
          markdown.convert(%("Pit'hy")).strip
      end
    end

    should "render fenced code blocks with syntax highlighting" do
      result = nokogiri_fragment(@markdown.convert(Utils.strip_heredoc(<<-MARKDOWN)))
        ~~~ruby
        puts "Hello World"
        ~~~
      MARKDOWN
      div_highlight = ""
      div_highlight = ">div.highlight" unless Utils::Rouge.old_api?
      selector = "div.highlighter-rouge#{div_highlight}>pre.highlight>code"
      refute result.css(selector).empty?
    end

    context "when a custom highlighter is chosen" do
      should "use the chosen highlighter if it's available" do
        override = {
          "highlighter" => nil,
          "markdown"    => "kramdown",
          "kramdown"    => {
            "syntax_highlighter" => :coderay,
          },
        }

        markdown = Converters::Markdown.new(Utils.deep_merge_hashes(@config, override))
        result = nokogiri_fragment(markdown.convert(Utils.strip_heredoc(<<-MARKDOWN)))
          ~~~ruby
          puts "Hello World"
          ~~~
        MARKDOWN

        selector = "div.highlighter-coderay>div.CodeRay>div.code>pre"
        refute result.css(selector).empty?
      end

      should "support legacy enable_coderay... for now" do
        override = {
          "markdown" => "kramdown",
          "kramdown" => {
            "enable_coderay" => true,
          },
        }

        @config.delete("highlighter")
        @config["kramdown"].delete("syntax_highlighter")
        markdown = Converters::Markdown.new(Utils.deep_merge_hashes(@config, override))
        result = nokogiri_fragment(markdown.convert(Utils.strip_heredoc(<<-MARKDOWN)))
          ~~~ruby
          puts "Hello World"
          ~~~
        MARKDOWN

        selector = "div.highlighter-coderay>div.CodeRay>div.code>pre"
        refute result.css(selector).empty?, "pre tag should exist"
      end
    end

    should "move coderay to syntax_highlighter_opts" do
      original = Kramdown::Document.method(:new)
      markdown = Converters::Markdown.new(Utils.deep_merge_hashes(@config, {
        "higlighter" => nil,
        "markdown"   => "kramdown",
        "kramdown"   => {
          "syntax_highlighter" => "coderay",
          "coderay"            => {
            "hello" => "world",
          },
        },
      }))

      expect(Kramdown::Document).to receive(:new) do |arg1, hash|
        assert_equal hash["syntax_highlighter_opts"]["hello"], "world"
        original.call(arg1, hash)
      end

      markdown.convert("hello world")
    end
  end
end
