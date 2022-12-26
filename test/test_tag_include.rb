# frozen_string_literal: true

require "helper"

class TestTagInclude < TagUnitTest
  context "include tag with parameters" do
    context "with symlink'd include" do
      should "not allow symlink includes" do
        FileUtils.mkdir_p("tmp")
        File.write("tmp/pages-test", "SYMLINK TEST")
        assert_raises IOError do
          content = <<~CONTENT
            ---
            title: Include symlink
            ---

            {% include tmp/pages-test %}

          CONTENT
          render_content(content, "safe" => true)
        end
        @result ||= ""
        refute_match(%r!SYMLINK TEST!, @result)
      end

      should "not expose the existence of symlinked files" do
        ex = assert_raises IOError do
          content = <<~CONTENT
            ---
            title: Include symlink
            ---

            {% include tmp/pages-test-does-not-exist %}

          CONTENT
          render_content(content, "safe" => true)
        end
        assert_match(
          "Could not locate the included file 'tmp/pages-test-does-not-exist' in any of " \
          "[\"#{source_dir}/_includes\"]. Ensure it exists in one of those directories and is " \
          "not a symlink as those are not allowed in safe mode.",
          ex.message
        )
      end
    end

    context "with one parameter" do
      setup do
        content = <<~CONTENT
          ---
          title: Include tag parameters
          ---

          {% include sig.markdown myparam="test" %}

          {% include params.html param="value" %}
        CONTENT
        render_content(content)
      end

      should "correctly output include variable" do
        assert_match "<span id=\"include-param\">value</span>", @result.strip
      end

      should "ignore parameters if unused" do
        assert_match "<hr />\n<p>Tom Preston-Werner\ngithub.com/mojombo</p>\n", @result
      end
    end

    context "with simple syntax but multiline markup" do
      setup do
        content = <<~CONTENT
          ---
          title: Include tag parameters
          ---

          {% include sig.markdown myparam="test" %}

          {% include params.html
            param="value" %}
        CONTENT
        render_content(content)
      end

      should "correctly output include variable" do
        assert_match "<span id=\"include-param\">value</span>", @result.strip
      end

      should "ignore parameters if unused" do
        assert_match "<hr />\n<p>Tom Preston-Werner\ngithub.com/mojombo</p>\n", @result
      end
    end

    context "with variable syntax but multiline markup" do
      setup do
        content = <<~CONTENT
          ---
          title: Include tag parameters
          ---

          {% include sig.markdown myparam="test" %}
          {% assign path = "params" | append: ".html" %}
          {% include {{ path }}
            param="value" %}
        CONTENT
        render_content(content)
      end

      should "correctly output include variable" do
        assert_match "<span id=\"include-param\">value</span>", @result.strip
      end

      should "ignore parameters if unused" do
        assert_match "<hr />\n<p>Tom Preston-Werner\ngithub.com/mojombo</p>\n", @result
      end
    end

    context "with invalid parameter syntax" do
      should "throw a ArgumentError" do
        content = <<~CONTENT
          ---
          title: Invalid parameter syntax
          ---

          {% include params.html param s="value" %}
        CONTENT
        assert_raises ArgumentError, %(Did not raise exception on invalid "include" syntax) do
          render_content(content)
        end

        content = <<~CONTENT
          ---
          title: Invalid parameter syntax
          ---

          {% include params.html params="value %}
        CONTENT
        assert_raises ArgumentError, %(Did not raise exception on invalid "include" syntax) do
          render_content(content)
        end
      end
    end

    context "with several parameters" do
      setup do
        content = <<~CONTENT
          ---
          title: multiple include parameters
          ---

          {% include params.html param1="new_value" param2="another" %}
        CONTENT
        render_content(content)
      end

      should "list all parameters" do
        assert_match "<li>param1 = new_value</li>", @result
        assert_match "<li>param2 = another</li>", @result
      end

      should "not include previously used parameters" do
        assert_match "<span id=\"include-param\"></span>", @result
      end
    end

    context "without parameters" do
      setup do
        content = <<~CONTENT
          ---
          title: without parameters
          ---

          {% include params.html %}
        CONTENT
        render_content(content)
      end

      should "include file with empty parameters" do
        assert_match "<span id=\"include-param\"></span>", @result
      end
    end

    context "with include file with special characters without params" do
      setup do
        content = <<~CONTENT
          ---
          title: special characters
          ---

          {% include params@2.0.html %}
        CONTENT
        render_content(content)
      end

      should "include file with empty parameters" do
        assert_match "<span id=\"include-param\"></span>", @result
      end
    end

    context "with include file with special characters with params" do
      setup do
        content = <<~CONTENT
          ---
          title: special characters
          ---

          {% include params@2.0.html param1="foobar" param2="bazbar" %}
        CONTENT
        render_content(content)
      end

      should "include file with empty parameters" do
        assert_match "<li>param1 = foobar</li>", @result
        assert_match "<li>param2 = bazbar</li>", @result
      end
    end

    context "with custom includes directory" do
      setup do
        content = <<~CONTENT
          ---
          title: custom includes directory
          ---

          {% include custom.html %}
        CONTENT

        render_content(content, "includes_dir" => "_includes_custom")
      end

      should "include file from custom directory" do
        assert_match "custom_included", @result
      end
    end

    context "without parameters within if statement" do
      setup do
        content = <<~CONTENT
          ---
          title: without parameters within if statement
          ---

          {% if true %}{% include params.html %}{% endif %}
        CONTENT
        render_content(content)
      end

      should "include file with empty parameters within if statement" do
        assert_match "<span id=\"include-param\"></span>", @result
      end
    end

    context "include missing file" do
      setup do
        @content = <<~CONTENT
          ---
          title: missing file
          ---

          {% include missing.html %}
        CONTENT
      end

      should "raise error relative to source directory" do
        exception = assert_raises IOError do
          render_content(@content)
        end
        assert_match(
          "Could not locate the included file 'missing.html' in any of " \
          "[\"#{source_dir}/_includes\"].",
          exception.message
        )
      end
    end

    context "include tag with variable and liquid filters" do
      setup do
        site = fixture_site.tap do |s|
          s.read
          s.render
        end
        post = site.posts.docs.find do |p|
          p.basename.eql? "2013-12-17-include-variable-filters.markdown"
        end
        @content = post.output
      end

      should "include file as variable with liquid filters" do
        assert_match(%r!1 included!, @content)
        assert_match(%r!2 included!, @content)
        assert_match(%r!3 included!, @content)
      end

      should "include file as variable and liquid filters with arbitrary whitespace" do
        assert_match(%r!4 included!, @content)
        assert_match(%r!5 included!, @content)
        assert_match(%r!6 included!, @content)
      end

      should "include file as variable and filters with additional parameters" do
        assert_match("<li>var1 = foo</li>", @content)
        assert_match("<li>var2 = bar</li>", @content)
      end

      should "include file as partial variable" do
        assert_match(%r!8 included!, @content)
      end
    end
  end
end
