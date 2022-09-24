# frozen_string_literal: true

require "helper"

class TestSnippet < JekyllUnitTest
  def site_with_snippets(**overrides)
    fixture_site(overrides).tap(&:read)
  end

  context "A snippet" do
    setup do
      @site = site_with_snippets
    end

    should "ignore front matter" do
      snippet = @site.snippets["front_matter.md"]
      assert_empty snippet.data
      assert_includes snippet.content, "title: Foo"
    end

    should "be read even when within subdirectories" do
      assert @site.snippets["lipsum/lorem.md"]
    end

    should "be read only if basename satisfies EntryFilter" do
      refute @site.snippets["lipsum/_ignored.md"]
    end

    should "be rendered only when needed" do
      snippet = @site.snippets["lipsum/lorem.md"]
      refute snippet.rendered?
      assert snippet.output
      assert snippet.rendered?
    end

    should "be renderable without front matter" do
      snippet = @site.snippets["lipsum/lorem.md"]
      refute_includes "---\n", snippet.content
      assert_equal %(<h2 id="hello-world">Hello World</h2>), snippet.output.strip
    end

    should "not have a URL" do
      assert_raises(NoMethodError) { @site.snippets["lipsum/lorem.md"].url }
    end

    context "within a site with collection labelled 'snippets' at root" do
      should "not read snippets" do
        test_site = site_with_snippets(
          "collections" => {
            "snippets" => nil,
          }
        )
        assert_empty test_site.snippets
      end

      should "read snippets if 'snippets_dir' has been customized" do
        test_site = site_with_snippets(
          "snippets_dir" => "_includes",
          "collections"  => {
            "snippets" => nil,
          }
        )
        refute_empty test_site.snippets
        assert test_site.snippets["sig.markdown"]
      end
    end

    context "within a site with collection labelled 'snippets' in a custom collections_dir" do
      should "not read snippets" do
        test_site = site_with_snippets(
          "collections_dir" => "custom_collections_dir",
          "collections"     => {
            "snippets" => nil,
          }
        )
        assert_empty test_site.snippets
      end

      should "read snippets if 'snippets_dir' has been customized" do
        test_site = site_with_snippets(
          "snippets_dir"    => "_includes",
          "collections_dir" => "custom_collections_dir",
          "collections"     => {
            "snippets" => nil,
          }
        )
        refute_empty test_site.snippets
        assert test_site.snippets["sig.markdown"]
      end
    end

    context "within a themed-site" do
      should "be renderable without front matter" do
        themed_site = site_with_snippets("theme" => "test-theme")
        assert_equal(
          %(<h2 id="markdown-within-theme-gem">Markdown within theme-gem</h2>),
          themed_site.snippets["kappa/alpha.md"].output.strip
        )
      end
    end
  end
end
