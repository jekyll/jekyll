# frozen_string_literal: true

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
      # Must use File.realpath to resolve symlinks created by rbenv
      # Otherwise, Jekyll.sanitized path with prepend the unresolved root
      @root ||= File.realpath(gemspec.full_gem_path)
    rescue Errno::ENOENT, Errno::EACCES, Errno::ELOOP
      raise "Path #{gemspec.full_gem_path} does not exist, is not accessible "\
        "or includes a symbolic link loop"
    end

    def includes_path
      path_for "_includes".freeze
    end

    def layouts_path
      path_for "_layouts".freeze
    end

    def sass_path
      path_for "_sass".freeze
    end

    def assets_path
      path_for "assets".freeze
    end

    def configure_sass
      return unless sass_path
      External.require_with_graceful_fail("sass") unless defined?(Sass)
      Sass.load_paths << sass_path
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
      File.realpath(Jekyll.sanitized_path(root, folder.to_s))
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
