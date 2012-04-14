require File.dirname(__FILE__) + '/helper'

class TestRedcarpet < Test::Unit::TestCase
  context "redcarpet" do
    setup do
      config = {
        'redcarpet' => { 'extensions' => ['smart'] },
        'markdown' => 'redcarpet'
      }
      @markdown = MarkdownConverter.new config
    end

    should "pass redcarpet options" do
      assert_equal "<h1>Some Header</h1>", @markdown.convert('# Some Header #').strip
    end
    
    should "pass redcarpet extensions" do
      assert_equal "<p>&quot;smart&quot;</p>", @markdown.convert('"smart"').strip
    end
  end
end
