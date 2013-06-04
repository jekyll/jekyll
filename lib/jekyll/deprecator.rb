module Jekyll
  class Deprecator
    def self.process(args)
      no_subcommand(args)
      deprecation_message args, "--server", "The --server command has been replaced by the \
                          'serve' subcommand."
      deprecation_message args, "--no-server", "To build Jekyll without launching a server, \
                          use the 'build' subcommand."
      deprecation_message args, "--auto", "The switch '--auto' has been replaced with '--watch'."
      deprecation_message args, "--no-auto", "To disable auto-replication, simply leave off \
                          the '--watch' switch."
      deprecation_message args, "--pygments", "The 'pygments' setting can only be set in \
                          your config files."
      deprecation_message args, "--paginate", "The 'paginate' setting can only be set in your \
                          config files."
      deprecation_message args, "--url", "The 'url' setting can only be set in your config files."
    end

    def self.no_subcommand(args)
      if args.size > 0 && args.first =~ /^--/ && !%w[--help --version].include?(args.first)
        Jekyll::Stevenson.error "Deprecation:", "Jekyll now uses subcommands instead of just \
                            switches. Run `jekyll help' to find out more."
      end
    end

    def self.deprecation_message(args, deprecated_argument, message)
      if args.include?(deprecated_argument)
        Jekyll::Stevenson.error "Deprecation:", message
      end
    end
  end

  Configuration.class_eval do
    alias_method "read_config_files_original", "read_config_files"
    
    # Provide backwards-compatibility
    def backwards_compatibilize
      config = clone

      if config.has_key? 'server_port'  
        config['port'] = config['server_port'] unless config.has_key?('port')
      end
      deprecate_key('server_post', "has been renamed to 'port'. Please update your config file accordingly.", config)
      deprecate_key('server', "is no longer accepted. Use the 'jekyll serve' subcommand to serve your site with WEBrick.", config)

      message = "can no longer be set in the configuration file. Use the --watch/-w command-line option instead."
      deprecate_key('auto', message, config)
      deprecate_key('watch', message, config)

      config = deprecate_key_array('exclude', config)
      config = deprecate_key_array('include', config)

      config
    end

    define_method "read_config_files" do |*files, &block|
      configuration = send "read_config_files_original", *files, &block
      configuration.backwards_compatibilize
    end

    private

    def deprecate_key(name, message, config)
      if config.has_key? name
        Jekyll::Stevenson.warn "Deprecation:", "The '" + name + "' configuration option " + message
        config.delete name
      end
    end

    def deprecate_key_array(name, config)
      if config.has_key?(name) && config[name].is_a?(String)
        temp = config[name].split(",").map(&:strip)
        message = "should be an array. The string has been treated as a comma-separated list."
        deprecate_key(name, message, config)
        config[name] = temp
      end
      config
    end

  end
end
