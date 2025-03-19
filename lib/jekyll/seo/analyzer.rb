# frozen_string_literal: true

module Jekyll
  module SEO
    # Analyze content for SEO optimization
    class Analyzer
      # Initialize a new Analyzer
      #
      # document - The Jekyll::Document, Jekyll::Page, or Jekyll::Post to analyze
      # site - The Jekyll::Site instance
      def initialize(document, site)
        @document = document
        @site = site
        @config = site.config["seo"] || {}
      end

      # Run all analysis checks
      #
      # Returns a Hash of analysis results
      def analyze
        results = {
          title: analyze_title,
          description: analyze_description,
          content: analyze_content,
          headings: analyze_headings,
          images: analyze_images,
          keywords: analyze_keywords,
          links: analyze_links,
          readability: analyze_readability,
          score: 0,
          recommendations: []
        }

        # Calculate overall score
        results[:score] = calculate_score(results)

        # Generate recommendations
        results[:recommendations] = generate_recommendations(results)

        results
      end

      private

      # Analyze the title for SEO best practices
      #
      # Returns a Hash with title analysis
      def analyze_title
        title = @document.data["title"].to_s

        result = {
          content: title,
          length: title.length,
          has_title: !title.empty?,
          too_short: title.length < 20,
          too_long: title.length > 60,
          contains_target_keyword: false,
          score: 0
        }

        # Check if title contains target keywords
        if @document.data["keywords"].is_a?(Array) && @document.data["keywords"].any?
          target_keywords = @document.data["keywords"].map(&:downcase)
          result[:contains_target_keyword] = target_keywords.any? { |kw| title.downcase.include?(kw) }
        end

        # Calculate score
        result[:score] = calculate_title_score(result)

        result
      end

      # Calculate score for title analysis
      #
      # result - The Hash title analysis result
      #
      # Returns an Integer score (0-100)
      def calculate_title_score(result)
        score = 0

        score += 40 if result[:has_title]
        score += 20 unless result[:too_short] || result[:too_long]
        score += 40 if result[:contains_target_keyword]

        [score, 100].min
      end

      # Analyze the meta description for SEO best practices
      #
      # Returns a Hash with description analysis
      def analyze_description
        description = @document.data["description"].to_s

        result = {
          content: description,
          length: description.length,
          has_description: !description.empty?,
          too_short: description.length < 50,
          too_long: description.length > 160,
          contains_target_keyword: false,
          score: 0
        }

        # Check if description contains target keywords
        if @document.data["keywords"].is_a?(Array) && @document.data["keywords"].any?
          target_keywords = @document.data["keywords"].map(&:downcase)
          result[:contains_target_keyword] = target_keywords.any? { |kw| description.downcase.include?(kw) }
        end

        # Calculate score
        result[:score] = calculate_description_score(result)

        result
      end

      # Calculate score for description analysis
      #
      # result - The Hash description analysis result
      #
      # Returns an Integer score (0-100)
      def calculate_description_score(result)
        score = 0

        score += 40 if result[:has_description]
        score += 20 unless result[:too_short] || result[:too_long]
        score += 40 if result[:contains_target_keyword]

        [score, 100].min
      end

      # Analyze the content for SEO best practices
      #
      # Returns a Hash with content analysis
      def analyze_content
        content = get_content

        result = {
          length: content.length,
          word_count: count_words(content),
          keyword_density: {},
          has_content: !content.empty?,
          too_short: count_words(content) < 300,
          score: 0
        }

        # Extract keywords and calculate density
        extracted_keywords = Jekyll::SEO::Utils.extract_keywords(content, limit: 10)
        total_words = result[:word_count].to_f

        extracted_keywords.each do |keyword|
          # Count occurrences of this keyword
          count = content.downcase.scan(/\b#{Regexp.escape(keyword)}\b/).size

          # Calculate density as percentage
          density = (count / total_words * 100).round(2)
          result[:keyword_density][keyword] = {
            count: count,
            density: density,
            optimal: density.between?(0.5, 2.5)
          }
        end

        # Calculate score
        result[:score] = calculate_content_score(result)

        result
      end

      # Calculate score for content analysis
      #
      # result - The Hash content analysis result
      #
      # Returns an Integer score (0-100)
      def calculate_content_score(result)
        score = 0

        score += 40 if result[:has_content]
        score += 30 unless result[:too_short]

        # Check if keyword density is optimal
        optimal_keywords = result[:keyword_density].values.count { |k| k[:optimal] }
        total_keywords = [result[:keyword_density].size, 1].max

        score += (30 * optimal_keywords / total_keywords.to_f).round

        [score, 100].min
      end

      # Analyze the headings structure
      #
      # Returns a Hash with headings analysis
      def analyze_headings
        content = get_content

        # Extract headings
        h1_tags = content.scan(/<h1[^>]*>(.*?)<\/h1>/i).flatten
        h2_tags = content.scan(/<h2[^>]*>(.*?)<\/h2>/i).flatten
        h3_tags = content.scan(/<h3[^>]*>(.*?)<\/h3>/i).flatten

        result = {
          h1: {
            count: h1_tags.size,
            items: h1_tags
          },
          h2: {
            count: h2_tags.size,
            items: h2_tags
          },
          h3: {
            count: h3_tags.size,
            items: h3_tags
          },
          has_h1: h1_tags.any?,
          has_multiple_h1: h1_tags.size > 1,
          has_h2: h2_tags.any?,
          has_h3: h3_tags.any?,
          score: 0
        }

        # Check if headings contain target keywords
        if @document.data["keywords"].is_a?(Array) && @document.data["keywords"].any?
          target_keywords = @document.data["keywords"].map(&:downcase)

          result[:h1][:has_keyword] = result[:h1][:items].any? do |h|
            target_keywords.any? { |kw| h.downcase.include?(kw) }
          end

          result[:h2][:has_keyword] = result[:h2][:items].any? do |h|
            target_keywords.any? { |kw| h.downcase.include?(kw) }
          end
        end

        # Calculate score
        result[:score] = calculate_headings_score(result)

        result
      end

      # Calculate score for headings analysis
      #
      # result - The Hash headings analysis result
      #
      # Returns an Integer score (0-100)
      def calculate_headings_score(result)
        score = 0

        score += 30 if result[:has_h1] && !result[:has_multiple_h1]
        score += 10 if result[:has_h2]
        score += 10 if result[:has_h3]
        score += 25 if result[:h1][:has_keyword]
        score += 25 if result[:h2][:has_keyword]

        # Penalize for multiple H1 tags
        score -= 20 if result[:has_multiple_h1]

        [score, 100].min
      end

      # Analyze images
      #
      # Returns a Hash with image analysis
      def analyze_images
        content = get_content

        # Extract images
        images = content.scan(/<img[^>]*>/i)

        # Parse image attributes
        image_data = images.map do |img|
          {
            src: img.match(/src=["'](.*?)["']/i)&.captures&.first,
            alt: img.match(/alt=["'](.*?)["']/i)&.captures&.first,
            title: img.match(/title=["'](.*?)["']/i)&.captures&.first
          }
        end

        result = {
          count: image_data.size,
          images: image_data,
          has_images: image_data.any?,
          alt_missing: image_data.count { |img| img[:alt].nil? || img[:alt].strip.empty? },
          score: 0
        }

        # Calculate score
        result[:score] = calculate_images_score(result)

        result
      end

      # Calculate score for image analysis
      #
      # result - The Hash images analysis result
      #
      # Returns an Integer score (0-100)
      def calculate_images_score(result)
        score = 0

        score += 50 if result[:has_images]

        # Check if all images have alt text
        if result[:has_images]
          alt_percentage = (result[:count] - result[:alt_missing]) / result[:count].to_f
          score += (50 * alt_percentage).round
        else
          score += 50 # No images doesn't necessarily mean bad SEO
        end

        [score, 100].min
      end

      # Analyze keywords
      #
      # Returns a Hash with keyword analysis
      def analyze_keywords
        content = get_content
        meta_keywords = @document.data["keywords"] || []

        # Extract keywords from content
        extracted_keywords = Jekyll::SEO::Utils.extract_keywords(content, limit: 15)

        result = {
          meta_keywords: meta_keywords,
          extracted_keywords: extracted_keywords,
          has_meta_keywords: meta_keywords.is_a?(Array) && meta_keywords.any?,
          meta_in_content: [],
          score: 0
        }

        # Check if meta keywords appear in content
        if result[:has_meta_keywords]
          result[:meta_in_content] = meta_keywords.select do |kw|
            content.downcase.include?(kw.to_s.downcase)
          end
        end

        # Calculate score
        result[:score] = calculate_keywords_score(result)

        result
      end

      # Calculate score for keyword analysis
      #
      # result - The Hash keywords analysis result
      #
      # Returns an Integer score (0-100)
      def calculate_keywords_score(result)
        score = 0

        score += 50 if result[:has_meta_keywords]

        # Check if meta keywords appear in content
        if result[:has_meta_keywords]
          meta_keywords_count = [result[:meta_keywords].size, 1].max.to_f
          meta_in_content_ratio = result[:meta_in_content].size / meta_keywords_count
          score += (50 * meta_in_content_ratio).round
        else
          score += 25 # No meta keywords is not as bad as having irrelevant ones
        end

        [score, 100].min
      end

      # Analyze links
      #
      # Returns a Hash with link analysis
      def analyze_links
        content = get_content

        # Extract links
        internal_links = []
        external_links = []

        content.scan(/<a[^>]*href=["'](.*?)["'][^>]*>(.*?)<\/a>/im).each do |url, _text|
          if url.start_with?('/') || url.include?(@site.config["url"].to_s)
            internal_links << url
          elsif url.start_with?('http') || url.start_with?('https')
            external_links << url
          end
        end

        result = {
          internal: {
            count: internal_links.size,
            links: internal_links
          },
          external: {
            count: external_links.size,
            links: external_links
          },
          total: internal_links.size + external_links.size,
          has_links: (internal_links.size + external_links.size) > 0,
          score: 0
        }

        # Calculate score
        result[:score] = calculate_links_score(result)

        result
      end

      # Calculate score for link analysis
      #
      # result - The Hash links analysis result
      #
      # Returns an Integer score (0-100)
      def calculate_links_score(result)
        score = 0

        score += 40 if result[:has_links]
        score += 30 if result[:internal][:count] > 0
        score += 30 if result[:external][:count] > 0

        # Penalize for too many links (over 100)
        score -= [(result[:total] - 100) / 10, 0].max if result[:total] > 100

        [score, 100].min
      end

      # Analyze readability
      #
      # Returns a Hash with readability analysis
      def analyze_readability
        content = get_plain_content

        readability = Jekyll::SEO::Utils.readability_score(content)

        result = {
          score: readability[:score],
          grade: readability[:grade],
          is_easy_to_read: readability[:score] >= 60
        }

        result
      end

      # Calculate the overall SEO score
      #
      # results - The Hash of all analysis results
      #
      # Returns an Integer score (0-100)
      def calculate_score(results)
        weights = {
          title: 15,
          description: 15,
          content: 20,
          headings: 15,
          images: 10,
          keywords: 10,
          links: 10,
          readability: 5
        }

        weighted_sum = weights.sum do |key, weight|
          weight * (results[key].is_a?(Hash) && results[key].key?(:score) ? results[key][:score] : 0) / 100.0
        end

        weighted_sum.round
      end

      # Generate recommendations based on analysis results
      #
      # results - The Hash of all analysis results
      #
      # Returns an Array of recommendation Strings
      def generate_recommendations(results)
        recommendations = []

        # Title recommendations
        if !results[:title][:has_title]
          recommendations << "Add a title to your page."
        elsif results[:title][:too_short]
          recommendations << "Your title is too short. Aim for 20-60 characters."
        elsif results[:title][:too_long]
          recommendations << "Your title is too long. Keep it under 60 characters."
        end

        unless results[:title][:contains_target_keyword]
          recommendations << "Include your target keyword in the page title."
        end

        # Description recommendations
        if !results[:description][:has_description]
          recommendations << "Add a meta description to your page."
        elsif results[:description][:too_short]
          recommendations << "Your meta description is too short. Aim for 50-160 characters."
        elsif results[:description][:too_long]
          recommendations << "Your meta description is too long. Keep it under 160 characters."
        end

        unless results[:description][:contains_target_keyword]
          recommendations << "Include your target keyword in the meta description."
        end

        # Content recommendations
        if results[:content][:too_short]
          recommendations << "Your content is too short. Aim for at least 300 words."
        end

        results[:content][:keyword_density].each do |keyword, data|
          unless data[:optimal]
            if data[:density] < 0.5
              recommendations << "The keyword '#{keyword}' appears too rarely. Aim for 0.5-2.5% keyword density."
            elsif data[:density] > 2.5
              recommendations << "The keyword '#{keyword}' appears too frequently. Avoid keyword stuffing."
            end
          end
        end

        # Heading recommendations
        if !results[:headings][:has_h1]
          recommendations << "Add an H1 heading to your page."
        elsif results[:headings][:has_multiple_h1]
          recommendations << "Use only one H1 heading per page."
        end

        unless results[:headings][:h1][:has_keyword]
          recommendations << "Include your target keyword in the H1 heading."
        end

        unless results[:headings][:has_h2]
          recommendations << "Use H2 headings to structure your content."
        end

        # Image recommendations
        if results[:images][:alt_missing] > 0
          recommendations << "Add alt text to #{results[:images][:alt_missing]} image(s)."
        end

        # Keyword recommendations
        unless results[:keywords][:has_meta_keywords]
          recommendations << "Add meta keywords to your page."
        end

        if results[:keywords][:has_meta_keywords] && results[:keywords][:meta_in_content].size < results[:keywords][:meta_keywords].size
          recommendations << "Make sure all your meta keywords appear in your content."
        end

        # Link recommendations
        unless results[:links][:has_links]
          recommendations << "Add links to your content to improve link structure."
        end

        if results[:links][:internal][:count] == 0
          recommendations << "Add internal links to connect your page with other pages on your site."
        end

        if results[:links][:external][:count] == 0
          recommendations << "Add external links to authoritative sources to improve credibility."
        end

        # Readability recommendations
        unless results[:readability][:is_easy_to_read]
          recommendations << "Improve the readability of your content. Current score: #{results[:readability][:score]}."
        end

        recommendations
      end

      # Helper method to get the content
      #
      # Returns the String content
      def get_content
        if @document.respond_to?(:content)
          @document.content
        elsif @document.respond_to?(:output)
          @document.output
        else
          ""
        end
      end

      # Helper method to get plain text content (without HTML)
      #
      # Returns the String content without HTML
      def get_plain_content
        get_content.gsub(/<\/?[^>]*>/, "")
      end

      # Helper method to count words in text
      #
      # text - The String text to count words in
      #
      # Returns the Integer word count
      def count_words(text)
        text.to_s.gsub(/<\/?[^>]*>/, "").split(/\s+/).size
      end
    end
  end
end
