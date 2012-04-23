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
      markdown = MarkdownConverter.new(@config)
      assert_equal "<h1>Some Header</h1>", markdown.convert('# Some Header #').strip
    end

    should "convert quotes to smart quotes" do
      markdown = MarkdownConverter.new(@config)
      assert_equal "<p>&ldquo;Pit&rsquo;hy&rdquo;</p>", markdown.convert(%{"Pit'hy"}).strip

      override = { 'kramdown' => { 'smart_quotes' => 'lsaquo,rsaquo,laquo,raquo' } }
      markdown = MarkdownConverter.new(@config.deep_merge(override))
      assert_equal "<p>&laquo;Pit&rsaquo;hy&raquo;</p>", markdown.convert(%{"Pit'hy"}).strip
    end
  end
end
