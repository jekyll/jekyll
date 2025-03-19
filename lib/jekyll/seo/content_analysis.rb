# frozen_string_literal: true

module Jekyll
  module SEO
    # Analyze content for readability and quality
    class ContentAnalysis
      # Initialize a new ContentAnalysis
      #
      # document - The Jekyll::Document, Jekyll::Page, or Jekyll::Post to analyze
      # site - The Jekyll::Site instance
      def initialize(document, site)
        @document = document
        @site = site
        @config = site.config["seo"] || {}
      end

      # Run all content analysis checks
      #
      # Returns a Hash of analysis results
      def analyze
        content = get_content_text

        results = {
          readability: analyze_readability(content),
          sentiment: analyze_sentiment(content),
          stats: analyze_stats(content),
          suggestions: []
        }

        # Generate suggestions
        results[:suggestions] = generate_suggestions(results)

        results
      end

      # Get readability metrics
      #
      # Returns a Hash of readability metrics
      def analyze_readability(content)
        # Get readability score from Utils
        readability = Jekyll::SEO::Utils.readability_score(content)

        # Get sentence length stats
        sentences = split_into_sentences(content)
        total_sentences = sentences.size

        if total_sentences > 0
          avg_sentence_length = count_words(content) / total_sentences.to_f
          long_sentences = sentences.count { |s| count_words(s) > 20 }
          long_sentence_percentage = (long_sentences / total_sentences.to_f * 100).round(1)
        else
          avg_sentence_length = 0
          long_sentences = 0
          long_sentence_percentage = 0
        end

        # Get paragraph length stats
        paragraphs = split_into_paragraphs(content)
        total_paragraphs = paragraphs.size

        if total_paragraphs > 0
          avg_paragraph_length = count_words(content) / total_paragraphs.to_f
          long_paragraphs = paragraphs.count { |p| count_words(p) > 100 }
          long_paragraph_percentage = (long_paragraphs / total_paragraphs.to_f * 100).round(1)
        else
          avg_paragraph_length = 0
          long_paragraphs = 0
          long_paragraph_percentage = 0
        end

        {
          score: readability[:score],
          grade: readability[:grade],
          is_easy_to_read: readability[:score] >= 60,
          sentences: {
            total: total_sentences,
            avg_length: avg_sentence_length.round(1),
            long_sentences: long_sentences,
            long_sentence_percentage: long_sentence_percentage
          },
          paragraphs: {
            total: total_paragraphs,
            avg_length: avg_paragraph_length.round(1),
            long_paragraphs: long_paragraphs,
            long_paragraph_percentage: long_paragraph_percentage
          }
        }
      end

      # Analyze the sentiment of the content
      #
      # Returns a Hash with sentiment analysis
      def analyze_sentiment(content)
        # Very basic sentiment analysis
        # Count positive and negative words
        positive_words = %w(
          good great excellent amazing awesome best wonderful fantastic incredible
          brilliant outstanding superb exceptional remarkable splendid magnificent
          terrific fabulous stellar top wonderful exciting love happy joy beneficial
          effective efficient valuable useful helpful perfect ideal optimal improved
          advantage quality successful accomplish achieve excel enhance boost
        )

        negative_words = %w(
          bad worse worst terrible horrible awful disappointing dreadful poor inferior
          mediocre subpar weak inadequate deficient unsatisfactory defective flawed
          broken damaged incomplete unreliable frustrating annoying irritating useless
          pointless waste difficulty problem issue error mistake failure fail difficult
          complicated confused confusing mess complex hard trouble struggle impossible
        )

        words = content.downcase.scan(/\b[a-z]+\b/)
        positive_count = words.count { |word| positive_words.include?(word) }
        negative_count = words.count { |word| negative_words.include?(word) }
        total_sentiment_words = positive_count + negative_count

        # Avoid division by zero
        sentiment_score = if total_sentiment_words > 0
          ((positive_count / total_sentiment_words.to_f) * 100).round(1)
        else
          50 # Neutral if no sentiment words found
        end

        # Determine sentiment category
        sentiment = case sentiment_score
                    when 0...30 then "Negative"
                    when 30...45 then "Somewhat Negative"
                    when 45...55 then "Neutral"
                    when 55...70 then "Somewhat Positive"
                    else "Positive"
                    end

        {
          score: sentiment_score,
          sentiment: sentiment,
          positive_words: positive_count,
          negative_words: negative_count
        }
      end

      # Analyze content statistics
      #
      # Returns a Hash with content statistics
      def analyze_stats(content)
        words = count_words(content)
        sentences = split_into_sentences(content)
        paragraphs = split_into_paragraphs(content)

        # Calculate reading time (average reading speed: 200 words per minute)
        reading_time_minutes = (words / 200.0).ceil

        # Get headings
        headings = extract_headings(get_content)

        # Get links
        links = extract_links(get_content)

        # Get transition words
        transition_words = %w(
          also besides furthermore likewise moreover similarly although even
          though however nevertheless on_the_other_hand still yet after before
          during meanwhile soon thereafter when while because consequently hence
          so therefore thus for example in_fact specifically
        )

        transition_word_count = 0
        content.downcase.scan(/\b[a-z_]+\b/).each do |word|
          transition_word_count += 1 if transition_words.include?(word)
        end

        transition_percentage = words > 0 ? (transition_word_count / words.to_f * 100).round(1) : 0

        {
          word_count: words,
          sentence_count: sentences.size,
          paragraph_count: paragraphs.size,
          reading_time: reading_time_minutes,
          headings: {
            total: headings.values.sum { |h| h.size },
            distribution: headings
          },
          links: {
            total: links[:internal].size + links[:external].size,
            internal: links[:internal].size,
            external: links[:external].size
          },
          transition_words: {
            count: transition_word_count,
            percentage: transition_percentage
          }
        }
      end

      # Generate suggestions based on content analysis
      #
      # results - The Hash of analysis results
      #
      # Returns an Array of suggestion Strings
      def generate_suggestions(results)
        suggestions = []

        # Readability suggestions
        readability = results[:readability]
        if readability[:score] < 60
          suggestions << "Improve content readability. Current score: #{readability[:score]} (#{readability[:grade]})."
        end

        if readability[:sentences][:long_sentence_percentage] > 30
          suggestions << "Too many long sentences (#{readability[:sentences][:long_sentence_percentage]}% of sentences are over 20 words). Try breaking them down into shorter sentences."
        end

        if readability[:paragraphs][:long_paragraph_percentage] > 30
          suggestions << "Too many long paragraphs (#{readability[:paragraphs][:long_paragraph_percentage]}% of paragraphs are over 100 words). Try breaking them down into smaller paragraphs."
        end

        # Content structure suggestions
        stats = results[:stats]

        if stats[:headings][:total] == 0
          suggestions << "Add headings to structure your content better."
        elsif stats[:headings][:distribution][1].nil? || stats[:headings][:distribution][1].empty?
          suggestions << "Add H1 heading to your content."
        elsif stats[:headings][:distribution][1].size > 1
          suggestions << "Multiple H1 headings detected. Use only one H1 heading per page."
        end

        if stats[:headings][:distribution][2].nil? || stats[:headings][:distribution][2].empty?
          suggestions << "Add H2 headings to structure your content into sections."
        end

        # Content length suggestions
        if stats[:word_count] < 300
          suggestions << "Content is too short (#{stats[:word_count]} words). Aim for at least 300 words for better SEO."
        end

        # Link suggestions
        if stats[:links][:total] == 0
          suggestions << "Add links to your content to improve link structure."
        end

        if stats[:links][:internal] == 0
          suggestions << "Add internal links to connect your page with other pages on your site."
        end

        if stats[:links][:external] == 0
          suggestions << "Add external links to authoritative sources to improve credibility."
        end

        # Transition word suggestions
        if stats[:transition_words][:percentage] < 5
          suggestions << "Use more transition words to improve content flow. Currently using #{stats[:transition_words][:percentage]}% transition words."
        end

        # Sentiment suggestions
        sentiment = results[:sentiment]
        if sentiment[:sentiment] == "Negative" || sentiment[:sentiment] == "Somewhat Negative"
          suggestions << "Your content has a #{sentiment[:sentiment].downcase} tone. Consider using more positive language if appropriate for your topic."
        end

        suggestions
      end

      private

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
      def get_content_text
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

      # Split text into sentences
      #
      # text - The String text to split
      #
      # Returns an Array of sentences
      def split_into_sentences(text)
        text.to_s.gsub(/<\/?[^>]*>/, "").split(/(?<=[.!?])\s+/)
      end

      # Split text into paragraphs
      #
      # text - The String text to split
      #
      # Returns an Array of paragraphs
      def split_into_paragraphs(text)
        text.to_s.gsub(/<\/?[^>]*>/, "").split(/\n\n+/)
      end

      # Extract headings from HTML content
      #
      # html - The String HTML content
      #
      # Returns a Hash of heading Arrays (key: heading level, value: Array of heading strings)
      def extract_headings(html)
        headings = {}

        # Extract h1-h6 tags
        (1..6).each do |level|
          headings[level] = html.scan(/<h#{level}[^>]*>(.*?)<\/h#{level}>/i).flatten
        end

        headings
      end

      # Extract links from HTML content
      #
      # html - The String HTML content
      #
      # Returns a Hash with internal and external links
      def extract_links(html)
        internal_links = []
        external_links = []

        html.scan(/<a[^>]*href=["'](.*?)["'][^>]*>(.*?)<\/a>/im).each do |url, _text|
          if url.start_with?('/') || url.include?(@site.config["url"].to_s)
            internal_links << url
          elsif url.start_with?('http') || url.start_with?('https')
            external_links << url
          end
        end

        {
          internal: internal_links,
          external: external_links
        }
      end
    end
  end
end
