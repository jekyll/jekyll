# frozen_string_literal: true

require "helper"

class TestSEO < JekyllUnitTest
  context "SEO module" do
    setup do
      @site = Site.new(site_configuration)
      @site.read
      @site.generate
      @site.render
    end

    should "be loaded" do
      assert defined?(Jekyll::SEO)
    end

    should "register tags" do
      assert Liquid::Template.tags.key?("structured_data")
      assert Liquid::Template.tags.key?("social_media_tags")
      assert Liquid::Template.tags.key?("seo_analysis")
      assert Liquid::Template.tags.key?("content_analysis")
      assert Liquid::Template.tags.key?("sitemap_url")
      assert Liquid::Template.tags.key?("sitemap_preview")
    end

    should "have default configuration" do
      assert @site.config.key?("seo")
      assert @site.config["seo"].key?("sitemap")
      assert @site.config["seo"].key?("robots")
    end

    context "with sitemap generation" do
      should "create sitemap.xml" do
        assert @site.pages.any? { |p| p.name == "sitemap.xml" }
      end
    end

    context "with robots.txt generation" do
      should "create robots.txt" do
        assert @site.pages.any? { |p| p.name == "robots.txt" }
      end
    end

    context "with analyzer" do
      setup do
        @doc = @site.pages.first
        @analyzer = Jekyll::SEO::Analyzer.new(@doc, @site)
      end

      should "analyze content" do
        results = @analyzer.analyze
        assert results.key?(:title)
        assert results.key?(:description)
        assert results.key?(:recommendations)
        assert results.key?(:score)
      end
    end

    context "with structured data" do
      setup do
        @doc = @site.pages.first
        @generator = Jekyll::SEO::StructuredData.new(@doc, @site)
      end

      should "generate structured data" do
        data = @generator.generate
        assert data.key?("@context")
        assert_equal "https://schema.org", data["@context"]
        assert data.key?("@type")
      end

      should "convert to JSON" do
        json = @generator.to_json
        assert json.is_a?(String)
        assert json.include?("@context")
        assert json.include?("https://schema.org")
      end
    end

    context "with social media tags" do
      setup do
        @doc = @site.pages.first
        @generator = Jekyll::SEO::SocialMedia.new(@doc, @site)
      end

      should "generate social media tags" do
        tags = @generator.generate
        assert tags.key?(:open_graph)
        assert tags.key?(:twitter)
      end

      should "convert to HTML" do
        html = @generator.to_html
        assert html.is_a?(String)
        assert html.include?("<meta ")
      end
    end

    context "with content analysis" do
      setup do
        @doc = @site.pages.first
        @analyzer = Jekyll::SEO::ContentAnalysis.new(@doc, @site)
      end

      should "analyze content" do
        results = @analyzer.analyze
        assert results.key?(:readability)
        assert results.key?(:stats)
        assert results.key?(:suggestions)
      end
    end

    context "with sitemap" do
      setup do
        @sitemap = Jekyll::SEO::Sitemap.new(@site)
      end

      should "generate sitemap data" do
        data = @sitemap.generate
        assert data.key?(:entries)
        assert data.key?(:total)
        assert data[:entries].is_a?(Array)
      end

      should "convert to XML" do
        xml = @sitemap.to_xml
        assert xml.is_a?(String)
        assert xml.include?("<?xml")
        assert xml.include?("<urlset")
        assert xml.include?("<url>")
      end
    end

    context "with utils" do
      should "extract keywords" do
        text = "Jekyll is a simple, blog-aware, static site generator. Jekyll is the engine behind GitHub Pages."
        keywords = Jekyll::SEO::Utils.extract_keywords(text)
        assert keywords.is_a?(Array)
        assert keywords.include?("jekyll")
        assert keywords.include?("github")
      end

      should "calculate readability" do
        text = "Jekyll is a simple, blog-aware, static site generator. Jekyll is the engine behind GitHub Pages."
        score = Jekyll::SEO::Utils.readability_score(text)
        assert score.key?(:score)
        assert score.key?(:grade)
      end

      should "slugify text" do
        text = "This is a Test String!"
        slug = Jekyll::SEO::Utils.slugify(text)
        assert_equal "this-is-a-test-string", slug
      end
    end
  end
end
