require 'set'

module Jekyll
  class Metadata
    attr_reader :site, :metadata

    def initialize(site)
      @site = site

      # Initialize metadata store by reading YAML file,
      # or an empty hash if file does not exist
      @metadata = (File.file?(metadata_file) && !(site.config['clean'])) ? SafeYAML.load(File.read(metadata_file)) : {}

      # Initialize cache to an empty hash
      @cache = {}
    end

    # Add a path to the metadata
    #
    # Returns true.
    def add(path)
      @metadata[path] = {
        "mtime" => File.mtime(path),
        "deps" => []
      }
      @cache[path] = true
    end

    # Force a path to regenerate
    #
    # Returns true.
    def force(path)
      @cache[path] = true
    end

    # Checks if a path should be regenerated
    #
    # Returns a boolean.
    def regenerate?(path)
      # Check for path in cache
      if @cache.has_key? path
        return @cache[path]
      end

      # Check path that exists in metadata
      if (data = @metadata[path])
        data["deps"].each do |dependency|
          if regenerate?(dependency)
            return @cache[dependency] = @cache[path] = true
          end
        end
        if data["mtime"] == File.mtime(path)
          return @cache[path] = false
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
      @metadata[path]["deps"] << dependency unless @metadata[path]["deps"].include? dependency
      regenerate? dependency
    end

    # Write the metadata to disk
    #
    # Returns nothing.
    def write
      File.open(metadata_file, 'w') do |f|
        f.write(@metadata.to_yaml)
      end
    end

    # Produce the absolute path of the metadata file
    #
    # Returns the String path of the file.
    def metadata_file
      Jekyll.sanitized_path(site.source, '.jekyll-metadata')
    end
  end
end
