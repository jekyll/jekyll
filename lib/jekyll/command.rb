module Jekyll
  class Command
    class << self
      # A list of subclasses of Jekyll::Command
      def subclasses
        @subclasses ||= []
      end

      # Keep a list of subclasses of Jekyll::Command every time it's inherited
      # Called automatically.
      #
      # base - the subclass
      #
      # Returns nothing
      def inherited(base)
        subclasses << base
        super(base)
      end

      # Run Site#process and catch errors
      #
      # site - the Jekyll::Site object
      #
      # Returns nothing
      def process_site(site)
        site.process
      rescue Jekyll::Errors::FatalException => e
        Jekyll.logger.error "ERROR:", "YOUR SITE COULD NOT BE BUILT:"
        Jekyll.logger.error "", "------------------------------------"
        Jekyll.logger.error "", e.message
        exit(1)
      end

      # Create a full Jekyll configuration with the options passed in as overrides
      #
      # options - the configuration overrides
      #
      # Returns a full Jekyll configuration
      def configuration_from_options(options)
        Jekyll.configuration(options)
      end

      # Add common options to a command for building configuration
      #
      # c - the Jekyll::Command to add these options to
      #
      # Returns nothing
      def add_build_options(c)
        c.option "config", "--config CONFIG_FILE[,CONFIG_FILE2,...]",
          Array, "Custom configuration file"
        c.option "destination", "-d", "--destination DESTINATION",
          "The current folder will be generated into DESTINATION"
        c.option "source", "-s", "--source SOURCE", "Custom source directory"
        c.option "future", "--future", "Publishes posts with a future date"
        c.option "limit_posts", "--limit_posts MAX_POSTS", Integer,
          "Limits the number of posts to parse and publish"
        c.option "watch", "-w", "--[no-]watch", "Watch for changes and rebuild"
        c.option "baseurl", "-b", "--baseurl URL",
          "Serve the website from the given base URL"
        c.option "force_polling", "--force_polling", "Force watch to use polling"
        c.option "lsi", "--lsi", "Use LSI for improved related posts"
        c.option "show_drafts", "-D", "--drafts", "Render posts in the _drafts folder"
        c.option "unpublished", "--unpublished",
          "Render posts that were marked as unpublished"
        c.option "quiet", "-q", "--quiet", "Silence output."
        c.option "verbose", "-V", "--verbose", "Print verbose output."
        c.option "incremental", "-I", "--incremental", "Enable incremental rebuild."
      end
    end
  end
end
