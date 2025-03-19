# frozen_string_literal: true

module Jekyll
  module SEO
    # Base SEO module for Jekyll SEO functionality

    class << self
      # Initialize the SEO module
      #
      # site - The Jekyll::Site instance
      #
      # Returns nothing
      def init(site)
        @site = site
      end

      # Get the SEO configuration from the site config
      #
      # Returns the SEO configuration hash
      def config
        @site.config["seo"] || {}
      end
    end

    autoload :Analyzer, "jekyll/seo/analyzer"
    autoload :StructuredData, "jekyll/seo/structured_data"
    autoload :Sitemap, "jekyll/seo/sitemap"
    autoload :SocialMedia, "jekyll/seo/social_media"
    autoload :ContentAnalysis, "jekyll/seo/content_analysis"
    autoload :Utils, "jekyll/seo/utils"
  end

  # Register the SEO module with Jekyll
  Hooks.register :site, :after_init do |site|
    SEO.init(site)
  end
end
