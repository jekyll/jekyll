# frozen_string_literal: true

require "digest"

module Jekyll
  class Regenerator
    attr_reader :site, :metadata, :cache
    attr_accessor :disabled
    private :disabled, :disabled=

    def initialize(site)
      @site = site

      # Read metadata from file
      read_metadata

      # Initialize cache to an empty hash
      clear_cache
    end

    # Checks if a renderable object needs to be regenerated
    #
    # Returns a boolean.
    def regenerate?(document)
      return true if disabled

      case document
      when Page
        regenerate_page?(document)
      when Document
        regenerate_document?(document)
      else
        source_path = document.respond_to?(:path) ? document.path : nil
        dest_path = document.destination(@site.dest) if document.respond_to?(:destination)
        source_modified_or_dest_missing?(source_path, dest_path)
      end
    end

    # Get the value for 'path' indicating whether or not it has been modified
    #
    # Returns any serializable
    def incremental_cache_key(path)
      if site.incremental_cache_key == "md5"
        Digest::MD5.file(path).hexdigest
      else
        File.mtime(path)
      end
    end

    # Add a path to the metadata
    #
    # Returns true, also on failure.
    def add(path)
      return true unless File.exist?(path)

      metadata[path] = {
        "incremental_cache_key" => incremental_cache_key(path),
        "deps"                  => [],
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

    # Checks if the source has been modified or the
    # destination is missing
    #
    # returns a boolean
    def source_modified_or_dest_missing?(source_path, dest_path)
      modified?(source_path) || (dest_path && !File.exist?(dest_path))
    end

    # Checks if a path's (or one of its dependencies)
    # incremental cache key has changed
    #
    # Returns a boolean.
    def modified?(path)
      return true if disabled?

      binding.irb

      # objects that don't have a path are always regenerated
      return true if path.nil?

      # Check for path in cache
      return cache[path] if cache.key? path

      if metadata[path]
        # If we have seen this file before,
        # check if it or one of its dependencies has been modified
        existing_file_modified?(path)
      else
        # If we have not seen this file before, add it to the metadata and regenerate it
        add(path)
      end
    end

    # Add a dependency of a path
    #
    # Returns nothing.
    def add_dependency(path, dependency)
      return if metadata[path].nil? || disabled

      unless metadata[path]["deps"].include? dependency
        metadata[path]["deps"] << dependency
        add(dependency) unless metadata.include?(dependency)
      end
      regenerate? dependency
    end

    # Write the metadata to disk
    #
    # Returns nothing.
    def write_metadata
      unless disabled?
        Jekyll.logger.debug "Writing Metadata:", ".jekyll-metadata"
        File.binwrite(metadata_file, Marshal.dump(metadata))
      end
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
      self.disabled = !site.incremental? if disabled.nil?
      disabled
    end

    private

    # Read metadata from the metadata file, if no file is found,
    # initialize with an empty hash
    #
    # Returns the read metadata.
    def read_metadata
      @metadata =
        if !disabled? && File.file?(metadata_file)
          content = File.binread(metadata_file)

          begin
            Marshal.load(content)
          rescue TypeError
            SafeYAML.load(content)
          rescue ArgumentError => e
            Jekyll.logger.warn("Failed to load #{metadata_file}: #{e}")
            {}
          end
        else
          {}
        end
    end

    def regenerate_page?(document)
      document.asset_file? || document.data["regenerate"] ||
        source_modified_or_dest_missing?(
          site.in_source_dir(document.relative_path), document.destination(@site.dest)
        )
    end

    def regenerate_document?(document)
      !document.write? || document.data["regenerate"] ||
        source_modified_or_dest_missing?(
          document.path, document.destination(@site.dest)
        )
    end

    def existing_file_modified?(path)
      # If one of this file dependencies have been modified,
      # set the regeneration bit for both the dependency and the file to true
      metadata[path]["deps"].each do |dependency|
        return cache[dependency] = cache[path] = true if modified?(dependency)
      end

      if File.exist?(path) && metadata[path]["incremental_cache_key"].eql?(incremental_cache_key(path))
        # If this file has not been modified, set the regeneration bit to false
        cache[path] = false
      else
        # If it has been modified, set it to true
        add(path)
      end
    end
  end
end
