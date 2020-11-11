# frozen_string_literal: true

module Jekyll
  class Theme
    extend Forwardable
    attr_reader   :name

    def_delegator :gemspec, :version, :version

    def initialize(name)
      @name = name.downcase.strip
      Jekyll.logger.debug "Theme:", name
      Jekyll.logger.debug "Theme source:", root
    end

    def root
      # Must use File.realpath to resolve symlinks created by rbenv
      # Otherwise, Jekyll.sanitized path with prepend the unresolved root
      @root ||= File.realpath(gemspec.full_gem_path)
    rescue Errno::ENOENT, Errno::EACCES, Errno::ELOOP
      raise "Path #{gemspec.full_gem_path} does not exist, is not accessible "\
        "or includes a symbolic link loop"
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

    def runtime_dependencies
      gemspec.runtime_dependencies
    end

    private

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
