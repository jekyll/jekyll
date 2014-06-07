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

      # Paths to ignore for the watch option
      #
      # options - A Hash of options passed to the command
      #
      # Returns a list of relative paths from source that should be ignored
      def ignore_paths(options)
        source      = options['source']
        destination = options['destination']
        config_files = Configuration[options].config_files(options)
        paths = config_files + Array(destination)
        ignored = []

        source_abs = Pathname.new(source).expand_path
        paths.each do |p|
          path_abs = Pathname.new(p).expand_path
          begin
            rel_path = path_abs.relative_path_from(source_abs).to_s
            ignored << Regexp.new(Regexp.escape(rel_path)) unless rel_path.start_with?('../')
          rescue ArgumentError
            # Could not find a relative path
          end
        end
        ignored
      end

      # Run Site#process and catch errors
      #
      # site - the Jekyll::Site object
      #
      # Returns nothing
      def process_site(site)
        site.process
      rescue Jekyll::FatalException => e
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
        c.option 'config',  '--config CONFIG_FILE[,CONFIG_FILE2,...]', Array, 'Custom configuration file'
        c.option 'future',  '--future', 'Publishes posts with a future date'
        c.option 'limit_posts', '--limit_posts MAX_POSTS', Integer, 'Limits the number of posts to parse and publish'
        c.option 'watch',   '-w', '--watch', 'Watch for changes and rebuild'
        c.option 'force_polling', '--force_polling', 'Force watch to use polling'
        c.option 'lsi',     '--lsi', 'Use LSI for improved related posts'
        c.option 'show_drafts',  '-D', '--drafts', 'Render posts in the _drafts folder'
        c.option 'unpublished', '--unpublished', 'Render posts that were marked as unpublished'
        c.option 'quiet',   '-q', '--quiet', 'Silence output.'
        c.option 'verbose', '-V', '--verbose', 'Print verbose output.'
      end

    end

  end
end
