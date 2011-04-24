require 'helper'

class TestKramdown < Test::Unit::TestCase
  context "kramdown" do
    setup do
      config = {
        'markdown' => 'kramdown',
        'kramdown' => {
          'auto_ids'      => false,
          'footnote_nr'   => 1,
          'entity_output' => 'as_char',
          'toc_levels'    => '1..6'
        }
      }
      @markdown = MarkdownConverter.new config
    end

    # http://kramdown.rubyforge.org/converter/html.html#options
    should "pass kramdown options" do
      assert_equal "<h1>Some Header</h1>", @markdown.convert('# Some Header #').strip
    end
  end
end
