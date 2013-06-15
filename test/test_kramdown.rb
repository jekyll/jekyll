# encoding: UTF-8

require 'helper'

class TestKramdown < Test::Unit::TestCase
  context "kramdown" do
    setup do
      @config = {
        'markdown' => 'kramdown',
        'kramdown' => {
          'auto_ids'      => false,
          'footnote_nr'   => 1,
          'entity_output' => 'as_char',
          'toc_levels'    => '1..6',
          'smart_quotes'  => 'lsquo,rsquo,ldquo,rdquo'
        }
      }
    end

    # http://kramdown.rubyforge.org/converter/html.html#options
    should "pass kramdown options" do
      markdown = Converters::Markdown.new(@config)
      assert_equal "<h1>Some Header</h1>", markdown.convert('# Some Header #').strip
    end

    should "convert quotes to smart quotes" do
      markdown = Converters::Markdown.new(@config)
      assert_match /<p>(&#8220;|“)Pit(&#8217;|’)hy(&#8221;|”)<\/p>/, markdown.convert(%{"Pit'hy"}).strip

      override = { 'kramdown' => { 'smart_quotes' => 'lsaquo,rsaquo,laquo,raquo' } }
      markdown = Converters::Markdown.new(@config.deep_merge(override))
      assert_match /<p>(&#171;|«)Pit(&#8250;|›)hy(&#187;|»)<\/p>/, markdown.convert(%{"Pit'hy"}).strip
    end
  end
end
