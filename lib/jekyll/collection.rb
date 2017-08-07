# frozen_string_literal: true

module Jekyll
  class Collection
    attr_reader :site, :label, :metadata
    attr_writer :docs

    # Create a new Collection.
    #
    # site - the site to which this collection belongs.
    # label - the name of the collection
    #
    # Returns nothing.
    def initialize(site, label)
      @site     = site
      @label    = sanitize_label(label)
      @metadata = extract_metadata
    end

    # Fetch the Documents in this collection.
    # Defaults to an empty array if no documents have been read in.
    #
    # Returns an array of Jekyll::Document objects.
    def docs
      @docs ||= []
    end

    # Override of normal respond_to? to match method_missing's logic for
    # looking in @data.
    def respond_to_missing?(method, include_private = false)
      docs.respond_to?(method.to_sym, include_private) || super
    end

    # Override of method_missing to check in @data for the key.
    def method_missing(method, *args, &blck)
      if docs.respond_to?(method.to_sym)
        Jekyll.logger.warn "Deprecation:",
          "#{label}.#{method} should be changed to #{label}.docs.#{method}."
        Jekyll.logger.warn "", "Called by #{caller(0..0)}."
        docs.public_send(method.to_sym, *args, &blck)
      else
        super
      end
    end

    # Fetch the static files in this collection.
    # Defaults to an empty array if no static files have been read in.
    #
    # Returns an array of Jekyll::StaticFile objects.
    def files
      @files ||= []
    end

    # Read the allowed documents into the collection's array of docs.
    #
    # Returns the sorted array of docs.
    def read
      filtered_entries.each do |file_path|
        full_path = collection_dir(file_path)
        next if File.directory?(full_path)
        if Utils.has_yaml_header? full_path
          read_document(full_path)
        else
          read_static_file(file_path, full_path)
        end
      end
      docs.sort!
    end

    # All the entries in this collection.
    #
    # Returns an Array of file paths to the documents in this collection
    #   relative to the collection's directory
    def entries
      return [] unless exists?
      @entries ||=
        Utils.safe_glob(collection_dir, ["**", "*"], File::FNM_DOTMATCH).map do |entry|
          entry["#{collection_dir}/"] = ""
          entry
        end
    end

    # Filtered version of the entries in this collection.
    # See `Jekyll::EntryFilter#filter` for more information.
    #
    # Returns a list of filtered entry paths.
    def filtered_entries
      return [] unless exists?
      @filtered_entries ||=
        Dir.chdir(directory) do
          entry_filter.filter(entries).reject do |f|
            path = collection_dir(f)
            File.directory?(path) || entry_filter.symlink?(f)
          end
        end
    end

    # The directory for this Collection, relative to the site source.
    #
    # Returns a String containing the directory name where the collection
    #   is stored on the filesystem.
    def relative_directory
      @relative_directory ||= "_#{label}"
    end

    # The full path to the directory containing the collection.
    #
    # Returns a String containing th directory name where the collection
    #   is stored on the filesystem.
    def directory
      @directory ||= site.in_source_dir(relative_directory)
    end

    # The full path to the directory containing the collection, with
    #   optional subpaths.
    #
    # *files - (optional) any other path pieces relative to the
    #           directory to append to the path
    #
    # Returns a String containing th directory name where the collection
    #   is stored on the filesystem.
    def collection_dir(*files)
      return directory if files.empty?
      site.in_source_dir(relative_directory, *files)
    end

    # Checks whether the directory "exists" for this collection.
    # The directory must exist on the filesystem and must not be a symlink
    #   if in safe mode.
    #
    # Returns false if the directory doesn't exist or if it's a symlink
    #   and we're in safe mode.
    def exists?
      File.directory?(directory) && !entry_filter.symlink?(directory)
    end

    # The entry filter for this collection.
    # Creates an instance of Jekyll::EntryFilter.
    #
    # Returns the instance of Jekyll::EntryFilter for this collection.
    def entry_filter
      @entry_filter ||= Jekyll::EntryFilter.new(site, relative_directory)
    end

    # An inspect string.
    #
    # Returns the inspect string
    def inspect
      "#<Jekyll::Collection @label=#{label} docs=#{docs}>"
    end

    # Produce a sanitized label name
    # Label names may not contain anything but alphanumeric characters,
    #   underscores, and hyphens.
    #
    # label - the possibly-unsafe label
    #
    # Returns a sanitized version of the label.
    def sanitize_label(label)
      label.gsub(%r![^a-z0-9_\-\.]!i, "")
    end

    # Produce a representation of this Collection for use in Liquid.
    # Exposes two attributes:
    #   - label
    #   - docs
    #
    # Returns a representation of this collection for use in Liquid.
    def to_liquid
      Drops::CollectionDrop.new self
    end

    # Whether the collection's documents ought to be written as individual
    #   files in the output.
    #
    # Returns true if the 'write' metadata is true, false otherwise.
    def write?
      !!metadata.fetch("output", false)
    end

    # The URL template to render collection's documents at.
    #
    # Returns the URL template to render collection's documents at.
    def url_template
      @url_template ||= metadata.fetch("permalink") do
        Utils.add_permalink_suffix("/:collection/:path", site.permalink_style)
      end
    end

    # Extract options for this collection from the site configuration.
    #
    # Returns the metadata for this collection
    def extract_metadata
      if site.config["collections"].is_a?(Hash)
        site.config["collections"][label] || {}
      else
        {}
      end
    end

    private

    def read_document(full_path)
      doc = Jekyll::Document.new(full_path, :site => site, :collection => self)
      doc.read
      if site.publisher.publish?(doc) || !write?
        docs << doc
      else
        Jekyll.logger.debug "Skipped From Publishing:", doc.relative_path
      end
    end

    private

    def read_static_file(file_path, full_path)
      relative_dir = Jekyll.sanitized_path(
        relative_directory,
        File.dirname(file_path)
      ).chomp("/.")

      files << StaticFile.new(
        site,
        site.source,
        relative_dir,
        File.basename(full_path),
        self
      )
    end
  end
end
