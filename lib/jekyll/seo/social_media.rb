# frozen_string_literal: true

module Jekyll
  module SEO
    # Generate social media meta tags for various platforms
    class SocialMedia
      # Initialize a new SocialMedia generator
      #
      # document - The Jekyll::Document, Jekyll::Page, or Jekyll::Post to generate tags for
      # site - The Jekyll::Site instance
      def initialize(document, site)
        @document = document
        @site = site
        @config = site.config["seo"] || {}
      end

      # Generate all social media tags
      #
      # Returns a Hash with all social media tags
      def generate
        {
          open_graph: generate_open_graph,
          twitter: generate_twitter,
          pinterest: generate_pinterest,
          facebook: generate_facebook,
          linkedin: generate_linkedin
        }
      end

      # Generate a string with all social media meta tags
      #
      # Returns a String with HTML meta tags
      def to_html
        tags = []

        # Open Graph tags
        open_graph_tags = generate_open_graph
        open_graph_tags.each do |property, content|
          next if content.nil? || content.empty?
          tags << %Q(<meta property="#{property}" content="#{escape_content(content)}" />)
        end

        # Twitter Card tags
        twitter_tags = generate_twitter
        twitter_tags.each do |name, content|
          next if content.nil? || content.empty?
          tags << %Q(<meta name="#{name}" content="#{escape_content(content)}" />)
        end

        # Pinterest tag
        pinterest_tag = generate_pinterest[:verification]
        if pinterest_tag && !pinterest_tag.empty?
          tags << %Q(<meta name="p:domain_verify" content="#{escape_content(pinterest_tag)}" />)
        end

        # Facebook tag
        facebook_tags = generate_facebook
        if facebook_tags[:app_id] && !facebook_tags[:app_id].empty?
          tags << %Q(<meta property="fb:app_id" content="#{escape_content(facebook_tags[:app_id])}" />)
        end

        # LinkedIn tag
        linkedin_tag = generate_linkedin[:article]
        if linkedin_tag && !linkedin_tag.empty?
          tags << %Q(<meta name="article:publisher" content="#{escape_content(linkedin_tag)}" />)
        end

        tags.join("\n")
      end

      private

      # Generate Open Graph meta tags
      #
      # Returns a Hash of Open Graph tags
      def generate_open_graph
        title = @document.data["title"] || @site.config["title"]
        description = @document.data["description"] || extract_description
        image = get_image_url
        type = determine_og_type

        tags = {
          "og:title" => title,
          "og:description" => description,
          "og:url" => get_canonical_url,
          "og:type" => type,
          "og:site_name" => @site.config["title"]
        }

        # Add image if available
        if image
          tags["og:image"] = image
          tags["og:image:alt"] = @document.data["image_alt"] || title
        end

        # Add locale if available
        locale = @document.data["locale"] || @site.config["locale"] || "en_US"
        tags["og:locale"] = locale

        # Add article specific tags
        if type == "article"
          # Add published time
          if @document.data["date"]
            tags["article:published_time"] = @document.data["date"].iso8601
          end

          # Add modified time
          if @document.data["last_modified_at"]
            tags["article:modified_time"] = @document.data["last_modified_at"].iso8601
          end

          # Add author
          if @document.data["author"]
            author = @document.data["author"]
            author_name = author.is_a?(Hash) ? author["name"] : author
            tags["article:author"] = author_name
          end

          # Add tags/categories
          if @document.data["tags"]&.any?
            @document.data["tags"].each_with_index do |tag, index|
              tags["article:tag:#{index}"] = tag
            end
          end

          if @document.data["categories"]&.any?
            @document.data["categories"].each_with_index do |category, index|
              tags["article:section:#{index}"] = category
            end
          end
        end

        tags
      end

      # Generate Twitter Card meta tags
      #
      # Returns a Hash of Twitter Card tags
      def generate_twitter
        title = @document.data["title"] || @site.config["title"]
        description = @document.data["description"] || extract_description
        image = get_image_url

        # Determine card type
        card_type = "summary"
        if image && @document.data["twitter_large_card"]
          card_type = "summary_large_image"
        end

        tags = {
          "twitter:card" => card_type,
          "twitter:title" => title,
          "twitter:description" => description
        }

        # Add image if available
        if image
          tags["twitter:image"] = image
          tags["twitter:image:alt"] = @document.data["image_alt"] || title
        end

        # Add site and creator handles if available
        twitter_config = @config["twitter"] || {}

        if twitter_config["username"]
          tags["twitter:site"] = "@#{twitter_config["username"].sub(/^@/, "")}"
        end

        if @document.data["author_twitter"]
          tags["twitter:creator"] = "@#{@document.data["author_twitter"].sub(/^@/, "")}"
        elsif twitter_config["username"] && !@document.data["hide_author"]
          tags["twitter:creator"] = "@#{twitter_config["username"].sub(/^@/, "")}"
        end

        tags
      end

      # Generate Pinterest verification meta tag
      #
      # Returns a Hash with Pinterest verification tag
      def generate_pinterest
        pinterest_config = @config["pinterest"] || {}

        {
          verification: pinterest_config["verification"]
        }
      end

      # Generate Facebook meta tags
      #
      # Returns a Hash with Facebook meta tags
      def generate_facebook
        facebook_config = @config["facebook"] || {}

        {
          app_id: facebook_config["app_id"]
        }
      end

      # Generate LinkedIn meta tags
      #
      # Returns a Hash with LinkedIn meta tags
      def generate_linkedin
        linkedin_config = @config["linkedin"] || {}

        {
          article: linkedin_config["article_publisher"]
        }
      end

      # Determine Open Graph type based on document type
      #
      # Returns a String with OG type
      def determine_og_type
        # Use explicit og:type if provided
        return @document.data["og_type"] if @document.data["og_type"]

        # Is this a post/article?
        if @document.is_a?(Jekyll::Document) && @document.collection.label == "posts"
          "article"
        # Is this a profile page?
        elsif @document.data["layout"] == "profile" || @document.data["profile"]
          "profile"
        # Default to website
        else
          "website"
        end
      end

      # Helper to get the document's URL
      #
      # Returns a String URL
      def get_canonical_url
        site_url = @site.config["url"] || ""
        base_url = @site.config["baseurl"] || ""

        document_url = if @document.is_a?(Jekyll::Document)
          @document.url
        elsif @document.respond_to?(:url)
          @document.url
        else
          ""
        end

        # Ensure the URL is absolute
        if document_url.start_with?("http")
          document_url
        else
          File.join(site_url, base_url, document_url)
        end
      end

      # Helper to get the document's image URL
      #
      # Returns a String URL or nil
      def get_image_url
        image = @document.data["image"] || @document.data["og_image"] || @document.data["twitter_image"]

        return nil unless image

        site_url = @site.config["url"] || ""
        base_url = @site.config["baseurl"] || ""

        # Image can be a URL or a path
        if image.start_with?("http")
          image
        else
          File.join(site_url, base_url, image)
        end
      end

      # Helper to extract a description from content
      #
      # Returns a String description
      def extract_description
        if @document.respond_to?(:content)
          text = @document.content.gsub(/<\/?[^>]*>/, "")

          # Get first paragraph
          first_paragraph = text.split(/\n\n/).first

          # Truncate to a reasonable length
          if first_paragraph && first_paragraph.length > 160
            "#{first_paragraph[0...157]}..."
          else
            first_paragraph
          end
        else
          @site.config["description"] || ""
        end
      end

      # Helper to escape content for HTML attributes
      #
      # content - The String content to escape
      #
      # Returns a String with escaped content
      def escape_content(content)
        content.to_s
               .gsub("&", "&amp;")
               .gsub("<", "&lt;")
               .gsub(">", "&gt;")
               .gsub('"', "&quot;")
               .gsub("'", "&#39;")
      end
    end
  end
end
