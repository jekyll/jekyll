# frozen_string_literal: true

module Jekyll
  # Generator that creates SEO files like sitemap.xml
  class SeoGenerator < Generator
    safe true
    priority :low

    # Generate the SEO files
    #
    # site - The Jekyll::Site
    #
    # Returns nothing
    def generate(site)
      seo_config = site.config["seo"] || {}
      generate_sitemap(site) if seo_config.fetch("generate_sitemap", true)
      generate_robots(site) if seo_config.fetch("generate_robots", true)
    end

    private

    # Generate sitemap.xml
    #
    # site - The Jekyll::Site
    #
    # Returns nothing
    def generate_sitemap(site)
      sitemap = Jekyll::SEO::Sitemap.new(site)
      xml = sitemap.to_xml

      # Create a new page with the sitemap
      page = PageWithoutAFile.new(site, "", "", "sitemap.xml")
      page.content = xml
      page.data["layout"] = nil
      page.data["sitemap"] = false
      page.output = xml

      # Add the page to the site
      site.pages << page
    end

    # Generate robots.txt
    #
    # site - The Jekyll::Site
    #
    # Returns nothing
    def generate_robots(site)
      # Skip if robots.txt already exists
      return if site.pages.any? { |p| p.name == "robots.txt" } ||
                site.static_files.any? { |f| f.name == "robots.txt" }

      seo_config = site.config["seo"] || {}
      robots_config = seo_config["robots"] || {}

      content = []

      # User Agent settings
      if robots_config["user_agents"]
        robots_config["user_agents"].each do |agent|
          content << "User-agent: #{agent["name"]}"

          if agent["disallow"]
            Array(agent["disallow"]).each do |path|
              content << "Disallow: #{path}"
            end
          end

          if agent["allow"]
            Array(agent["allow"]).each do |path|
              content << "Allow: #{path}"
            end
          end

          content << ""
        end
      else
        # Default settings
        content << "User-agent: *"

        disallow = robots_config["disallow"] || []
        disallow.each do |path|
          content << "Disallow: #{path}"
        end

        content << ""
      end

      # Sitemap URL
      if robots_config.fetch("include_sitemap", true)
        site_url = site.config["url"] || ""
        base_url = site.config["baseurl"] || ""

        sitemap_url = File.join(site_url, base_url, "sitemap.xml")
        content << "Sitemap: #{sitemap_url}"
        content << ""
      end

      # Create robots.txt file
      page = PageWithoutAFile.new(site, "", "", "robots.txt")
      page.content = content.join("\n")
      page.data["layout"] = nil
      page.data["sitemap"] = false
      page.output = page.content

      # Add the page to the site
      site.pages << page
    end
  end

  # Hook to analyze content after rendering
  Jekyll::Hooks.register :posts, :post_render do |post|
    # Get site instance
    site = post.site

    # Skip if SEO is disabled
    seo_config = site.config["seo"] || {}
    next unless seo_config.fetch("auto_analyze", true)

    # Run SEO analysis
    analyzer = Jekyll::SEO::Analyzer.new(post, site)
    post.data["seo_analysis"] = analyzer.analyze

    # Run content analysis
    content_analyzer = Jekyll::SEO::ContentAnalysis.new(post, site)
    post.data["content_analysis"] = content_analyzer.analyze
  end

  # Hook to add SEO meta tags to pages
  Jekyll::Hooks.register :pages, :post_render do |page|
    # Skip if SEO is disabled
    seo_config = page.site.config["seo"] || {}
    next unless seo_config.fetch("auto_analyze", true)

    # Run SEO analysis if the page has content
    next if page.content.strip.empty?

    # Run SEO analysis
    analyzer = Jekyll::SEO::Analyzer.new(page, page.site)
    page.data["seo_analysis"] = analyzer.analyze

    # Run content analysis
    content_analyzer = Jekyll::SEO::ContentAnalysis.new(page, page.site)
    page.data["content_analysis"] = content_analyzer.analyze
  end

  # Hook to add SEO meta tags to collection documents
  Jekyll::Hooks.register :documents, :post_render do |doc|
    # Skip posts (already handled)
    next if doc.collection.label == "posts"

    # Skip if SEO is disabled
    seo_config = doc.site.config["seo"] || {}
    next unless seo_config.fetch("auto_analyze", true)

    # Run SEO analysis
    analyzer = Jekyll::SEO::Analyzer.new(doc, doc.site)
    doc.data["seo_analysis"] = analyzer.analyze

    # Run content analysis
    content_analyzer = Jekyll::SEO::ContentAnalysis.new(doc, doc.site)
    doc.data["content_analysis"] = content_analyzer.analyze
  end
end
