# frozen_string_literal: true

module Jekyll
  module SEO
    # Generate structured data (JSON-LD) for various content types
    class StructuredData
      # Initialize a new StructuredData generator
      #
      # document - The Jekyll::Document, Jekyll::Page, or Jekyll::Post to generate structured data for
      # site - The Jekyll::Site instance
      def initialize(document, site)
        @document = document
        @site = site
        @config = site.config["seo"] || {}
      end

      # Generate structured data for the document
      #
      # Returns a Hash of structured data
      def generate
        schema_type = determine_schema_type

        case schema_type
        when "BlogPosting"
          generate_blog_posting
        when "Article"
          generate_article
        when "WebPage"
          generate_web_page
        when "ItemList"
          generate_item_list
        when "CollectionPage"
          generate_collection_page
        when "Person"
          generate_person
        when "Organization"
          generate_organization
        when "Product"
          generate_product
        when "FAQ"
          generate_faq
        when "HowTo"
          generate_how_to
        else
          generate_web_page # Default to WebPage
        end
      end

      # Generate JSON-LD string for the document
      #
      # Returns a String of JSON-LD
      def to_json
        require "json"
        JSON.pretty_generate(generate)
      end

      private

      # Determine the schema type based on document properties
      #
      # Returns a String schema type
      def determine_schema_type
        # Use explicit schema type if provided
        return @document.data["schema_type"] if @document.data["schema_type"]

        # Is this a post/article?
        if @document.is_a?(Jekyll::Document) && @document.collection.label == "posts"
          "BlogPosting"
        # Is this a collection page?
        elsif @document.is_a?(Jekyll::Document) && @document.collection.label != "posts"
          "CollectionPage"
        # Is this an index page for a collection?
        elsif @document.data["layout"] == "collection" || @document.data["is_collection_index"]
          "ItemList"
        # Is this a person page?
        elsif @document.data["layout"] == "person" || @document.data["person"]
          "Person"
        # Is this an organization page?
        elsif @document.data["layout"] == "organization" || @document.data["organization"]
          "Organization"
        # Is this a product page?
        elsif @document.data["layout"] == "product" || @document.data["product"]
          "Product"
        # Is this a FAQ page?
        elsif @document.data["layout"] == "faq" || @document.data["faq"]
          "FAQ"
        # Is this a How-To page?
        elsif @document.data["layout"] == "howto" || @document.data["howto"]
          "HowTo"
        # Default to WebPage
        else
          "WebPage"
        end
      end

      # Generate BlogPosting schema
      #
      # Returns a Hash of structured data
      def generate_blog_posting
        {
          "@context" => "https://schema.org",
          "@type" => "BlogPosting",
          "mainEntityOfPage" => {
            "@type" => "WebPage",
            "@id" => get_canonical_url
          },
          "headline" => @document.data["title"],
          "description" => @document.data["description"] || extract_description,
          "image" => get_image_url,
          "author" => get_author,
          "publisher" => get_publisher,
          "datePublished" => get_date_published,
          "dateModified" => get_date_modified,
          "keywords" => get_keywords,
          "articleBody" => get_content_text
        }.compact
      end

      # Generate Article schema
      #
      # Returns a Hash of structured data
      def generate_article
        {
          "@context" => "https://schema.org",
          "@type" => "Article",
          "mainEntityOfPage" => {
            "@type" => "WebPage",
            "@id" => get_canonical_url
          },
          "headline" => @document.data["title"],
          "description" => @document.data["description"] || extract_description,
          "image" => get_image_url,
          "author" => get_author,
          "publisher" => get_publisher,
          "datePublished" => get_date_published,
          "dateModified" => get_date_modified,
          "keywords" => get_keywords,
          "articleBody" => get_content_text
        }.compact
      end

      # Generate WebPage schema
      #
      # Returns a Hash of structured data
      def generate_web_page
        {
          "@context" => "https://schema.org",
          "@type" => "WebPage",
          "url" => get_canonical_url,
          "name" => @document.data["title"],
          "description" => @document.data["description"] || extract_description,
          "image" => get_image_url,
          "inLanguage" => get_language,
          "datePublished" => get_date_published,
          "dateModified" => get_date_modified,
          "author" => get_author,
          "publisher" => get_publisher,
          "potentialAction" => {
            "@type" => "ReadAction",
            "target" => get_canonical_url
          }
        }.compact
      end

      # Generate ItemList schema for collections
      #
      # Returns a Hash of structured data
      def generate_item_list
        items = []

        # Get collection items if available
        collection_name = @document.data["collection"] || @document.data["collection_name"]
        collection = @site.collections[collection_name] if collection_name

        if collection&.docs&.any?
          items = collection.docs.map.with_index do |doc, index|
            {
              "@type" => "ListItem",
              "position" => index + 1,
              "url" => get_page_url(doc),
              "name" => doc.data["title"],
              "description" => doc.data["description"] || extract_description_from(doc)
            }
          end
        end

        {
          "@context" => "https://schema.org",
          "@type" => "ItemList",
          "url" => get_canonical_url,
          "name" => @document.data["title"],
          "description" => @document.data["description"] || extract_description,
          "numberOfItems" => items.size,
          "itemListElement" => items
        }.compact
      end

      # Generate CollectionPage schema
      #
      # Returns a Hash of structured data
      def generate_collection_page
        {
          "@context" => "https://schema.org",
          "@type" => "CollectionPage",
          "url" => get_canonical_url,
          "name" => @document.data["title"],
          "description" => @document.data["description"] || extract_description,
          "image" => get_image_url,
          "inLanguage" => get_language,
          "datePublished" => get_date_published,
          "dateModified" => get_date_modified,
          "author" => get_author,
          "publisher" => get_publisher
        }.compact
      end

      # Generate Person schema
      #
      # Returns a Hash of structured data
      def generate_person
        person_data = @document.data["person"] || {}

        {
          "@context" => "https://schema.org",
          "@type" => "Person",
          "name" => person_data["name"] || @document.data["title"],
          "description" => person_data["description"] || @document.data["description"] || extract_description,
          "image" => person_data["image"] || get_image_url,
          "url" => get_canonical_url,
          "email" => person_data["email"],
          "telephone" => person_data["telephone"],
          "jobTitle" => person_data["job_title"],
          "worksFor" => person_data["works_for"] ? { "@type" => "Organization", "name" => person_data["works_for"] } : nil,
          "sameAs" => person_data["social_profiles"]
        }.compact
      end

      # Generate Organization schema
      #
      # Returns a Hash of structured data
      def generate_organization
        org_data = @document.data["organization"] || {}

        {
          "@context" => "https://schema.org",
          "@type" => "Organization",
          "name" => org_data["name"] || @document.data["title"],
          "description" => org_data["description"] || @document.data["description"] || extract_description,
          "url" => get_canonical_url,
          "logo" => org_data["logo"] || get_image_url,
          "email" => org_data["email"],
          "telephone" => org_data["telephone"],
          "address" => org_data["address"] ? {
            "@type" => "PostalAddress",
            "streetAddress" => org_data["address"]["street"],
            "addressLocality" => org_data["address"]["city"],
            "addressRegion" => org_data["address"]["region"],
            "postalCode" => org_data["address"]["postal_code"],
            "addressCountry" => org_data["address"]["country"]
          } : nil,
          "sameAs" => org_data["social_profiles"]
        }.compact
      end

      # Generate Product schema
      #
      # Returns a Hash of structured data
      def generate_product
        product_data = @document.data["product"] || {}

        {
          "@context" => "https://schema.org",
          "@type" => "Product",
          "name" => product_data["name"] || @document.data["title"],
          "description" => product_data["description"] || @document.data["description"] || extract_description,
          "image" => product_data["image"] || get_image_url,
          "url" => get_canonical_url,
          "sku" => product_data["sku"],
          "mpn" => product_data["mpn"],
          "brand" => product_data["brand"] ? { "@type" => "Brand", "name" => product_data["brand"] } : nil,
          "offers" => product_data["price"] ? {
            "@type" => "Offer",
            "price" => product_data["price"],
            "priceCurrency" => product_data["currency"] || "USD",
            "availability" => product_data["availability"] || "https://schema.org/InStock",
            "url" => get_canonical_url
          } : nil,
          "aggregateRating" => product_data["rating"] ? {
            "@type" => "AggregateRating",
            "ratingValue" => product_data["rating"],
            "reviewCount" => product_data["review_count"] || 1
          } : nil
        }.compact
      end

      # Generate FAQ schema
      #
      # Returns a Hash of structured data
      def generate_faq
        faq_data = @document.data["faq"] || []

        {
          "@context" => "https://schema.org",
          "@type" => "FAQPage",
          "mainEntity" => faq_data.map do |item|
            {
              "@type" => "Question",
              "name" => item["question"],
              "acceptedAnswer" => {
                "@type" => "Answer",
                "text" => item["answer"]
              }
            }
          end
        }
      end

      # Generate HowTo schema
      #
      # Returns a Hash of structured data
      def generate_how_to
        howto_data = @document.data["howto"] || {}
        steps = howto_data["steps"] || []

        {
          "@context" => "https://schema.org",
          "@type" => "HowTo",
          "name" => howto_data["name"] || @document.data["title"],
          "description" => howto_data["description"] || @document.data["description"] || extract_description,
          "image" => howto_data["image"] || get_image_url,
          "totalTime" => howto_data["total_time"],
          "estimatedCost" => howto_data["estimated_cost"] ? {
            "@type" => "MonetaryAmount",
            "currency" => howto_data["estimated_cost"]["currency"] || "USD",
            "value" => howto_data["estimated_cost"]["value"]
          } : nil,
          "supply" => howto_data["supplies"]&.map { |supply| { "@type" => "HowToSupply", "name" => supply } },
          "tool" => howto_data["tools"]&.map { |tool| { "@type" => "HowToTool", "name" => tool } },
          "step" => steps.map.with_index do |step, index|
            {
              "@type" => "HowToStep",
              "position" => index + 1,
              "name" => step["name"],
              "text" => step["text"],
              "image" => step["image"],
              "url" => step["url"]
            }.compact
          end
        }.compact
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

      # Helper to get URL for another page
      #
      # page - The Jekyll page to get URL for
      #
      # Returns a String URL
      def get_page_url(page)
        site_url = @site.config["url"] || ""
        base_url = @site.config["baseurl"] || ""

        page_url = page.url

        # Ensure the URL is absolute
        if page_url.start_with?("http")
          page_url
        else
          File.join(site_url, base_url, page_url)
        end
      end

      # Helper to get the document's image URL
      #
      # Returns a String URL or nil
      def get_image_url
        image = @document.data["image"]

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

      # Helper to get the document's author
      #
      # Returns a Hash author object or nil
      def get_author
        author_data = @document.data["author"]

        return nil unless author_data

        if author_data.is_a?(String)
          {
            "@type" => "Person",
            "name" => author_data
          }
        elsif author_data.is_a?(Hash)
          {
            "@type" => "Person",
            "name" => author_data["name"],
            "url" => author_data["url"],
            "image" => author_data["image"]
          }.compact
        end
      end

      # Helper to get the site's publisher
      #
      # Returns a Hash publisher object
      def get_publisher
        publisher_data = @site.config["seo"]&.dig("publisher") || {}

        {
          "@type" => "Organization",
          "name" => publisher_data["name"] || @site.config["title"],
          "logo" => {
            "@type" => "ImageObject",
            "url" => publisher_data["logo"] || File.join(@site.config["url"] || "", @site.config["baseurl"] || "", "logo.png")
          }
        }
      end

      # Helper to get the document's publication date
      #
      # Returns a String date in ISO 8601 format or nil
      def get_date_published
        date = @document.data["date"]

        return nil unless date

        date.iso8601
      rescue
        nil
      end

      # Helper to get the document's modification date
      #
      # Returns a String date in ISO 8601 format or nil
      def get_date_modified
        date = @document.data["last_modified_at"] || @document.data["date"]

        return nil unless date

        date.iso8601
      rescue
        nil
      end

      # Helper to get the document's keywords
      #
      # Returns an Array of String keywords or nil
      def get_keywords
        keywords = @document.data["keywords"] || @document.data["tags"]

        return nil unless keywords&.any?

        keywords.join(", ")
      end

      # Helper to get the document's language
      #
      # Returns a String language code
      def get_language
        @document.data["language"] || @site.config["language"] || "en-US"
      end

      # Helper to get plain text content
      #
      # Returns a String of content text
      def get_content_text
        if @document.respond_to?(:content)
          @document.content.gsub(/<\/?[^>]*>/, "")
        elsif @document.respond_to?(:output)
          @document.output.gsub(/<\/?[^>]*>/, "")
        else
          ""
        end
      end

      # Helper to extract a description from content
      #
      # Returns a String description
      def extract_description
        text = get_content_text

        # Get first paragraph
        first_paragraph = text.split(/\n\n/).first

        # Truncate to a reasonable length
        if first_paragraph && first_paragraph.length > 160
          "#{first_paragraph[0...157]}..."
        else
          first_paragraph
        end
      end

      # Helper to extract a description from another document
      #
      # doc - The Jekyll document to extract from
      #
      # Returns a String description
      def extract_description_from(doc)
        return doc.data["description"] if doc.data["description"]

        if doc.respond_to?(:content)
          text = doc.content.gsub(/<\/?[^>]*>/, "")

          # Get first paragraph
          first_paragraph = text.split(/\n\n/).first

          # Truncate to a reasonable length
          if first_paragraph && first_paragraph.length > 160
            "#{first_paragraph[0...157]}..."
          else
            first_paragraph
          end
        else
          ""
        end
      end
    end
  end
end
