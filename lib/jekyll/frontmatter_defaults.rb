module Jekyll
  class Configuration
    # This class handles custom defaults for YAML frontmatter settings.
    # These are set in _config.yml and apply both to internal use (e.g. layout)
    # and the data available to liquid.
    #
    # It is exposed via the frontmatter_defaults method on the site class.
    class FrontmatterDefaults
      # Initializes a new instance.
      def initialize(site)
        @site = site
      end

      # Finds a default value for a given setting, filtered by path and type
      #
      # path - the path (relative to the source) of the page, post or :draft the default is used in
      # type - a symbol indicating whether a :page, a :post or a :draft calls this method
      #
      # Returns the default value or nil if none was found
      def find(path, type, setting)
        value = nil
        old_scope = nil

        matching_sets(path, type).each do |set|
          if set['values'].has_key?(setting) && has_precedence?(old_scope, set['scope'])
            value = set['values'][setting]
            old_scope = set['scope']
          end
        end
        value
      end

      # Collects a hash with all default values for a page or post
      #
      # path - the relative path of the page or post
      # type - a symbol indicating the type (:post, :page or :draft)
      #
      # Returns a hash with all default values (an empty hash if there are none)
      def all(path, type)
        defaults = {}
        old_scope = nil
        matching_sets(path, type).each do |set|
          if has_precedence?(old_scope, set['scope'])
            defaults.merge! set['values']
            old_scope = set['scope']
          else
            defaults = set['values'].merge(defaults)
          end
        end
        defaults
      end

      private

      # Checks if a given default setting scope matches the given path and type
      #
      # scope - the hash indicating the scope, as defined in _config.yml
      # path - the path to check for
      # type - the type (:post, :page or :draft) to check for
      #
      # Returns true if the scope applies to the given path and type
      def applies?(scope, path, type)
        applies_path?(scope, path) && applies_type?(scope, type)
      end

      def applies_path?(scope, path)
        return true if scope['path'].empty?

        scope_path = Pathname.new(scope['path'])
        Pathname.new(sanitize_path(path)).ascend do |path|
          if path == scope_path
            return true
          end
        end
      end

      def applies_type?(scope, type)
        !scope.has_key?('type') || scope['type'] == type.to_s
      end

      # Checks if a given set of default values is valid
      #
      # set - the default value hash, as defined in _config.yml
      #
      # Returns true if the set is valid and can be used in this class
      def valid?(set)
        set.is_a?(Hash) && set['scope'].is_a?(Hash) && set['scope']['path'].is_a?(String) && set['values'].is_a?(Hash)
      end

      # Determines if a new scope has precedence over an old one
      #
      # old_scope - the old scope hash, or nil if there's none
      # new_scope - the new scope hash
      #
      # Returns true if the new scope has precedence over the older
      def has_precedence?(old_scope, new_scope)
        return true if old_scope.nil?

        new_path = sanitize_path(new_scope['path'])
        old_path = sanitize_path(old_scope['path'])

        if new_path.length != old_path.length
          new_path.length >= old_path.length
        elsif new_scope.has_key? 'type'
          true
        else
          !old_scope.has_key? 'type'
	end
      end

      # Collects a list of sets that match the given path and type
      #
      # Returns an array of hashes
      def matching_sets(path, type)
        valid_sets.select do |set|
          applies?(set['scope'], path, type)
        end
      end

      # Returns a list of valid sets
      #
      # This is not cached to allow plugins to modify the configuration
      # and have their changes take effect
      #
      # Returns an array of hashes
      def valid_sets
        sets = @site.config['defaults']
        return [] unless sets.is_a?(Array)

        sets.select do |set|
          unless valid?(set)
            Jekyll.logger.warn "Default:", "An invalid default set was found"
          end
          valid?(set)
        end
      end

      # Sanitizes the given path by removing a leading and addding a trailing slash
      def sanitize_path(path)
        if path.nil? || path.empty?
          ""
        else
          path.gsub(/\A\//, '').gsub(/([^\/])\z/, '\1/')
        end
      end
    end
  end
end