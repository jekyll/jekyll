module Jekyll
  # Represents a deprecations, this need to be the main class for each
  # deprecation, it contains the generic methods for create, manage and
  # process the deprecations
	class Deprecation

    attr_reader :properties, :msg

    # Public: Creates a new Deprecation, in the msg for this deprecation
    # you can use the /:key/ placeholder, which will be replaced by the key of
    # this deprecation
    #
    # properties - the properties for the created deprecation, all of it can be
    # accessed through self.property_name (see #method_missing)
    #
    # Returns the created Deprecation
    def initialize(properties = {})
      @properties = properties

      @msg = @properties[:msg].dup
      @properties.each_pair do |key, value|
        unless key == :msg
          key_s = key.to_s
          self.class.send(:define_method, key_s) { @properties[key] }

          @msg.gsub!(":#{key_s}", value.to_s) unless !@msg || (key == :msg)
        end
      end

      validate
    end

    # List of supported old types for type changing deprecation
    ALLOWED_OLD_TYPES = [String]
    # List of supported new types for type changing deprecation
    ALLOWED_NEW_TYPES = [Array]

    # Unsupported type changing config deprecation message
    UNSUPPORTED_TYPE_CHANGE_MSG = "Unsupported type change deprecation, the \
      change of type from %s to %s is not a supported deprecation yet"

    # Public: Raise an error for non existent properties
    #
    # Returns nothing
    def check_props_exists(*props)
      props.each do |prop|
        unless @properties.has_key?(prop)
          raise "The required attribute #{prop.to_s} is not in deprecation properties"
        end
      end
    end

    # Public: Validates the deprecation, check if the required properties exists
    #
    # Returns nothing
    def validate
      check_props_exists :key, :type

      case type
      when :config
        check_props_exists :config
        case subtype
        when :renamed
          check_props_exists :new_key
        when :type_changed
          check_props_exists :old_type, :new_type
          unless ALLOWED_OLD_TYPES.include?(old_type) & ALLOWED_NEW_TYPES.include?(new_type)
            raise UNSUPPORTED_TYPE_CHANGE_MSG % old_type, new_type
          end
        end
      when :args
        check_props_exists :args
      else
        raise "Unsupported deprecation type #{type}."
      end
    end

    # Public: Given the type of the deprecation, returns if this deprecation
    # exists in the current environment
    #
    # Returns true if deprecation exists in the environment according to the
    # type of it, otherwise returns false
    def exists?
      case type
      when :config
        config.has_key?(key) && ((subtype != :type_changed) || config[key].is_a?(old_type))
      when :args
        if subtype == :no_subcommand
          args.size > 0 && args.first =~ /^--/ && !%w[--help --version].include?(args.first)
        else
          args.include?(key)
        end
      end
    end

    # Public: log a warning with this deprecation message by the jekyll logger
    #
    # Returns nothing
    def warn
      Jekyll.logger.warn "Deprecation:", msg
    end

    # Public: log an error with this deprecation message by the jekyll logger
    #
    # Returns nothing
    def error
      Jekyll.logger.error "Deprecation:", msg
    end
	end
end
