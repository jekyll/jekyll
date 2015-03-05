module Jekyll
  class Collection
    attr_reader :site, :label, :metadata

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
          doc = Jekyll::Document.new(full_path, { site: site, collection: self })
          doc.read
          docs << doc if site.publisher.publish?(doc)
        else
          relative_dir = Jekyll.sanitized_path(relative_directory, File.dirname(file_path)).chomp("/.")
          files << StaticFile.new(site, site.source, relative_dir, File.basename(full_path), self)
        end
      end
      docs.sort!
    end

    # All the entries in this collection.
    #
    # Returns an Array of file paths to the documents in this collection
    #   relative to the collection's directory
    def entries
      return Array.new unless exists?
      @entries ||=
        Dir.glob(collection_dir("**", "*.*")).map do |entry|
          entry["#{collection_dir}/"] = ''; entry
        end
    end

    # Filtered version of the entries in this collection.
    # See `Jekyll::EntryFilter#filter` for more information.
    #
    # Returns a list of filtered entry paths.
    def filtered_entries
      return Array.new unless exists?
      @filtered_entries ||=
        Dir.chdir(directory) do
          entry_filter.filter(entries).reject do |f|
            path = collection_dir(f)
            File.directory?(path) || (File.symlink?(f) && site.safe)
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
      File.directory?(directory) && !(File.symlink?(directory) && site.safe)
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
      label.gsub(/[^a-z0-9_\-\.]/i, '')
    end

    # Produce a representation of this Collection for use in Liquid.
    # Exposes two attributes:
    #   - label
    #   - docs
    #
    # Returns a representation of this collection for use in Liquid.
    def to_liquid
      metadata.merge({
        "label"     => label,
        "docs"      => docs,
        "files"     => files,
        "directory" => directory,
        "output"    => write?,
        "relative_directory" => relative_directory
      })
    end

    # Whether the collection's documents ought to be written as individual
    #   files in the output.
    #
    # Returns true if the 'write' metadata is true, false otherwise.
    def write?
      !!metadata['output']
    end

    # The URL template to render collection's documents at.
    #
    # Returns the URL template to render collection's documents at.
    def url_template
      metadata.fetch('permalink', "/:collection/:path:output_ext")
    end

    # Extract options for this collection from the site configuration.
    #
    # Returns the metadata for this collection
    def extract_metadata
      if site.config['collections'].is_a?(Hash)
        site.config['collections'][label] || Hash.new
      else
        {}
      end
    end
  end
end
