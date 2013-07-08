module Jekyll
  module Deprecations
    class Config
      # Represents a Removed config deprecation, this deprecation need
      # to be thrown when a specific config existent in older version
      # is removed
      class Removed < Config
        # Public: process the removed config deprecation, which will call parent
        # #process_config and delete the old key from config
        #
        # Returns the old config value
        def process_config
          super
          @config.delete(@key)
        end
      end
    end
  end
end