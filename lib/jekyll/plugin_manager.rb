module Jekyll
  class PluginManager
    attr_reader :site

    # Create a new plugin manager.
    #
    # Returns nothing.
    def initialize(site)
      @site = site
    end

    # Determines whether *all* plugins should be required
    #
    # Returns true if all plugins are allowed, false otherwise
    def require_all_plugins?
      !site.safe
    end

    # Require the plugins that are allowed.
    #
    # Returns nothing.
    def require_plugins
      require_plugin_files if require_all_plugins?
      require_gems         if require_all_plugins? || whitelist.size > 0
    end

    # The gem plugin whitelist
    #
    # Returns an array of gem names which are whitelisted
    def whitelist
      @whitelist ||= (Array[site.config['whitelist']].flatten || [])
    end

    # Require all the gems which are allowed.
    # See #plugin_allowed? for more information about determining whether
    #   a plugin is allowed.
    #
    # Returns nothing.
    def require_gems
      site.gems.each do |gem|
        if plugin_allowed?(gem)
          require gem
        end
      end
    end

    # Determines whether a plugin is allowed, based on the safety setting
    # and whether the plugin name is in the whitelist.
    #
    # gem_name - the name of the gemified plugin
    #
    # Returns true if either require_all_plugins? returns true or if the
    #  gem name is in the whitelist.
    def plugin_allowed?(gem_name)
      whitelist.include?(gem_name) || require_all_plugins?
    end

    # Iterates through all the plugin paths and requires each Ruby file.
    #
    # Returns nothing.
    def require_plugin_files
      site.plugins_path.each do |a_plugins_path|
        Dir[File.join(a_plugins_path, "**/*.rb")].sort.each do |f|
          require f
        end
      end
    end
  end
end
