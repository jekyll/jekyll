module Jekyll
  module Deprecations
    class Config
      # Represents a Renamed config deprecations, that need to be thrown when
      # an old existent key are renamed to a new name
      class Renamed < Config
        attr_reader :new_key

        # Public: Create a new Renamed deprecation
        #
        # properties - the properties for this type of deprecation, all the
        #              parent classes properties will be used to
        #       :new_key - the new name for the config key
        #
        # Returns the created Config deprecation
        def initialize(properties = {})
          super(properties)
          @new_key = properties[:new_key]
          if @msg
            @msg.gsub!(":new_key", @new_key)
          end
        end

        # Public: process the renamed config deprecation, which will call parent
        # #process_config, and rename the old key from config
        #
        # Returns the old config value
        def process_config
          super

          unless @config.has_key?(@new_key)
            @config[@new_key] = @config[@key]
          end
          @config.delete(@key)
        end

      end
    end
  end
end