module Jekyll
  class Theme
    extend Forwardable
    attr_reader :name
    def_delegator :gemspec, :version, :version

    def initialize(name)
      @name = name.downcase.strip
      configure_sass
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
      return unless sass_path
      require "sass"
      Sass.load_paths << sass_path
    end

    private

    def path_for(folder)
      resolved_dir = realpath_for(folder)
      return unless resolved_dir

      path = Jekyll.sanitized_path(root, resolved_dir)
      path if File.directory?(path)
    end

    def realpath_for(folder)
      File.realpath(Jekyll.sanitized_path(root, "_#{folder}"))
    rescue Errno::ENOENT, Errno::EACCES, Errno::ELOOP
      nil
    end

    def gemspec
      @gemspec ||= Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
      raise Jekyll::Errors::MissingDependencyException,
        "The #{name} theme could not be found."
    end
  end
end
