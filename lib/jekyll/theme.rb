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

    # A theme that lives in the "_themes" folder of a site's source instead of
    # in an installed gem. The folder is expected to have the same structure as
    # a gem-based theme: "_layouts", "_includes", "_sass", "assets" and "_data"
    # subfolders are picked up exactly like they are for gem-based themes, and
    # files in the site itself take precedence over files from the theme.
    class LocalTheme < Theme
          attr_reader :root

          class << self
                  # Public: Build a LocalTheme for the given theme name if a matching folder exists in the "_themes" folder of the site's source.
                  #
                  # source - the String path to the site's source folder.
                  # name   - the String name of the theme from the site's config.
                  #
                  # Returns the LocalTheme, or nil if there is no matching folder.
                  def from_source(source, name)
                            root = theme_root(source, name)
                            new(name, root) if root
                  end

                  private
                  def theme_root(source, name)
                            return unless valid_name?(name)

                            path = File.join(source, "_themes", name.downcase.strip)
                            File.realpath(path) if File.directory?(path)
                  rescue Errno::ENOENT, Errno::EACCES, Errno::ELOOP
                            nil
                  end

                  # Theme names double as folder names here, so they may not contain
                  # anything that could point outside of the "_themes" folder.
                  def valid_name?(name)
                            name = name.downcase.strip
                            !name.empty? && !name.start_with?(".") &&
                              !name.include?("/") && !name.include?("\\")
                  end
          end

          def initialize(name, root)
                  @name = name.downcase.strip
                  @root = root
                  Jekyll.logger.debug "Theme:", name
                  Jekyll.logger.debug "Theme source:", root
          end

          # A local theme is not backed by a gem, so it has no version.
          def version
                  nil
          end

          # A local theme is not backed by a gem, so it declares no runtime
          # dependencies.
          def runtime_dependencies
                  []
          end

          private

          # A local theme is not backed by a gem.
          def gemspec
                  nil
          end
    end
end
