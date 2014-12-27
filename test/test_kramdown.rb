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
          'smart_quotes'  => 'lsquo,rsquo,ldquo,rdquo',

          'enable_coderay'   => true,
          'coderay_bold_every'=> 12,
          'coderay' => {
            'coderay_css'        => :style,
            'coderay_bold_every' => 8
          }
        }
      }
      @config = Jekyll.configuration(@config)
      @markdown = Converters::Markdown.new(@config)
    end

    # http://kramdown.gettalong.org/converter/html.html#options
    should "pass kramdown options" do
      assert_equal "<h1>Some Header</h1>", @markdown.convert('# Some Header #').strip
    end

    should "convert quotes to smart quotes" do
      assert_match /<p>(&#8220;|“)Pit(&#8217;|’)hy(&#8221;|”)<\/p>/, @markdown.convert(%{"Pit'hy"}).strip

      override = { 'kramdown' => { 'smart_quotes' => 'lsaquo,rsaquo,laquo,raquo' } }
      markdown = Converters::Markdown.new(Utils.deep_merge_hashes(@config, override))
      assert_match /<p>(&#171;|«)Pit(&#8250;|›)hy(&#187;|»)<\/p>/, markdown.convert(%{"Pit'hy"}).strip
    end

    context "moving up nested coderay options" do
      setup do
        @markdown.convert('some markup')
        @converter_config = @markdown.instance_variable_get(:@config)['kramdown']
      end

      should "work correctly" do
        assert_equal :style, @converter_config['coderay_css']
      end

      should "also work for defaults" do
        default = Jekyll::Configuration::DEFAULTS['kramdown']['coderay']['coderay_tab_width']
        assert_equal default, @converter_config['coderay_tab_width']
      end

      should "not overwrite" do
        assert_equal 12, @converter_config['coderay_bold_every']
      end
    end
  end
end
