module Jekyll
  class Configuration
    class FrontmatterDefaults
      def initialize(site)
        @site = site
      end

      def find(path, type, setting)
        value = nil
        matching_sets(path, type).each do |set|
          value = set['values'][setting] if set['values'].has_key?(setting)
        end
        value
      end

      def all(path, type)
        defaults = {}
        matching_sets(path, type).each do |set|
          defaults.merge! set['values']
        end
        defaults
      end

      private

      def applies?(scope, path, type)
        (scope['path'].empty? || path.starts_with?(scope['path'])) && (!scope.has_key?('type') || scope['type'] == type.to_s)
      end

      def valid?(set)
        set['scope'].is_a?(Hash) && set['scope'].has_key?('path') && set['values'].is_a?(Hash)
      end

      def matching_sets(path, type)
        valid_sets.select do |set|
          applies?(set['scope'], path, type)
        end
      end

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
    end
  end
end