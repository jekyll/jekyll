# frozen_string_literal: true

module Jekyll
  class Theme
    extend Forwardable
    attr_reader   :name

    def_delegator :gemspec, :version, :version

    def initialize(name, gemspec: nil, ancestors: [])
      @name = name.downcase.strip
      @gemspec = gemspec if gemspec
      @ancestors = ancestors
      if ancestors.include?(@name)
        raise Errors::FatalException,
              "Theme inheritance cycle: #{(ancestors + [@name]).join(" -> ")}"
      end
      Jekyll.logger.debug "Theme:", name
      Jekyll.logger.debug "Theme source:", root
    end

    def root
      # Must use File.realpath to resolve symlinks created by rbenv
      # Otherwise, Jekyll.sanitized path with prepend the unresolved root
      @root ||= File.realpath(gemspec.full_gem_path)
    rescue Errno::ENOENT, Errno::EACCES, Errno::ELOOP
      raise "Path #{gemspec.full_gem_path} does not exist, is not accessible or includes " \
            "a symbolic link loop"
    end

    # The name of theme directory
    def basename
      @basename ||= File.basename(root)
    end

    def includes_path
      @includes_path ||= path_for "_includes"
    end

    def layouts_path
      @layouts_path ||= path_for "_layouts"
    end

    def sass_path
      @sass_path ||= path_for "_sass"
    end

    def assets_path
      @assets_path ||= path_for "assets"
    end

    def data_path
      @data_path ||= path_for "_data"
    end

    def runtime_dependencies
      gemspec.runtime_dependencies
    end

    def inheritance_chain
      @inheritance_chain ||= [self] + (parent ? parent.inheritance_chain : [])
    end

    def parent
      return @parent if defined?(@parent)

      parent_name = gemspec.metadata["jekyll:parent_theme"]
      return @parent = nil if parent_name.nil?

      unless parent_name.is_a?(String) && !parent_name.strip.empty?
        raise Errors::FatalException, "The #{name} parent theme must be a non-empty gem name."
      end

      parent_name = parent_name.downcase.strip
      dependency = parent_dependency(parent_name)
      parent_spec = Gem::Specification.find_by_name(parent_name, dependency.requirement)
      @parent = Theme.new(parent_name, :gemspec => parent_spec, :ancestors => @ancestors + [name])
    rescue Gem::LoadError
      raise Errors::MissingDependencyException,
            "The parent theme #{parent_name} required by #{name} could not be found."
    end

    def in_theme_dir(*paths)
      paths.reduce(root) { |base, path| Jekyll.sanitized_path(base, path) }
    end

    # The Sass converter sanitizes user paths in safe mode. Installed parent
    # themes, like its existing theme path, are trusted gem resource paths.
    module SassPaths
      def sass_load_paths
        parents = site.theme.inheritance_chain.drop(1)
        (super + parents.filter_map(&:sass_path)).uniq
      end
    end

    private

    def parent_dependency(parent_name)
      runtime_dependencies.find { |dep| dep.name == parent_name } ||
        raise(Errors::FatalException,
              "The #{name} parent theme #{parent_name} must be a runtime dependency.")
    end

    def path_for(folder)
      path = realpath_for(folder)
      path if path && File.directory?(path)
    end

    def realpath_for(folder)
      # This resolves all symlinks for the theme subfolder and then ensures that the directory
      # remains inside the theme root. This prevents the use of symlinks for theme subfolders to
      # escape the theme root.
      # However, symlinks are allowed to point to other directories within the theme.
      Jekyll.sanitized_path(root, File.realpath(Jekyll.sanitized_path(root, folder.to_s)))
    rescue Errno::ENOENT, Errno::EACCES, Errno::ELOOP => e
      log_realpath_exception(e, folder)
      nil
    end

    def log_realpath_exception(err, folder)
      return if err.is_a?(Errno::ENOENT)

      case err
      when Errno::EACCES
        Jekyll.logger.error "Theme error:", "Directory '#{folder}' is not accessible."
      when Errno::ELOOP
        Jekyll.logger.error "Theme error:", "Directory '#{folder}' includes a symbolic link loop."
      end
    end

    def gemspec
      @gemspec ||= Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
      raise Jekyll::Errors::MissingDependencyException,
            "The #{name} theme could not be found."
    end
  end
end
