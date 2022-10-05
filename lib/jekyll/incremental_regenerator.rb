# frozen_string_literal: true

module Jekyll
  class IncrementalRegenerator < Regenerator
    attr_reader :site, :metadata, :cache

    def initialize(site)
      @site = site
      @metadata = read_metadata
      clear_cache
    end

    # Checks if a writable object needs to be regenerated
    #
    # Returns a boolean.
    def regenerate?(item)
      case item
      when Page
        regenerate_page?(item)
      when Document
        regenerate_document?(item)
      else
        item_source_modified_or_dest_missing?(item)
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
    # Reimplemented as private method `:item_source_modified_or_dest_missing?`.
    #
    # Checks if the source has been modified or the destination is missing
    #
    # Returns a boolean
    def source_modified_or_dest_missing?(source_path, dest_path)
      Deprecator.deprecation_message <<~MSG
        #{self.class.name}##{__method__} is deprecated. The check has been reimplemented as
        a private method `:item_source_modified_or_dest_missing?`
      MSG

      modified?(source_path) || (dest_path && !File.exist?(dest_path))
    end

    # Checks if the mtime stat of given path has changed
    #
    # Returns a boolean.
    def modified?(path)
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
      return if metadata[path].nil?
      return if metadata[path]["deps"].include?(dependency)

      metadata[path]["deps"] << dependency
      add(dependency) unless metadata.include?(dependency)
      nil
    end

    # Write the metadata to disk
    #
    # Returns nothing.
    def write_metadata
      Jekyll.logger.debug "Writing Metadata:", ".jekyll-metadata"
      File.binwrite(metadata_file, Marshal.dump(metadata))
    end

    # Check if metadata has been disabled
    #
    # Returns a Boolean (true for disabled, false for enabled).
    def disabled?
      false
    end

    private

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

    # attributes assessed in order to determine whether source file has been
    # modified or a destination expected to be wriiten is missing.
    #   path:        to determine the absolute location of the source file
    #   write?:      to determine if the rendered contents will be written to disk
    #   destination: to determine the absolute location of the written contents.
    ASSESSED_ATTRIBUTES = [:path, :write?, :destination].freeze
    private_constant :ASSESSED_ATTRIBUTES

    # Checks if the source of given item has been modified or if the destination
    # of the item expected to be written is missing.
    #
    # Returns a boolean
    def item_source_modified_or_dest_missing?(item)
      return true unless ASSESSED_ATTRIBUTES.all? { |id| item.respond_to?(id) }

      modified?(site.in_source_dir(item.path)) || !File.exist?(item.destination(@site.dest))
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

    # -------------
    # item.data["regenerate"] is useful when Jekyll isn't able to detect dependencies For example,
    # when a page uses Liquid to iterate through `site.posts`, etc.
    # -------------

    def regenerate_page?(page)
      page.asset_file? || page.data["regenerate"] ||
        item_source_modified_or_dest_missing?(page)
    end

    # Documents that will not be written to destination will be regenerated always.
    def regenerate_document?(document)
      !document.write? || document.data["regenerate"] ||
        item_source_modified_or_dest_missing?(document)
    end
  end
end
