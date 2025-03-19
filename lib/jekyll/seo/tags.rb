# frozen_string_literal: true

module Jekyll
  module SEO
    # SEO Tags for Liquid templates
    module Tags
      # Base class for all SEO tags
      class SeoTag < Liquid::Tag
        def initialize(tag_name, markup, tokens)
          super
          @markup = markup.strip
        end

        def render(context)
          @site = context.registers[:site]
          @page = context.registers[:page]
          @context = context

          # Find document in site
          @document = find_document

          render_tag
        end

        private

        # Find the document in the site
        def find_document
          # Try to find the document in collections
          @site.collections.each do |_, collection|
            collection.docs.each do |doc|
              return doc if doc.url == @page["url"]
            end
          end

          # If not found, create a basic document from page data
          PageDocument.new(@page, @site)
        end

        # Class to wrap page data as a document
        class PageDocument
          attr_reader :data, :site

          def initialize(data, site)
            @data = data
            @site = site
          end

          def url
            @data["url"]
          end

          def method_missing(method_name, *args)
            if @data.key?(method_name.to_s)
              @data[method_name.to_s]
            else
              super
            end
          end

          def respond_to_missing?(method_name, include_private = false)
            @data.key?(method_name.to_s) || super
          end
        end
      end

      # Tag to output structured data as JSON-LD
      class StructuredDataTag < SeoTag
        def render_tag
          generator = Jekyll::SEO::StructuredData.new(@document, @site)

          # Parse markup options
          options = {}

          # Check if type is specified
          if !@markup.empty?
            type = @markup.strip
            @document.data["schema_type"] = type if type && !type.empty?
          end

          "<script type=\"application/ld+json\">\n#{generator.to_json}\n</script>"
        end
      end

      # Tag to output all social media meta tags
      class SocialMediaTag < SeoTag
        def render_tag
          generator = Jekyll::SEO::SocialMedia.new(@document, @site)
          generator.to_html
        end
      end

      # Tag to output SEO analyzer results
      class SeoAnalysisTag < SeoTag
        def render_tag
          analyzer = Jekyll::SEO::Analyzer.new(@document, @site)
          results = analyzer.analyze

          output = +%(<div class="seo-analysis">\n)
          output << %(<h2>SEO Analysis</h2>\n)
          output << %(<p>Overall Score: <strong>#{results[:score]}/100</strong></p>\n)

          if results[:recommendations].any?
            output << %(<h3>Recommendations</h3>\n)
            output << %(<ul>\n)

            results[:recommendations].each do |recommendation|
              output << %(<li>#{recommendation}</li>\n)
            end

            output << %(</ul>\n)
          end

          output << %(</div>\n)
        end
      end

      # Tag to output content analysis results
      class ContentAnalysisTag < SeoTag
        def render_tag
          analyzer = Jekyll::SEO::ContentAnalysis.new(@document, @site)
          results = analyzer.analyze

          output = +%(<div class="content-analysis">\n)
          output << %(<h2>Content Analysis</h2>\n)

          # Readability section
          readability = results[:readability]
          output << %(<h3>Readability</h3>\n)
          output << %(<p>Score: <strong>#{readability[:score]}</strong> (#{readability[:grade]})</p>\n)
          output << %(<p>Average sentence length: #{readability[:sentences][:avg_length]} words</p>\n)
          output << %(<p>Average paragraph length: #{readability[:paragraphs][:avg_length]} words</p>\n)

          # Statistics section
          stats = results[:stats]
          output << %(<h3>Statistics</h3>\n)
          output << %(<p>Word count: #{stats[:word_count]}</p>\n)
          output << %(<p>Reading time: #{stats[:reading_time]} minute#{stats[:reading_time] == 1 ? '' : 's'}</p>\n)
          output << %(<p>Headings: #{stats[:headings][:total]}</p>\n)
          output << %(<p>Links: #{stats[:links][:total]} (#{stats[:links][:internal]} internal, #{stats[:links][:external]} external)</p>\n)

          # Suggestions section
          if results[:suggestions].any?
            output << %(<h3>Suggestions</h3>\n)
            output << %(<ul>\n)

            results[:suggestions].each do |suggestion|
              output << %(<li>#{suggestion}</li>\n)
            end

            output << %(</ul>\n)
          end

          output << %(</div>\n)
        end
      end

      # Tag to output the sitemap URL
      class SitemapUrlTag < SeoTag
        def render_tag
          site_url = @site.config["url"] || ""
          base_url = @site.config["baseurl"] || ""

          File.join(site_url, base_url, "/sitemap.xml")
        end
      end

      # Tag to generate a sitemap preview
      class SitemapPreviewTag < SeoTag
        def render_tag
          sitemap = Jekyll::SEO::Sitemap.new(@site)
          data = sitemap.generate

          output = +%(<div class="sitemap-preview">\n)
          output << %(<h2>Sitemap Preview</h2>\n)
          output << %(<p>Total URLs: #{data[:total]}</p>\n)

          # Show a sample of entries
          limit = 10
          sample = data[:entries].take(limit)

          output << %(<table>\n)
          output << %(<tr><th>URL</th><th>Last Modified</th><th>Change Frequency</th><th>Priority</th></tr>\n)

          sample.each do |entry|
            output << %(<tr>)
            output << %(<td><a href="#{entry[:loc]}">#{entry[:loc]}</a></td>)
            output << %(<td>#{entry[:lastmod] || 'N/A'}</td>)
            output << %(<td>#{entry[:changefreq] || 'N/A'}</td>)
            output << %(<td>#{entry[:priority] || 'N/A'}</td>)
            output << %(</tr>\n)
          end

          output << %(</table>\n)

          if data[:total] > limit
            output << %(<p>Showing #{limit} of #{data[:total]} URLs</p>\n)
          end

          output << %(</div>\n)
        end
      end
    end

    # SEO Filters for Liquid templates
    module Filters
      # Generate JSON-LD structured data for a page
      def structured_data(page = nil)
        page ||= @context.registers[:page]
        site = @context.registers[:site]

        document = if page.is_a?(Jekyll::Document)
          page
        else
          find_document(page, site)
        end

        generator = Jekyll::SEO::StructuredData.new(document, site)
        generator.to_json
      end

      # Generate social media tags for a page
      def social_media_tags(page = nil)
        page ||= @context.registers[:page]
        site = @context.registers[:site]

        document = if page.is_a?(Jekyll::Document)
          page
        else
          find_document(page, site)
        end

        generator = Jekyll::SEO::SocialMedia.new(document, site)
        generator.to_html
      end

      # Get readability score for text
      def readability_score(text)
        Jekyll::SEO::Utils.readability_score(text)
      end

      # Extract keywords from text
      def extract_keywords(text, limit = 10)
        Jekyll::SEO::Utils.extract_keywords(text, limit: limit.to_i)
      end

      # Slugify text for URLs
      def seo_slugify(text)
        Jekyll::SEO::Utils.slugify(text)
      end

      private

      # Find document in site by URL
      def find_document(page, site)
        url = page["url"]

        # Check in collections
        site.collections.each do |_, collection|
          collection.docs.each do |doc|
            return doc if doc.url == url
          end
        end

        # Create a wrapper if not found
        PageDocument.new(page, site)
      end

      # Class to wrap page data as a document
      class PageDocument
        attr_reader :data, :site

        def initialize(data, site)
          @data = data
          @site = site
        end

        def url
          @data["url"]
        end

        def content
          @data["content"]
        end

        def method_missing(method_name, *args)
          if @data.key?(method_name.to_s)
            @data[method_name.to_s]
          else
            super
          end
        end

        def respond_to_missing?(method_name, include_private = false)
          @data.key?(method_name.to_s) || super
        end
      end
    end
  end
end

# Register Liquid tags
Liquid::Template.register_tag("structured_data", Jekyll::SEO::Tags::StructuredDataTag)
Liquid::Template.register_tag("social_media_tags", Jekyll::SEO::Tags::SocialMediaTag)
Liquid::Template.register_tag("seo_analysis", Jekyll::SEO::Tags::SeoAnalysisTag)
Liquid::Template.register_tag("content_analysis", Jekyll::SEO::Tags::ContentAnalysisTag)
Liquid::Template.register_tag("sitemap_url", Jekyll::SEO::Tags::SitemapUrlTag)
Liquid::Template.register_tag("sitemap_preview", Jekyll::SEO::Tags::SitemapPreviewTag)

# Register Liquid filters
Liquid::Template.register_filter(Jekyll::SEO::Filters)
