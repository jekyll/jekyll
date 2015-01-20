module Jekyll
  class Regenerator
    attr_reader :site, :metadata, :cache

    def initialize(site)
      @site = site

      # Read metadata from file
      read_metadata

      # Initialize cache to an empty hash
      @cache = {}
    end

    # Checks if a renderable object needs to be regenerated
    #
    # Returns a boolean.
    def regenerate?(document)
      case document
      when Post, Page
        document.asset_file? || document.data['regenerate'] ||
          modified?(site.in_source_dir(document.relative_path))
      when Document
        !document.write? || document.data['regenerate'] || modified?(document.path)
      else
        if document.respond_to?(:path)
          modified?(document.path)
        else
          true
        end
      end
    end

    # Add a path to the metadata
    #
    # Returns true, also on failure.
    def add(path)
      return true unless File.exist?(path)

      metadata[path] = {
        "mtime" => File.mtime(path),
        "deps" => []
      }
      cache[path] = true
    end

    # Force a path to regenerate
    #
    # Returns true.
    def force(path)
      cache[path] = true
    end

    # Clear the metadata and cache
    #
    # Returns nothing
    def clear
      @metadata = {}
      @cache = {}
    end

    # Checks if a path's (or one of its dependencies)
    # mtime has changed
    #
    # Returns a boolean.
    def modified?(path)
      return true if disabled?

      # Check for path in cache
      if cache.has_key? path
        return cache[path]
      end

      # Check path that exists in metadata
      data = metadata[path]
      if data
        data["deps"].each do |dependency|
          if modified?(dependency)
            return cache[dependency] = cache[path] = true
          end
        end
        if data["mtime"].eql? File.mtime(path)
          return cache[path] = false
        else
          return add(path)
        end
      end

      # Path does not exist in metadata, add it
      return add(path)
    end

    # Add a dependency of a path
    #
    # Returns nothing.
    def add_dependency(path, dependency)
      return if (metadata[path].nil? || @disabled)

      metadata[path]["deps"] << dependency unless metadata[path]["deps"].include? dependency
      regenerate? dependency
    end

    # Write the metadata to disk
    #
    # Returns nothing.
    def write_metadata
      File.open(metadata_file, 'w') do |f|
        f.write(metadata.to_yaml)
      end
    end

    # Produce the absolute path of the metadata file
    #
    # Returns the String path of the file.
    def metadata_file
      site.in_source_dir('.jekyll-metadata')
    end

    # Check if metadata has been disabled
    #
    # Returns a Boolean (true for disabled, false for enabled).
    def disabled?
      @disabled = site.full_rebuild? if @disabled.nil?
      @disabled
    end

    private

    # Read metadata from the metadata file, if no file is found,
    # initialize with an empty hash
    #
    # Returns the read metadata.
    def read_metadata
      @metadata = if !disabled? && File.file?(metadata_file)
        SafeYAML.load(File.read(metadata_file))
      else
        {}
      end
    end
  end
end
