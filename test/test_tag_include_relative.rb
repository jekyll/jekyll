# frozen_string_literal: true

require "helper"

class TestTagIncludeRelative < TagUnitTest
  context "include_relative tag with variable and liquid filters" do
    setup do
      site = fixture_site.tap do |s|
        s.read
        s.render
      end

      post = site.posts.docs.find do |p|
        p.basename.eql? "2014-09-02-relative-includes.markdown"
      end

      @content = post.output
    end

    should "include file as variable with liquid filters" do
      assert_match(%r!1 relative_include!, @content)
      assert_match(%r!2 relative_include!, @content)
      assert_match(%r!3 relative_include!, @content)
    end

    should "include file as variable and liquid filters with arbitrary whitespace" do
      assert_match(%r!4 relative_include!, @content)
      assert_match(%r!5 relative_include!, @content)
      assert_match(%r!6 relative_include!, @content)
    end

    should "include file as variable and filters with additional parameters" do
      assert_match("<li>var1 = foo</li>", @content)
      assert_match("<li>var2 = bar</li>", @content)
    end

    should "include file as partial variable" do
      assert_match(%r!8 relative_include!, @content)
    end

    should "include files relative to self" do
      assert_match(%r!9 —\ntitle: Test Post Where YAML!, @content)
    end

    context "trying to do bad stuff" do
      context "include missing file" do
        setup do
          @content = <<~CONTENT
            ---
            title: missing file
            ---

            {% include_relative missing.html %}
          CONTENT
        end

        should "raise error relative to source directory" do
          exception = assert_raises(IOError) { render_content(@content) }
          assert_match "Could not locate the included file 'missing.html' in any of " \
                       "[\"#{source_dir}\"].", exception.message
        end
      end

      context "include existing file above you" do
        setup do
          @content = <<~CONTENT
            ---
            title: higher file
            ---

            {% include_relative ../README.markdown %}
          CONTENT
        end

        should "raise error relative to source directory" do
          exception = assert_raises(ArgumentError) { render_content(@content) }
          assert_equal(
            "Invalid syntax for include tag. File contains invalid characters or " \
            "sequences:\n\n  ../README.markdown\n\nValid syntax:\n\n  " \
            "{% include_relative file.ext param='value' param2='value' %}\n\n",
            exception.message
          )
        end
      end
    end

    context "with symlink'd include" do
      should "not allow symlink includes" do
        FileUtils.mkdir_p("tmp")
        File.write("tmp/pages-test", "SYMLINK TEST")
        assert_raises IOError do
          content = <<~CONTENT
            ---
            title: Include symlink
            ---

            {% include_relative tmp/pages-test %}

          CONTENT
          render_content(content, "safe" => true)
        end
        @result ||= ""
        refute_match(%r!SYMLINK TEST!, @result)
      end

      should "not expose the existence of symlinked files" do
        exception = assert_raises IOError do
          content = <<~CONTENT
            ---
            title: Include symlink
            ---

            {% include_relative tmp/pages-test-does-not-exist %}

          CONTENT
          render_content(content, "safe" => true)
        end
        assert_match(
          "Ensure it exists in one of those directories and is not a symlink " \
          "as those are not allowed in safe mode.",
          exception.message
        )
      end
    end
  end
end
