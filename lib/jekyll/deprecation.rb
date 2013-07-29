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
      if @msg
        @properties.each_pair do |key, value|
          @msg.gsub!(":#{key.to_s}", value.to_s)
        end
      end
    end

    # Public: Treats the possible metaprogramming.
    #
    # Return will depend from the metaprog.
    def method_missing(meth)
      if @properties.has_key?(meth)
        run_property_method_missing(meth)
      else
        super
      end
    end

    # Public: Define a reader method for the property and returns the value of it. This reader method will be
    # available to each property defined in properties map
    #
    # Examples
    #
    #   deprecation = Deprecation.new(:key => 'mon', :msg => 'Beware with the Mon Keys')
    #   deprecation.key # Same as deprecation.properties[:key]
    #   deprecation.msg # Same as deprecation.properties[:msg]
    #   deprecation.monkey # Method missing error
    #
    # Signature
    #
    #   <property>
    #
    # property - The name of the property to be accessed
    #
    # Returns the property value
    def run_property_method_missing(meth)
      meth_str = meth.to_s
      self.class.send(:define_method, meth_str) { @properties[meth] }
      self.send(meth_str)
    end

    # List of supported old types for type changing deprecation
    ALLOWED_OLD_TYPES = [String]
    # List of supported new types for type changing deprecation
    ALLOWED_NEW_TYPES = [Array]

    # Unsupported type changing config deprecation message
    UNSUPPORTED_TYPE_CHANGE_MSG = "Unsupported type change deprecation, the \
      change of type from %s to %s is not a supported deprecation yet"

    # Public: Given the type of the deprecation, returns if this deprecation
    # exists in the current environment
    #
    # Returns true if deprecation exists in the environment according to the
    # type of it, otherwise returns false
    def exists?
      case type
      when :config
        if config.has_key?(key)
          if subtype == :type_changed
            config[key].is_a?(old_type)
          else
            true
          end
        end
      when :args
        if (self.subtype == :no_subcommand)
          args.size > 0 && args.first =~ /^--/ && !%w[--help --version].include?(args.first)
        else
          args.include?(key)
        end
      else
        Jekyll.logger.warn "Unsupported deprecation type."
        false
      end
    end

    # Public: Check if the given old and new types are allowed
    #
    # Raises Exception if one of the types are not allowed
    def check_types!
      raise UNSUPPORTED_TYPE_CHANGE_MSG % old_type, new_type unless ALLOWED_OLD_TYPES.include?(old_type) & ALLOWED_NEW_TYPES.include?(new_type)
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
