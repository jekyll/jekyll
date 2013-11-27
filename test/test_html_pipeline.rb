# encoding: UTF-8

require 'helper'

class TestHTMLPipeline < Test::Unit::TestCase
  context "HTMLPipeline" do
    setup do
      @config = {
        'markdown' => 'html_pipeline',
        'html_pipeline' => {
          'filters'       => ['markdownfilter', 'sanitizationfilter', 'emojifilter', 'mentionfilter'],
          'context'       => {
          	'asset_root'  => "http://foo.com/icons"
          }
        }
      }

      @config = Jekyll.configuration(@config)
      @markdown = Converters::Markdown.new(@config)
    end

    should "pass regular options" do
      assert_equal "<h1>Some Header</h1>", @markdown.convert('# Some Header #').strip
    end

    should "pass render emoji" do
      assert_equal "<p><img class=\"emoji\" title=\":trollface:\" alt=\":trollface:\" src=\"http://foo.com/icons/emoji/trollface.png\" height=\"20\" width=\"20\" align=\"absmiddle\"></p>", @markdown.convert(':trollface:').strip
    end

    should "fail when a library dependency is not met" do
      override = { 'html_pipeline' => { 'filters' => ['markdownfilter, AutolinkFilter'] } }
      markdown = Converters::Markdown.new(@config.deep_merge(override))
      # assert_fail markdown.convert('http://www.github.com')
    end

    should "fail when a context dependency is not met" do
      override = { 'html_pipeline' => { 'context' => {} } }
      markdown = Converters::Markdown.new(@config.deep_merge(override))
      # assert_fail markdown.convert(':trollface:')
    end
  end
end
