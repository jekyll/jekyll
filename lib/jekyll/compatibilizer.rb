module Jekyll
  class Compatibilizer
    class << self
      def compatibilize_for_windows
      end

      # Public: Ensure the proper options are set in the configuration to allow for
      # backwards-compatibility with Jekyll pre-1.0
      #
      # Returns the backwards-compatible configuration
      def backwards_compatibilize_configs(config)
        # Provide backwards-compatibility
        if config.has_key?('auto') || config.has_key?('watch')
          Jekyll.logger.warn "Deprecation:", "Auto-regeneration can no longer" +
            " be set from your configuration file(s). Use the"+
            " --watch/-w command-line option instead."
          config.delete('auto')
          config.delete('watch')
        end

        if config.has_key? 'server'
          Jekyll.logger.warn "Deprecation:", "The 'server' configuration option" +
            " is no longer accepted. Use the 'jekyll serve'" +
            " subcommand to serve your site with WEBrick."
          config.delete('server')
        end

        if config.has_key? 'server_port'
          Jekyll.logger.warn "Deprecation:", "The 'server_port' configuration option" +
            " has been renamed to 'port'. Please update your config" +
            " file accordingly."
          # copy but don't overwrite:
          config['port'] = config['server_port'] unless config.has_key?('port')
          config.delete('server_port')
        end

        if config.has_key? 'pygments'
          Jekyll.logger.warn "Deprecation:", "The 'pygments' configuration option" +
            " has been renamed to 'highlighter'. Please update your" +
            " config file accordingly. The allowed values are 'rouge', " +
            "'pygments' or null."

          config['highlighter'] = 'pygments' if config['pygments']
          config.delete('pygments')
        end

        %w[include exclude].each do |option|
          if config.fetch(option, []).is_a?(String)
            Jekyll.logger.warn "Deprecation:", "The '#{option}' configuration option" +
              " must now be specified as an array, but you specified" +
              " a string. For now, we've treated the string you provided" +
              " as a list of comma-separated values."
            config[option] = csv_to_array(config[option])
          end
        end

        if config.fetch('markdown', 'kramdown').to_s.downcase.eql?("maruku")
          Jekyll::Deprecator.deprecation_message "You're using the 'maruku' " +
            "Markdown processor. Maruku support has been deprecated and will " +
            "be removed in 3.0.0. We recommend you switch to Kramdown."
        end
        config
      end
    end
  end
end
