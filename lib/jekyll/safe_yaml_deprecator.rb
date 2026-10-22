require 'safe_yaml/load'

module Jekyll
  module SafeYAMLDeprecator
    def self.included(base)
      base.class_eval do
        def self.load(yaml, options = {})
          Jekyll::Deprecator.deprecation_message "SafeYAML has been deprecated and is going to be removed in Jekyll 5.0.  Please use Jekyll::Utils.safe_load_yaml instead."

          Jekyll::Utils.safe_load_yaml yaml
        end

        def self.load_file(filename, options = {})
          Jekyll::Deprecator.deprecation_message "SafeYAML has been deprecated and is going to be removed in Jekyll 5.0.  Please use Jekyll::Utils.safe_load_yaml_file instead."

          Jekyll::Utils.safe_load_yaml_file filename, options
        end
      end
    end
  end
end

SafeYAML.include Jekyll::SafeYAMLDeprecator
