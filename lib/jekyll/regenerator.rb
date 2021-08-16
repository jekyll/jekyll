# frozen_string_literal: true

module Jekyll
  class Regenerator
    attr_reader :site, :metadata, :cache

    def initialize(site)
      @site = site

      # Read metadata from file and reset cache only for incremental builds
      return if disabled?

      @metadata = read_metadata
      clear_cache
    end

    # Checks if a writable object needs to be regenerated
    #
    # Returns a boolean.
    def regenerate?(item)
      return true if disabled?

      case item
      when Page
        regenerate_page?(item)
      when Document
        regenerate_document?(item)
      else
        writable_source_modified_or_dest_missing?(item)
      end
    end

    # Add given path to the metadata hash
    #
    # Returns true, also on failure.
    def add(path)
      return true unless File.exist?(path)

      metadata[path] = {
        "mtime" => File.mtime(path),
        "deps"  => [],
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
      clear_cache
    end

    # Clear just the cache
    #
    # Returns nothing
    def clear_cache
      @cache = {}
    end

    # @deprecated. To be removed in the next major version.
    # Reimplemented as private method `:writable_source_modified_or_dest_missing?`.
    #
    # Checks if the source has been modified or the destination is missing
    #
    # Returns a boolean
    def source_modified_or_dest_missing?(source_path, dest_path)
      modified?(source_path) || (dest_path && !File.exist?(dest_path))
    end

    # Checks if the mtime stat of given path has changed
    #
    # Returns a boolean.
    def modified?(path)
      return true if disabled?

      # objects that don't have a path are always regenerated
      return true if path.nil?

      # Check for path in cache
      return cache[path] if cache.key? path

      # If we have seen this file before, check if it or one of its dependencies have been modified
      # or add it to the metadata otherwise.
      metadata[path] ? existing_file_modified?(path) : add(path)
    end

    # Add a dependency of given path
    #
    # Returns nothing.
    def add_dependency(path, dependency)
      return if disabled? || metadata[path].nil?
      return if metadata[path]["deps"].include?(dependency)

      metadata[path]["deps"] << dependency
      add(dependency) unless metadata.include?(dependency)
      nil
    end

    # Write the metadata to disk
    #
    # Returns nothing.
    def write_metadata
      return if disabled?

      Jekyll.logger.debug "Writing Metadata:", ".jekyll-metadata"
      File.binwrite(metadata_file, Marshal.dump(metadata))
    end

    # Produce the absolute path of the metadata file
    #
    # Returns the String path of the file.
    def metadata_file
      @metadata_file ||= site.in_source_dir(".jekyll-metadata")
    end

    # Check if metadata has been disabled
    #
    # Returns a Boolean (true for disabled, false for enabled).
    def disabled?
      return disabled unless @disabled.nil?

      @disabled = !site.incremental?
    end

    private

    attr_reader :disabled

    # Read metadata from the metadata file
    #
    # Returns the metadata hash or an empty hash if file is not found
    def read_metadata
      return {} unless File.file?(metadata_file)

      content = File.binread(metadata_file)
      Marshal.load(content)
    rescue TypeError
      SafeYAML.load(content)
    rescue ArgumentError => e
      Jekyll.logger.warn "Failed to load #{metadata_file}: #{e}"
      {}
    end

    # Checks if given item may be written to `site.dest`
    def writable?(item)
      item.respond_to?(:write?) && item.respond_to?(:destination) && item.write?
    end

    # Checks if the source of a writable has been modified or if the destination
    # of the writable is missing
    #
    # Returns a boolean
    def writable_source_modified_or_dest_missing?(item)
      writable?(item) &&
        (modified?(site.in_source_dir(item.path)) || !File.exist?(item.destination(@site.dest)))
    end

    def regenerate_page?(page)
      page.asset_file? || page.data["regenerate"] ||
        writable_source_modified_or_dest_missing?(page)
    end

    def regenerate_document?(document)
      document.data["regenerate"] || writable_source_modified_or_dest_missing?(document)
    end

    def existing_file_modified?(path)
      # If one of the dependencies of given path have been modified, set the regeneration bit for
      # both the dependency and the path to true
      metadata[path]["deps"].each do |dependency|
        return cache[dependency] = cache[path] = true if modified?(dependency)
      end

      # If this file has not been modified, set the regeneration bit to false or true otherwise
      if File.exist?(path) && metadata[path]["mtime"].eql?(File.mtime(path))
        cache[path] = false
      else
        add(path)
      end
    end
  end
end
