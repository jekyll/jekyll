# frozen_string_literal: true

require "helper"

class TestTagPostUrl < TagUnitTest
  context "simple page with post linking" do
    setup do
      content = <<~CONTENT
        ---
        title: Post linking
        ---

        {% post_url 2008-11-21-complex %}
      CONTENT

      render_content(content, "permalink" => "pretty", "read_posts" => true)
    end

    should "not cause an error" do
      refute_match %r!markdown-html-error!, @result
    end

    should "have the URL to the 'complex' post from 2008-11-21" do
      assert_match %r!/2008/11/21/complex/!, @result
    end
  end

  context "simple page with post linking containing special characters" do
    setup do
      content = <<~CONTENT
        ---
        title: Post linking
        ---

        {% post_url 2016-11-26-special-chars-(+) %}
      CONTENT

      render_content(content, "permalink" => "pretty", "read_posts" => true)
    end

    should "not cause an error" do
      refute_match %r!markdown-html-error!, @result
    end

    should "have the URL to the 'special-chars' post from 2016-11-26" do
      assert_match %r!/2016/11/26/special-chars-\(\+\)/!, @result
    end
  end

  context "simple page with nested post linking" do
    setup do
      content = <<~CONTENT
        ---
        title: Post linking
        ---

        - 1 {% post_url 2008-11-21-complex %}
        - 2 {% post_url /2008-11-21-complex %}
        - 3 {% post_url es/2008-11-21-nested %}
        - 4 {% post_url /es/2008-11-21-nested %}
      CONTENT

      render_content(content, "permalink" => "pretty", "read_posts" => true)
    end

    should "not cause an error" do
      refute_match %r!markdown-html-error!, @result
    end

    should "have the URL to the 'complex' post from 2008-11-21" do
      assert_match %r!1\s/2008/11/21/complex/!, @result
      assert_match %r!2\s/2008/11/21/complex/!, @result
    end

    should "have the URL to the 'nested' post from 2008-11-21" do
      assert_match %r!3\s/2008/11/21/nested/!, @result
      assert_match %r!4\s/2008/11/21/nested/!, @result
    end
  end

  context "simple page with nested post linking and path not used in `post_url`" do
    setup do
      content = <<~CONTENT
        ---
        title: Deprecated Post linking
        ---

        - 1 {% post_url 2008-11-21-nested %}
      CONTENT

      render_content(content, "permalink" => "pretty", "read_posts" => true)
    end

    should "not cause an error" do
      refute_match(%r!markdown-html-error!, @result)
    end

    should "have the url to the 'nested' post from 2008-11-21" do
      assert_match %r!1\s/2008/11/21/nested/!, @result
    end

    should "throw a deprecation warning" do
      deprecation_warning = "       Deprecation: A call to '{% post_url 2008-11-21-nested %}' " \
                            "did not match a post using the new matching method of checking " \
                            "name (path-date-slug) equality. Please make sure that you change " \
                            "this tag to match the post's name exactly."
      assert_includes Jekyll.logger.messages, deprecation_warning
    end
  end

  context "simple page with invalid post name linking" do
    should "cause an error" do
      assert_raises Jekyll::Errors::PostURLError do
        render_content(<<~CONTENT, "read_posts" => true)
          ---
          title: Invalid post name linking
          ---

          {% post_url abc2008-11-21-complex %}
        CONTENT
      end
    end

    should "cause an error with a bad date" do
      assert_raises Jekyll::Errors::InvalidDateError do
        render_content(<<~CONTENT, "read_posts" => true)
          ---
          title: Invalid post name linking
          ---

          {% post_url 2008-42-21-complex %}
        CONTENT
      end
    end
  end
end
