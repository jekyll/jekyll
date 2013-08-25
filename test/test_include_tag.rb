# coding: utf-8

require 'helper'

class TestIncludeTag < Test::Unit::TestCase

  def create_post(content, override = {}, converter_class = Jekyll::Converters::Markdown)
    stub(Jekyll).configuration do
      Jekyll::Configuration::DEFAULTS.deep_merge({'pygments' => true}).deep_merge(override)
    end
    site = Site.new(Jekyll.configuration)

    if override['read_posts']
      site.read_posts('')
    end

    info = { :filters => [Jekyll::Filters], :registers => { :site => site } }
    @converter = site.converters.find { |c| c.class == converter_class }
    payload = { "pygments_prefix" => @converter.pygments_prefix,
                "pygments_suffix" => @converter.pygments_suffix }

    @result = Liquid::Template.parse(content).render(payload, info)
    @result = @converter.convert(@result)
  end
  
  context "include tag with parameters" do
    context "with one parameter" do
      setup do
        content = <<CONTENT
---
title: Include tag parameters
---

{% include sig.markdown myparam="test" %}

{% include params.html param="value" %}
CONTENT
        create_post(content, {'source' => source_dir})
      end

      should "correctly output include variable" do
        assert_match "<span id='include-param'>value</span>", @result.strip
      end

      should "ignore parameters if unused" do
        assert_match "<hr />\n<p>Tom Preston-Werner github.com/mojombo</p>\n", @result
      end
    end

    context "with invalid parameter syntax" do
      should "throw a SyntaxError" do
        content = <<CONTENT
---
title: Invalid parameter syntax
---

{% include params.html param s="value" %}
CONTENT
        assert_raise SyntaxError, 'Did not raise exception on invalid "include" syntax' do
          create_post(content, {'source' => source_dir})
        end

        content = <<CONTENT
---
title: Invalid parameter syntax
---

{% include params.html params="value %}
CONTENT
        assert_raise SyntaxError, 'Did not raise exception on invalid "include" syntax' do
          create_post(content, {'source' => source_dir})
        end
      end
    end

    context "with several parameters" do
      setup do
        content = <<CONTENT
---
title: multiple include parameters
---

{% include params.html param1="new_value" param2="another" %}
CONTENT
        create_post(content, {'source' => source_dir})
      end

      should "list all parameters" do
        assert_match '<li>param1 = new_value</li>', @result
        assert_match '<li>param2 = another</li>', @result
      end

      should "not include previously used parameters" do
        assert_match "<span id='include-param' />", @result
      end
    end

    context "without parameters" do
      setup do
        content = <<CONTENT
---
title: without parameters
---

{% include params.html %}
CONTENT
        create_post(content, {'source' => source_dir})
      end

      should "include file with empty parameters" do
        assert_match "<span id='include-param' />", @result
      end
    end
  end

  context "include file" do
    context "without trailing newline" do
      setup do
        content = <<CONTENT
{% include trailing-newline-missing.html %}
CONTENT
        create_post(content, {'source' => source_dir})
      end

      should "include file as is" do
        assert_equal "<p>Trailing newline is missing.</p>", @result
      end
    end

    context "with trailing newline" do
      setup do
        content = <<CONTENT
{% include trailing-newline.html %}
CONTENT
        create_post(content, {'source' => source_dir})
      end

      should "include the file with trailing whitespace removed" do
        assert_equal "<p>Trailing newline is there.</p>", @result
      end
    end

    context "with trailing newline and append content in a row" do
      setup do
        content = <<CONTENT
{% include trailing-newline.html %}+Appended content.
CONTENT
        create_post(content, {'source' => source_dir})
      end

      should "not add newline between include and appended content" do
        assert_equal "<p>Trailing newline is there.+Appended content.</p>", @result
      end
    end

    context "with trailing newline and add content at next line" do
      setup do
        content = <<CONTENT
{% include trailing-newline.html %}
Added content.
CONTENT
        create_post(content, {'source' => source_dir})
      end

      should "not add a newline between include and added content" do
        assert_equal "<p>Trailing newline is there. Added content.</p>", @result
      end
    end
  
    context "with trailing newline and add a paragraph" do
      setup do
        content = <<CONTENT
{% include trailing-newline.html %}

Added paragraph.
CONTENT
        create_post(content, {'source' => source_dir})
      end

      should "add a newline between include and added paragraph" do
        assert_equal "<p>Trailing newline is there.</p>\n\n<p>Added paragraph.</p>", @result
      end
    end
  end
end
