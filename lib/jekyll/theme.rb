module Jekyll
  class Theme
    attr_reader :name

    def initialize(name)
      @name = name.downcase.strip
      raise MissingDependencyException unless gemspec
    end

    def root
      @root ||= gemspec.gem_dir
    end

    def version
      gemspec.version
    end

    def assets_path
      path_for "assets"
    end

    def includes_path
      path_for "includes"
    end

    def layouts_path
      path_for "layouts"
    end

    private

    def path_for(folder)
      Jekyll.sanitized_path root, "_#{folder}"
    end

    def gemspec
      @gemspec ||= Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
      nil
    end
  end
end
