module Jekyll
  # This helper gave you methods to create and manage all the
  # ```Jekyll::Deprecation``` instances, as well as process them for logging
  # and adjust the deprecation (if it need to be adjusted).
  class Deprecator

    # The message for auto-regeneration config deprecation
    AUTO_REGENERATION_MSG = "Auto-regeneration can no longer be set from your \
      configuration file(s). Use the --watch/-w command-line option \
      instead."
    # The message for the type changed config deprecations
    TYPE_CHANGED_MSG = "The ':key' configuration option must now be specified \
      as an array, but you specified a string. For now, we've treated the \
      string you provided as a list of comma-separated values."

    # List of config deprecation definitions, each item of the array is a hash
    # that is passed to Deprecation.new as the properties param value
    CONFIG_DEPRECATIONS = [
      {
        :subtype => :removed,
        :key  => 'auto',
        :msg  => AUTO_REGENERATION_MSG
      },
      {
        :subtype => :removed,
        :key => 'watch',
        :msg => AUTO_REGENERATION_MSG
      },
      {
        :subtype => :removed,
        :key => 'server',
        :msg => "The ':key' configuration option is no longer accepted. Use the 'jekyll serve' subcommand to serve your site with WEBrick."
      },
      {
        :subtype => :renamed,
        :key => 'server_port',
        :msg => "The ':key' configuration option has been renamed to ':new_key'. Please update your config file accordingly.",
        :new_key => 'port'
      },
      {
        :subtype => :type_changed,
        :key => 'include',
        :msg => TYPE_CHANGED_MSG,
        :old_type => String,
        :new_type => Array
      },
      {
        :subtype => :type_changed,
        :key => 'exclude',
        :msg => TYPE_CHANGED_MSG,
        :old_type => String,
        :new_type => Array
      }
    ]

    # The message for the "arg moved to config file" deprecations
    CONFIG_FILE_MSG = "The ':key' setting can only be set in your config files."

    # List of command arguments deprecation definitions, each item of the
    # array is a hash that is passed to Deprecation.new as the properties
    # param value
    ARGS_DEPRECATIONS = [
      {
        :subtype => :no_subcommand,
        :key => 'no-subcommand',
        :msg => "Jekyll now uses subcommands instead of just switches. Run `jekyll help' to find out more."
      },
      {
        :key => '--server',
        :msg => "The :key command has been replaced by the 'serve' subcommand."
      },
      {
        :key => '--no-server',
        :msg => "To build Jekyll without launching a server, use the 'build' subcommand."
      },
      {
        :key => '--auto',
        :msg => "The switch ':key' has been replaced with '--watch'."
      },
      {
        :key => '--no-auto',
        :msg => "To disable auto-replication, simply leave off the '--watch' switch."
      },
      {
        :key => '--pygments',
        :msg => CONFIG_FILE_MSG
      },
      {
        :key => '--paginate',
        :msg => CONFIG_FILE_MSG
      },
      {
        :key => '--url',
        :msg => CONFIG_FILE_MSG
      }
    ]

    # Public: Process command line arguments to warn for deprecated arguments
    #
    # args - Array with command line arguments to check
    #
    # Returns nothing
    def self.command(args)
      process(deprecations_from_type(:args, :args => args))
    end

    # Public: Ensure the proper options are set in the configuration to
    # allow for backwards-compatibility with Jekyll pre-1.0
    #
    # config - The config instance to compatibilize
    #
    # Returns the same instance of configuration backwards-compatible
    def self.config(config)
      result = config.clone
      process(deprecations_from_type(:config, :config => result))
      result
    end

    # Public: Get all the deprecations from a specific type.
    #
    # type - the type of deprecations to search in definitions file
    # default_props- the default properties to be merged in each deprecation
    #
    # Returns the list of deprecations of the type
    def self.deprecations_from_type(type, default_props = {})
      deprecations = []
      definition_hashes(type).each do |definition_hash|
        definition_hash[:type] = type
        definition_hash.merge!(default_props)
        deprecations << Deprecation.new(definition_hash)
      end

      deprecations
    end

    # Public: Given the type of deprecations, return the list of hashes
    # defining the possible deprecations in the environment
    #
    # Returns an array of hash definitions according to the type
    def self.definition_hashes(type)
      case type
      when :config then CONFIG_DEPRECATIONS
      when :args then ARGS_DEPRECATIONS
      else raise "Unsupported deprecation type #{type}"
      end
    end

    # Public: Iterate the list of deprecations and, if the deprecation exists,
    # log a warning and make the necessary adjustments according the type and
    # subtype of them
    #
    # deprecations - Hash of Deprecation to be processed
    #
    # Returns nothing
    def self.process(deprecations)
      deprecations.each do |deprecation|
        if deprecation.exists?
          deprecation.warn
          adjust_deprecation(deprecation)
        end
      end
    end

    # Public: According to the deprecation type and subtype, make the necessary
    # adjustments to the jekyll site work the way that it worked before the
    # deprecation
    #
    # deprecation - The deprecation to check the adjustments
    #
    # Returns nothing
    # Raises Exception if the config type change deprecation is unsupported
    def self.adjust_deprecation(deprecation)
      if deprecation.type == :config
        config = deprecation.config
        key = deprecation.key

        case deprecation.subtype
        when :removed
          config.delete(key)
        when :renamed
          new_key = deprecation.new_key
          unless config.has_key?(new_key)
            config[new_key] = config[key]
          end
          config.delete(key)
        when :type_changed
          if (deprecation.old_type == String) && (deprecation.new_type == Array)
            config[key] = config[key].split(",").map(&:strip)
          end
        end
      end
    end
  end
end
