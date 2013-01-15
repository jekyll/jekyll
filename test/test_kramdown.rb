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
  end
end
