# frozen_string_literal: true

module Jekyll
  module SEO
    # Enhanced sitemap generator for SEO
    class Sitemap
      # Initialize a new Sitemap generator
      #
      # site - The Jekyll::Site instance
      def initialize(site)
        @site = site
        @config = site.config["seo"] || {}
        @sitemap_config = @config["sitemap"] || {}
      end

      # Generate sitemap data
      #
      # Returns a Hash with sitemap data
      def generate
        entries = []

        # Add pages
        @site.pages.each do |page|
          next if exclude_page?(page)
          entries << page_entry(page)
        end

        # Add posts
        @site.posts.docs.each do |post|
          next if exclude_page?(post)
          entries << post_entry(post)
        end

        # Add collection documents
        @site.collections.each do |label, collection|
          next if label == "posts" # Already processed
          next if exclude_collection?(collection)

          collection.docs.each do |doc|
            next if exclude_page?(doc)
            entries << collection_entry(doc)
          end
        end

        # Add static files if configured
        if @sitemap_config["include_static_files"]
          @site.static_files.each do |file|
            next if exclude_static_file?(file)
            entries << static_file_entry(file)
          end
        end

        {
          entries: entries,
          total: entries.size
        }
      end

      # Generate sitemap XML
      #
      # Returns a String with XML sitemap
      def to_xml
        entries = generate[:entries]

        xml = +%Q(<?xml version="1.0" encoding="UTF-8"?>\n)
        xml << %Q(<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"\n)
        xml << %Q(        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n)
        xml << %Q(        xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"\n)
        xml << %Q(        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9\n)
        xml << %Q(        http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">\n)

        entries.each do |entry|
          xml << entry_to_xml(entry)
        end

        xml << "</urlset>"
        xml
      end

      private

      # Convert an entry to XML
      #
      # entry - The Hash entry to convert
      #
      # Returns a String with XML for the entry
      def entry_to_xml(entry)
        xml = +"  <url>\n"
        xml << "    <loc>#{entry[:loc]}</loc>\n"

        if entry[:lastmod]
          xml << "    <lastmod>#{entry[:lastmod]}</lastmod>\n"
        end

        if entry[:changefreq]
          xml << "    <changefreq>#{entry[:changefreq]}</changefreq>\n"
        end

        if entry[:priority]
          xml << "    <priority>#{entry[:priority]}</priority>\n"
        end

        # Add image tags if available
        if entry[:images]&.any?
          entry[:images].each do |image|
            xml << "    <image:image>\n"
            xml << "      <image:loc>#{image[:loc]}</image:loc>\n"

            if image[:title]
              xml << "      <image:title>#{CGI.escapeHTML(image[:title])}</image:title>\n"
            end

            if image[:caption]
              xml << "      <image:caption>#{CGI.escapeHTML(image[:caption])}</image:caption>\n"
            end

            xml << "    </image:image>\n"
          end
        end

        xml << "  </url>\n"
      end

      # Create an entry for a page
      #
      # page - The Jekyll::Page to create an entry for
      #
      # Returns a Hash with entry data
      def page_entry(page)
        url = page_url(page)

        entry = {
          loc: url,
          lastmod: page_lastmod(page),
          changefreq: page_changefreq(page),
          priority: page_priority(page),
          images: page_images(page)
        }

        # Remove nil values
        entry.compact
      end

      # Create an entry for a post
      #
      # post - The Jekyll::Document (post) to create an entry for
      #
      # Returns a Hash with entry data
      def post_entry(post)
        url = page_url(post)

        entry = {
          loc: url,
          lastmod: page_lastmod(post),
          changefreq: page_changefreq(post),
          priority: page_priority(post),
          images: page_images(post)
        }

        # Remove nil values
        entry.compact
      end

      # Create an entry for a collection document
      #
      # doc - The Jekyll::Document to create an entry for
      #
      # Returns a Hash with entry data
      def collection_entry(doc)
        url = page_url(doc)

        entry = {
          loc: url,
          lastmod: page_lastmod(doc),
          changefreq: page_changefreq(doc),
          priority: page_priority(doc),
          images: page_images(doc)
        }

        # Remove nil values
        entry.compact
      end

      # Create an entry for a static file
      #
      # file - The Jekyll::StaticFile to create an entry for
      #
      # Returns a Hash with entry data
      def static_file_entry(file)
        url = static_file_url(file)

        entry = {
          loc: url,
          lastmod: static_file_lastmod(file),
          changefreq: static_file_changefreq(file),
          priority: static_file_priority(file)
        }

        # Remove nil values
        entry.compact
      end

      # Get the URL for a page
      #
      # page - The Jekyll page or document
      #
      # Returns a String URL
      def page_url(page)
        site_url = @site.config["url"] || ""
        base_url = @site.config["baseurl"] || ""

        # Get page URL
        page_url = page.url

        # Ensure the URL is absolute
        if page_url.start_with?("http")
          page_url
        else
          File.join(site_url, base_url, page_url)
        end
      end

      # Get the URL for a static file
      #
      # file - The Jekyll::StaticFile
      #
      # Returns a String URL
      def static_file_url(file)
        site_url = @site.config["url"] || ""
        base_url = @site.config["baseurl"] || ""

        # Get file URL
        file_url = file.url

        # Ensure the URL is absolute
        if file_url.start_with?("http")
          file_url
        else
          File.join(site_url, base_url, file_url)
        end
      end

      # Get the last modification time for a page
      #
      # page - The Jekyll page or document
      #
      # Returns a String date in ISO 8601 format or nil
      def page_lastmod(page)
        # Use explicit lastmod if provided
        if page.data["sitemap"] && page.data["sitemap"]["lastmod"]
          return page.data["sitemap"]["lastmod"].iso8601
        end

        # Use last_modified_at or date if available
        if page.data["last_modified_at"]
          return page.data["last_modified_at"].iso8601
        elsif page.data["date"]
          return page.data["date"].iso8601
        end

        # Get file mtime if nothing else available
        if page.respond_to?(:path) && File.exist?(page.path)
          return File.mtime(page.path).iso8601
        end

        nil
      end

      # Get the last modification time for a static file
      #
      # file - The Jekyll::StaticFile
      #
      # Returns a String date in ISO 8601 format or nil
      def static_file_lastmod(file)
        # Get file mtime
        if File.exist?(file.path)
          return File.mtime(file.path).iso8601
        end

        nil
      end

      # Get the change frequency for a page
      #
      # page - The Jekyll page or document
      #
      # Returns a String change frequency or nil
      def page_changefreq(page)
        # Use explicit changefreq if provided
        if page.data["sitemap"] && page.data["sitemap"]["changefreq"]
          return page.data["sitemap"]["changefreq"]
        end

        # Use collection default if available
        if page.respond_to?(:collection) && page.collection
          collection_config = @sitemap_config["collections"]&.fetch(page.collection.label, {})
          return collection_config["changefreq"] if collection_config["changefreq"]
        end

        # Determine based on type and date
        if page.is_a?(Jekyll::Document) && page.collection.label == "posts"
          # Older posts are less likely to change
          if page.data["date"]
            days_since_published = (Time.now - page.data["date"]) / (60 * 60 * 24)

            if days_since_published > 365
              return "yearly"
            elsif days_since_published > 90
              return "monthly"
            elsif days_since_published > 30
              return "weekly"
            else
              return "daily"
            end
          else
            return "monthly"
          end
        # Pages are more likely to be stable
        else
          @sitemap_config["default_changefreq"] || "monthly"
        end
      end

      # Get the change frequency for a static file
      #
      # file - The Jekyll::StaticFile
      #
      # Returns a String change frequency or nil
      def static_file_changefreq(file)
        @sitemap_config["static_files_changefreq"] || "monthly"
      end

      # Get the priority for a page
      #
      # page - The Jekyll page or document
      #
      # Returns a String priority or nil
      def page_priority(page)
        # Use explicit priority if provided
        if page.data["sitemap"] && page.data["sitemap"]["priority"]
          return page.data["sitemap"]["priority"].to_s
        end

        # Use collection default if available
        if page.respond_to?(:collection) && page.collection
          collection_config = @sitemap_config["collections"]&.fetch(page.collection.label, {})
          return collection_config["priority"].to_s if collection_config["priority"]
        end

        # Special case for home page
        if page.url == "/" || page.url == "/index.html"
          return "1.0"
        end

        # Special case for posts
        if page.is_a?(Jekyll::Document) && page.collection.label == "posts"
          # Higher priority for newer posts
          if page.data["date"]
            days_since_published = (Time.now - page.data["date"]) / (60 * 60 * 24)

            if days_since_published <= 30
              return "0.8"
            elsif days_since_published <= 90
              return "0.7"
            elsif days_since_published <= 365
              return "0.6"
            else
              return "0.5"
            end
          else
            return "0.6"
          end
        end

        # Default priority based on URL depth
        depth = page.url.count("/")
        priority = 0.9 - (0.1 * [depth - 1, 5].min)
        priority.round(1).to_s
      end

      # Get the priority for a static file
      #
      # file - The Jekyll::StaticFile
      #
      # Returns a String priority or nil
      def static_file_priority(file)
        @sitemap_config["static_files_priority"] || "0.3"
      end

      # Extract images from a page
      #
      # page - The Jekyll page or document
      #
      # Returns an Array of image Hashes or nil
      def page_images(page)
        return nil unless @sitemap_config["include_images"]

        images = []

        # Get content HTML
        content = if page.respond_to?(:content)
          page.content
        elsif page.respond_to?(:output)
          page.output
        else
          ""
        end

        # Extract images
        content.scan(/<img[^>]*src=["'](.*?)["'][^>]*>/i).each do |src|
          src = src.first

          # Skip data: URLs
          next if src.start_with?("data:")

          # Make URL absolute
          url = if src.start_with?("http")
            src
          else
            site_url = @site.config["url"] || ""
            base_url = @site.config["baseurl"] || ""
            File.join(site_url, base_url, src)
          end

          # Get title and alt text
          title = content.match(/<img[^>]*src=["']#{Regexp.escape(src)}["'][^>]*title=["'](.*?)["'][^>]*>/i)&.captures&.first
          alt = content.match(/<img[^>]*src=["']#{Regexp.escape(src)}["'][^>]*alt=["'](.*?)["'][^>]*>/i)&.captures&.first

          images << {
            loc: url,
            title: title || alt || page.data["title"],
            caption: alt
          }.compact
        end

        # Add explicitly defined images
        if page.data["images"].is_a?(Array)
          page.data["images"].each do |image|
            if image.is_a?(String)
              # Make URL absolute
              url = if image.start_with?("http")
                image
              else
                site_url = @site.config["url"] || ""
                base_url = @site.config["baseurl"] || ""
                File.join(site_url, base_url, image)
              end

              images << {
                loc: url,
                title: page.data["title"]
              }
            elsif image.is_a?(Hash)
              # Make URL absolute
              src = image["src"] || image["url"]
              url = if src.start_with?("http")
                src
              else
                site_url = @site.config["url"] || ""
                base_url = @site.config["baseurl"] || ""
                File.join(site_url, base_url, src)
              end

              images << {
                loc: url,
                title: image["title"] || image["alt"] || page.data["title"],
                caption: image["caption"] || image["alt"]
              }.compact
            end
          end
        end

        images.uniq { |img| img[:loc] }
      end

      # Check if a page should be excluded from the sitemap
      #
      # page - The Jekyll page or document to check
      #
      # Returns a Boolean
      def exclude_page?(page)
        # Skip pages marked as noindex or with sitemap: false
        if page.data["sitemap"] == false || page.data["noindex"] == true || page.data["published"] == false
          return true
        end

        # Skip excluded files by pattern
        if @sitemap_config["exclude"]&.any?
          url = page.url
          @sitemap_config["exclude"].each do |pattern|
            if pattern.is_a?(Regexp)
              return true if url.match?(pattern)
            else
              return true if File.fnmatch(pattern, url)
            end
          end
        end

        # Skip excluded layouts
        if @sitemap_config["exclude_layouts"]&.any?
          return true if page.data["layout"] && @sitemap_config["exclude_layouts"].include?(page.data["layout"])
        end

        false
      end

      # Check if a collection should be excluded from the sitemap
      #
      # collection - The Jekyll::Collection to check
      #
      # Returns a Boolean
      def exclude_collection?(collection)
        # Skip excluded collections
        if @sitemap_config["exclude_collections"]&.any?
          return true if @sitemap_config["exclude_collections"].include?(collection.label)
        end

        false
      end

      # Check if a static file should be excluded from the sitemap
      #
      # file - The Jekyll::StaticFile to check
      #
      # Returns a Boolean
      def exclude_static_file?(file)
        # Skip exclude extensions
        if @sitemap_config["exclude_extensions"]&.any?
          ext = File.extname(file.path).delete(".")
          return true if @sitemap_config["exclude_extensions"].include?(ext)
        end

        # Skip excluded files by pattern
        if @sitemap_config["exclude"]&.any?
          url = file.url
          @sitemap_config["exclude"].each do |pattern|
            if pattern.is_a?(Regexp)
              return true if url.match?(pattern)
            else
              return true if File.fnmatch(pattern, url)
            end
          end
        end

        # Only include specified extensions
        if @sitemap_config["include_extensions"]&.any?
          ext = File.extname(file.path).delete(".")
          return true unless @sitemap_config["include_extensions"].include?(ext)
        end

        false
      end
    end
  end
end
