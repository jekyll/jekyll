# frozen_string_literal: true

module Jekyll
  module SEO
    # Utility methods for SEO functionality
    module Utils
      # Extract keywords from text
      #
      # text - The String text to analyze
      # options - A Hash of options (default: {})
      #
      # Returns an Array of keyword Strings
      def self.extract_keywords(text, options = {})
        return [] if text.nil? || text.empty?

        # Remove HTML tags and convert to lowercase
        clean_text = text.to_s.gsub(/<\/?[^>]*>/, "").downcase

        # Split by non-word characters and filter out stop words and short words
        words = clean_text.split(/\W+/).reject do |word|
          word.length < 3 || stop_words.include?(word)
        end

        # Count word frequencies
        word_counts = Hash.new(0)
        words.each { |word| word_counts[word] += 1 }

        # Sort by frequency (descending) and take top N keywords
        limit = options[:limit] || 10
        word_counts.sort_by { |_word, count| -count }.take(limit).map(&:first)
      end

      # Check if a URL is valid
      #
      # url - The String URL to check
      #
      # Returns a Boolean
      def self.valid_url?(url)
        uri = URI.parse(url)
        uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      rescue URI::InvalidURIError
        false
      end

      # Generate a URL-friendly slug
      #
      # string - The String to slugify
      #
      # Returns a String
      def self.slugify(string)
        return "" if string.nil? || string.empty?

        # Remove non-alphanumeric characters, replace spaces with hyphens
        string.to_s.downcase
              .gsub(/[^\w\s-]/, "")
              .gsub(/[\s_]+/, "-")
              .gsub(/^-|-$/, "")
      end

      # Get common English stop words
      #
      # Returns an Array of stop words
      def self.stop_words
        @stop_words ||= %w(
          a about above after again against all am an and any are aren't as at be
          because been before being below between both but by can't cannot could
          couldn't did didn't do does doesn't doing don't down during each few for
          from further had hadn't has hasn't have haven't having he he'd he'll he's
          her here here's hers herself him himself his how how's i i'd i'll i'm i've
          if in into is isn't it it's its itself let's me more most mustn't my myself
          no nor not of off on once only or other ought our ours ourselves out over
          own same shan't she she'd she'll she's should shouldn't so some such than
          that that's the their theirs them themselves then there there's these they
          they'd they'll they're they've this those through to too under until up
          very was wasn't we we'd we'll we're we've were weren't what what's when
          when's where where's which while who who's whom why why's with won't would
          wouldn't you you'd you'll you're you've your yours yourself yourselves
        )
      end

      # Calculate readability score using Flesch-Kincaid readability test
      #
      # text - The String text to analyze
      #
      # Returns a Hash with readability scores
      def self.readability_score(text)
        return { score: 0, grade: "Unknown" } if text.nil? || text.empty?

        # Remove HTML tags
        clean_text = text.to_s.gsub(/<\/?[^>]*>/, "")

        # Count sentences, words, and syllables
        sentences = clean_text.split(/[.!?]/).reject(&:empty?).size
        words = clean_text.split(/\s+/).reject(&:empty?).size
        syllables = count_syllables(clean_text)

        # Avoid division by zero
        return { score: 0, grade: "Unknown" } if sentences == 0 || words == 0

        # Calculate Flesch-Kincaid Reading Ease
        score = 206.835 - (1.015 * (words.to_f / sentences)) - (84.6 * (syllables.to_f / words))
        score = [0, [score, 100].min].max # Clamp between 0 and 100

        # Determine grade level based on score
        grade = case score
                when 90..100 then "Very Easy"
                when 80...90 then "Easy"
                when 70...80 then "Fairly Easy"
                when 60...70 then "Standard"
                when 50...60 then "Fairly Difficult"
                when 30...50 then "Difficult"
                else "Very Difficult"
                end

        { score: score.round(1), grade: grade }
      end

      # Estimate syllable count in text
      #
      # text - The String text to analyze
      #
      # Returns an Integer syllable count
      def self.count_syllables(text)
        return 0 if text.nil? || text.empty?

        # Split text into words
        words = text.to_s.downcase.gsub(/[^a-z\s]/, "").split(/\s+/)

        words.sum do |word|
          # Basic syllable counting algorithm
          count = word.gsub(/[^aeiouy]/, "").size

          # Adjust for common patterns
          count -= 1 if word.match?(/[aeiouy]e$/)
          count += 1 if word.match?(/^[^aeiouy]*e$/)
          count += 1 if word.match?(/[aeiouy]{3,}/)

          # Ensure at least one syllable per word
          [count, 1].max
        end
      end
    end
  end
end
