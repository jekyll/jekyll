module Jekyll
  # This helper gave you methods to create and manage all the ```Jekyll::Deprecation```
  # instances, as well as process them for logging and adjust the deprecation
  # (if it need to be adjusted).
  class Deprecator

    # Public: Process command line arguments to warn for deprecated arguments
    #
    # args - Array with command line arguments to check
    #
    # Returns nothing
    def self.command(args)
      process(deprecations_from_type('command', :args => args))
    end

    # Public: Ensure the proper options are set in the configuration to
    # allow for backwards-compatibility with Jekyll pre-1.0
    #
    # config - The config instance to compatibilize
    #
    # Returns the same instance of configuration backwards-compatible
    def self.config(config)
      result = config.clone
      process(deprecations_from_type('config', :config => result))
      result
    end

    # Public: Get all the deprecations from a specific type, the deprecations
    # are loaded from the definitions file.
    #
    # type - the type of deprecations to search in definitions file
    # default_props- the default properties to be merged in each deprecation
    #
    # Returns the list of deprecations of the type
    def self.deprecations_from_type(type, default_props = {})
      filename = File.join(File.dirname(__FILE__), 'deprecations/definitions.yml')
      file = YAML.safe_load_file(filename)
      if file
        type_hash = file[type]

        raise "Type not defined in #{filename}" unless type_hash

        result = []
        type_hash.each_pair do |subtype, definitions|
          definitions.each do |definition|
            definition.merge!(default_props).symbolize_keys!
            result << new_deprecation(type, subtype, definition)
          end
        end
        result
      else
        []
      end
    end

    # Public: Process the deprecations
    #
    # deprecations - Hash of Deprecation to be processed
    def self.process(deprecations)
      deprecations.each { |deprecation|
        deprecation.process
      }
    end

    # Public: Get a class for the deprecation type and subtype. The deprecation
    # class will be catched from the type and subtype of the array item. All of
    # deprecations classes need to be on module ```Jekyll::Deprecations```. For
    # "default" subtypes, the class will be the type class, otherwise the subtype
    # need to be a innerclass of the type class, following the structure
    # ```Jekyll::Deprecations::Type::Subtype```
    #
    # The class may has the same name of type key, but [camelized], for example:
    #
    # ```yaml
    # config:
    #   sub_type:
    #     -
    #       key: key
    #       msg: "message"
    # ```
    #
    # The class used to the item above will be
    # ```Jekyll::Deprecations::Config::SubType```, without underline.
    #
    # type - The main type of the deprecation
    #         If this param be nil, :default will be assumed as the type
    # subtype - The subtype of the deprecation
    #           If this param be nil, :default will be assumed as the type
    #
    # Returns the class to the specific deprecation type and subtype
    def self.deprecation_class(type, subtype)
      classname = if 'default' == subtype then type.camelize else "#{type.camelize}::#{subtype.camelize}" end

      result = class_from_string("Jekyll::Deprecations::#{classname}")
      raise "Unsupported deprecation: type = '#{type}', subtype = '#{subtype}'" unless result
      result
    end

    # Public: Creates a Jekyll#Deprecation according to the type and subtype
    #
    # type - The main type of the deprecation
    # subtype - The subtype of the deprecation
    # properties - The properties that will be passed to the deprecation initilizer
    #
    # Returns a new Jekyll#Deprecation according the type of depracation
    def self.new_deprecation(type, subtype, properties = {})
      klass = deprecation_class(type, subtype)
      klass.new(properties)
    end


    # Returns the class reference from the name string
    def self.class_from_string(str)
      str.split('::').inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    end
  end
end
