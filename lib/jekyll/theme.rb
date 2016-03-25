module Jekyll
  class Theme
    extend Forwardable
    attr_reader :name
    def_delegator :gemspec, :version, :version

    def initialize(name)
      @name = name.downcase.strip
    end

    def root
      @root ||= gemspec.full_gem_path
    end

    def includes_path
      path_for :includes
    end

    def layouts_path
      path_for :layouts
    end

    def sass_path
      path_for :sass
    end

    def configure_sass
      Sass.load_paths << sass_path if sass_path
    end

    private

    def path_for(folder)
      path = Jekyll.sanitized_path root, "_#{folder}"
      path if Dir.exists?(path)
    end

    def gemspec
      @gemspec ||= Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
      raise Jekyll::Errors::MissingDependencyException, "The #{name} theme could not be found."
    end
  end
end
