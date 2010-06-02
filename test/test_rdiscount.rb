require File.dirname(__FILE__) + '/helper'

class TestRdiscount < Test::Unit::TestCase

  context "rdiscount" do
    setup do
      config = {
        'rdiscount' => { 'extensions' => ['smart'] },
        'markdown' => 'rdiscount'
      }
      @markdown = MarkdownConverter.new config
    end

    should "pass rdiscount extensions" do
      assert_equal "<p>&ldquo;smart&rdquo;</p>", @markdown.convert('"smart"').strip
    end
  end
end
