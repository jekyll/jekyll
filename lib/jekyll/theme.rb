module Jekyll
  class Theme
    attr_reader :name

    def initialize(name)
      @name = name.downcase.strip
      raise Jekyll::Errors::MissingDependencyException unless gemspec
    end

    def root
      @root ||= gemspec.full_gem_path
    end

    def version
      gemspec.version
    end

    def assets_path
      path_for :assets
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

    private

    def path_for(folder)
      folder = "_#{folder}" unless folder == :assets
      path   = Jekyll.sanitized_path root, folder.to_s
      path if Dir.exists?(path)
    end

    def gemspec
      @gemspec ||= Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
      nil
    end
  end
end
