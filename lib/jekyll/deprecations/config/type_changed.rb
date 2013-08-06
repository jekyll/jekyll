module Jekyll
  module Deprecations
    class Config
      # Represents a TypeChanged config deprecation, which need to be processed
      # when a config type has changed from a type to other
      class TypeChanged < Config
        # Unsupported type changing message
        UNSUPPORTED_CHANGE = "Unsupported type change deprecation, the change of type \
          from %s to %s is not a supported deprecation yet"

        attr_reader :old_type, :new_type

        # Public: Create a new TypeChanged deprecation
        #
        # properties - the properties for this type of deprecation, all the
        #              parent classes properties will be used to
        #       :new_type - the new type of the changed config
        #       :old_type - the new type of the changed config
        #
        # Returns the created Command deprecation
        def initialize(properties = {})
          super(properties)
          @new_type = Kernel.const_get(properties[:new_type])
          @old_type = Kernel.const_get(properties[:old_type])
        end

        # Public: process the TypeChanged config deprecation, which will
        # convert the config value from the old type to the new type
        #
        # Raises an Exception if the change is unsupported
        #
        # Returns nothing
        def process_config
          old_value = @config[@key]

          if old_value.is_a? @old_type
            super

            if @old_type == String
              if @new_type == Array
                @config[@key] = old_value.split(",").map(&:strip)
              else
                raise unsuported_change_msg
              end
            else
              raise unsuported_change_msg
            end
          end
        end

        def unsuported_change_msg
          UNSUPPORTED_CHANGE % [@old_type, @new_type]
        end
      end
    end
  end
end