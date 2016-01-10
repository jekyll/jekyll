# encoding: UTF-8

require 'helper'

class TestKramdown < JekyllUnitTest
  context "kramdown" do
    setup do
      @config = {
        "markdown" => "kramdown",
        "kramdown" => {
          "toc_levels" => "1..6",
          "entity_output" => "as_char",
          "smart_quotes" => "lsquo,rsquo,ldquo,rdquo",
          "auto_ids" => false,
          "footnote_nr" => 1,

          "syntax_highlighter_opts" => {
            "bold_every" => 8, "css" => "class"
          }
        }
      }

      @config = Jekyll.configuration(@config)
      @markdown = Converters::Markdown.new(@config)
    end

    should "run Kramdown" do
      assert_equal "<h1>Some Header</h1>", @markdown.convert('# Some Header #').strip
    end

    context "when asked to convert smart quotes" do
      should "convert" do
        assert_match %r!<p>(&#8220;|“)Pit(&#8217;|’)hy(&#8221;|”)<\/p>!, \
          @markdown.convert(%{"Pit'hy"}).strip
      end

      should "support custom types" do
        override = {
          'kramdown' => {
            'smart_quotes' => 'lsaquo,rsaquo,laquo,raquo'
          }
        }

        markdown = Converters::Markdown.new(Utils.deep_merge_hashes(@config, override))
        assert_match %r!<p>(&#171;|«)Pit(&#8250;|›)hy(&#187;|»)<\/p>!, \
          markdown.convert(%{"Pit'hy"}).strip
      end
    end

    should "render fenced code blocks with syntax highlighting" do
      result = nokogiri_fragment(@markdown.convert(Utils.strip_heredoc <<-MARKDOWN))
        ~~~ruby
        puts "Hello World"
        ~~~
      MARKDOWN

      selector = ".highlighter-rouge pre.highlight code"
      refute_empty result.css(selector)
    end

    context "when a custom highlighter is chosen" do
      should "use the chosen highlighter if it's available" do
        override = {
          "markdown" => "kramdown",
          "kramdown" => {
            "syntax_highlighter" => "coderay"
          }
        }

        markdown  = Converters::Markdown.new(Utils.deep_merge_hashes(@config, override))
        result = nokogiri_fragment(markdown.convert("~~~ruby\nputs 'hello world'\n~~~"))
        selector = ".highlighter-coderay div.CodeRay div.code pre"
        refute_empty result.css(selector)
      end

      should "support legacy enable_coderay... for now" do
        override = {
          "markdown" => "kramdown",
          "kramdown" => {
            "syntax_highlighter" => nil,
                "enable_coderay" => true
            }
        }

        markdown = Converters::Markdown.new(Utils.deep_merge_hashes(@config, override))
        result = nokogiri_fragment(markdown.convert("~~~ruby\nputs 'hello world'\n~~~"))
        selector = ".highlighter-coderay div.CodeRay div.code pre"
        refute_empty result.css(selector)
      end
    end

    should "move coderay to syntax_highlighter_opts" do
      override = {
        "markdown" => "kramdown",
        "kramdown" => {
          "syntax_highlighter" => "coderay",
          "coderay" => {
            "hello" => "world"
          }
        }
      }

      original = Kramdown::Document.method(:new)
      markdown = Converters::Markdown.new(Utils.deep_merge_hashes(@config, override))
      expect(Kramdown::Document).to receive(:new) do |arg1, hash|
        assert_equal hash["syntax_highlighter_opts"]["hello"], "world"
        original.call(arg1, hash)
      end

      # Trigger the test now.
      markdown.convert("hello world")
    end
  end
end
