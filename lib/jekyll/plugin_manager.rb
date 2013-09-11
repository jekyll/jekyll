module Jekyll
  class PluginManager
    attr_accessor :converters, :generators

    def initialize(site)
      @site = site
    end

    def load
      unless @site.safe
        require_files
        collect_plugins
      end
    end

    # Get the implementation class for the given Converter.
    #
    # klass - The Class of the Converter to fetch.
    #
    # Returns the Converter instance implementing the given Converter.
    def getConverterImpl(klass)
      matches = self.converters.select { |c| c.class == klass }
      if impl = matches.first
        impl
      else
        raise "Converter implementation not found for #{klass}"
      end
    end

    private

    def collect_plugins
      self.converters = instantiate_subclasses(Jekyll::Converter)
      self.generators = instantiate_subclasses(Jekyll::Generator)
    end

    def require_files
      plugins_path.each do |path|
        Dir[File.join(path, "**/*.rb")].each do |file|
          require file
        end
      end
    end

    # Internal: Setup the plugin search path
    #
    # Returns an Array of plugin search paths
    def plugins_path
      if (config['plugins'] == Jekyll::Configuration::DEFAULTS['plugins'])
        [File.join(@site.source, config['plugins'])]
      else
        Array(config['plugins']).map { |d| File.expand_path(d) }
      end
    end

    # Create array of instances of the subclasses of the class or module
    #   passed in as argument.
    #
    # klass - class or module containing the subclasses which should be
    #         instantiated
    #
    # Returns array of instances of subclasses of parameter
    def instantiate_subclasses(klass)
      klass.subclasses.select do |c|
        !@site.safe || c.safe
      end.sort.map do |c|
        c.new(config)
      end
    end

    def config
      @site.config
    end
  end
end