# frozen_string_literal: true

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
        return options if options.is_a?(Jekyll::Configuration)
        Jekyll.configuration(options)
      end

      # Add common options to a command for building configuration
      #
      # cmd - the Jekyll::Command to add these options to
      #
      # Returns nothing
      # rubocop:disable Metrics/MethodLength
      def add_build_options(cmd)
        cmd.option "config", "--config CONFIG_FILE[,CONFIG_FILE2,...]",
          Array, "Custom configuration file"
        cmd.option "destination", "-d", "--destination DESTINATION",
          "The current folder will be generated into DESTINATION"
        cmd.option "source", "-s", "--source SOURCE", "Custom source directory"
        cmd.option "future", "--future", "Publishes posts with a future date"
        cmd.option "limit_posts", "--limit_posts MAX_POSTS", Integer,
          "Limits the number of posts to parse and publish"
        cmd.option "watch", "-w", "--[no-]watch", "Watch for changes and rebuild"
        cmd.option "baseurl", "-b", "--baseurl URL",
          "Serve the website from the given base URL"
        cmd.option "force_polling", "--force_polling", "Force watch to use polling"
        cmd.option "lsi", "--lsi", "Use LSI for improved related posts"
        cmd.option "show_drafts", "-D", "--drafts", "Render posts in the _drafts folder"
        cmd.option "unpublished", "--unpublished",
          "Render posts that were marked as unpublished"
        cmd.option "quiet", "-q", "--quiet", "Silence output."
        cmd.option "verbose", "-V", "--verbose", "Print verbose output."
        cmd.option "incremental", "-I", "--incremental", "Enable incremental rebuild."
        cmd.option "strict_front_matter", "--strict_front_matter",
          "Fail if errors are present in front matter"
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
