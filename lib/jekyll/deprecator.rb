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

    def backwards_compatibilize
      config = clone
      # Provide backwards-compatibility
      if config.has_key?('auto') || config.has_key?('watch')
        Jekyll::Stevenson.warn "Deprecation:", "Auto-regeneration can no longer" +
                            " be set from your configuration file(s). Use the"+
                            " --watch/-w command-line option instead."
        config.delete('auto')
        config.delete('watch')
      end

      if config.has_key? 'server'
        Jekyll::Stevenson.warn "Deprecation:", "The 'server' configuration option" +
                            " is no longer accepted. Use the 'jekyll serve'" +
                            " subcommand to serve your site with WEBrick."
        config.delete('server')
      end

      if config.has_key? 'server_port'
        Jekyll::Stevenson.warn "Deprecation:", "The 'server_port' configuration option" +
                            " has been renamed to 'port'. Please update your config" +
                            " file accordingly."
        # copy but don't overwrite:
        config['port'] = config['server_port'] unless config.has_key?('port')
        config.delete('server_port')
      end

      if config.has_key?('exclude') && config['exclude'].is_a?(String)
        Jekyll::Stevenson.warn "Deprecation:", "The 'exclude' configuration option" +
                               " must now be specified as an array, but you specified" +
                               " a string. For now, we've treated the string you provided" +
                               " as a list of comma-separated values."
        config['exclude'] = csv_to_array(config['exclude'])
      end

      if config.has_key?('include') && config['include'].is_a?(String)
        Jekyll::Stevenson.warn "Deprecation:", "The 'include' configuration option" +
                               " must now be specified as an array, but you specified" +
                               " a string. For now, we've treated the string you provided" +
                               " as a list of comma-separated values."
        config['include'] = csv_to_array(config['include'])
      end

      config
    end

    define_method "read_config_files" do |*files, &block|
      configuration = send "read_config_files_original", *files, &block
      configuration.backwards_compatibilize
    end
  end
end
