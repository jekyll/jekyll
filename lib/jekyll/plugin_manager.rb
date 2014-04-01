module Jekyll
  class PluginManager
    attr_reader :site

    # Create an instance of this class.
    #
    # site - the instance of Jekyll::Site we're concerned with
    #
    # Returns nothing
    def initialize(site)
      @site = site
    end

    # Require all the plugins which are allowed.
    #
    # Returns nothing
    def conscientious_require
      require_plugin_files
      require_gems
    end

    # Require each of the gem plugins specified.
    #
    # Returns nothing.
    def require_gems
      site.gems.each do |gem|
        if plugin_allowed?(gem)
          require gem
        end
      end
    end

    # Check whether a gem plugin is allowed to be used during this build.
    #
    # gem_name - the name of the gem
    #
    # Returns true if the gem name is in the whitelist or if the site is not
    #   in safe mode.
    def plugin_allowed?(gem_name)
      !site.safe || whitelist.include?(gem_name)
    end

    # Build an array of allowed plugin gem names.
    #
    # Returns an array of strings, each string being the name of a gem name
    #   that is allowed to be used.
    def whitelist
      @whitelist ||= Array[site.config['whitelist']].flatten
    end

    # Require all .rb files if safe mode is off
    #
    # Returns nothing.
    def require_plugin_files
      # If safe mode is off, load in any Ruby files under the plugins
      # directory.
      unless site.safe
        plugins.each do |plugins|
          Dir[File.join(plugins, "**", "*.rb")].sort.each do |f|
            require f
          end
        end
      end
    end

    # Static: Setup the plugin search path
    #
    # path_from_site - the plugin path from the Site configuration
    #
    # Returns an Array of plugin search paths
    def self.plugins_path(path_from_site)
      if (path_from_site == Jekyll::Configuration::DEFAULTS['plugins'])
        [File.join(source, path_from_site)]
      else
        Array(path_from_site).map { |d| File.expand_path(d) }
      end
    end
  end
end
