# frozen_string_literal: true

require "helper"

class TestTagLink < TagUnitTest
  def render_content_with_collection(content, collection_label)
    render_content(
      content,
      "collections"      => { collection_label => { "output" => true } },
      "read_collections" => true
    )
  end

  context "post content has raw tag" do
    setup do
      content = <<~CONTENT
        ---
        title: This is a test
        ---

        ```liquid
        {% raw %}
        {% link _collection/name-of-document.md %}
        {% endraw %}
        ```
      CONTENT
      render_content(content)
    end

    should "render markdown with rouge" do
      assert_match(
        %(<div class="language-liquid highlighter-rouge">) +
          %(<div class="highlight"><pre class="highlight"><code>),
        @result
      )
    end
  end

  context "simple page with linking to a page" do
    setup do
      content = <<~CONTENT
        ---
        title: linking
        ---

        {% link contacts.html %}
        {% link info.md %}
        {% link /css/screen.css %}
      CONTENT
      render_content(content, "read_all" => true)
    end

    should "not cause an error" do
      refute_match(%r!markdown-html-error!, @result)
    end

    should "have the URL to the 'contacts' item" do
      assert_match(%r!/contacts\.html!, @result)
    end

    should "have the URL to the 'info' item" do
      assert_match(%r!/info\.html!, @result)
    end

    should "have the URL to the 'screen.css' item" do
      assert_match(%r!/css/screen\.css!, @result)
    end
  end

  context "simple page with dynamic linking to a page" do
    setup do
      content = <<~CONTENT
        ---
        title: linking
        ---

        {% assign contacts_filename = 'contacts' %}
        {% assign contacts_ext = 'html' %}
        {% link {{contacts_filename}}.{{contacts_ext}} %}
        {% assign info_path = 'info.md' %}
        {% link {{\ info_path\ }} %}
        {% assign screen_css_path = '/css' %}
        {% link {{ screen_css_path }}/screen.css %}
      CONTENT
      render_content(content, "read_all" => true)
    end

    should "not cause an error" do
      refute_match(%r!markdown-html-error!, @result)
    end

    should "have the URL to the 'contacts' item" do
      assert_match(%r!/contacts\.html!, @result)
    end

    should "have the URL to the 'info' item" do
      assert_match(%r!/info\.html!, @result)
    end

    should "have the URL to the 'screen.css' item" do
      assert_match(%r!/css/screen\.css!, @result)
    end
  end

  context "simple page with linking" do
    setup do
      content = <<~CONTENT
        ---
        title: linking
        ---

        {% link _methods/yaml_with_dots.md %}
      CONTENT
      render_content_with_collection(content, "methods")
    end

    should "not cause an error" do
      refute_match(%r!markdown-html-error!, @result)
    end

    should "have the URL to the 'yaml_with_dots' item" do
      assert_match(%r!/methods/yaml_with_dots\.html!, @result)
    end
  end

  context "simple page with dynamic linking" do
    setup do
      content = <<~CONTENT
        ---
        title: linking
        ---

        {% assign yaml_with_dots_path = '_methods/yaml_with_dots.md' %}
        {% link {{yaml_with_dots_path}} %}
      CONTENT
      render_content_with_collection(content, "methods")
    end

    should "not cause an error" do
      refute_match(%r!markdown-html-error!, @result)
    end

    should "have the URL to the 'yaml_with_dots' item" do
      assert_match(%r!/methods/yaml_with_dots\.html!, @result)
    end
  end

  context "simple page with nested linking" do
    setup do
      content = <<~CONTENT
        ---
        title: linking
        ---

        - 1 {% link _methods/sanitized_path.md %}
        - 2 {% link _methods/site/generate.md %}
      CONTENT
      render_content_with_collection(content, "methods")
    end

    should "not cause an error" do
      refute_match(%r!markdown-html-error!, @result)
    end

    should "have the URL to the 'sanitized_path' item" do
      assert_match %r!1\s/methods/sanitized_path\.html!, @result
    end

    should "have the URL to the 'site/generate' item" do
      assert_match %r!2\s/methods/site/generate\.html!, @result
    end
  end

  context "simple page with invalid linking" do
    should "cause an error" do
      content = <<~CONTENT
        ---
        title: Invalid linking
        ---

        {% link non-existent-collection-item %}
      CONTENT

      assert_raises ArgumentError do
        render_content_with_collection(content, "methods")
      end
    end
  end

  context "simple page with invalid dynamic linking" do
    should "cause an error" do
      content = <<~CONTENT
        ---
        title: Invalid linking
        ---

        {% assign non_existent_path = 'non-existent-collection-item' %}
        {% link {{\ non_existent_path\ }} %}
      CONTENT

      assert_raises ArgumentError do
        render_content_with_collection(content, "methods")
      end
    end
  end
end
