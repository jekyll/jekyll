module Jekyll
  class Collection
    attr_reader :site, :label

    # Create a new Collection.
    #
    # site - the site to which this collection belongs.
    # label - the name of the collection
    #
    # Returns nothing.
    def initialize(site, label)
      @site  = site
      @label = sanitize_label(label)
    end

    # Fetch the Documents in this collection.
    # Defaults to an empty array if no documents have been read in.
    #
    # Returns an array of Jekyll::Document objects.
    def docs
      @docs ||= []
    end

    # Read the allowed documents into the collection's array of docs.
    #
    # Returns the sorted array of docs.
    def read
      Dir.glob(File.join(directory, "**", "*.*")).each do |file_path|
        if allowed_document?(file_path)
          doc = Jekyll::Document.new(file_path, { site: site, collection: self })
          doc.read
          docs << doc
        end
      end
      docs.sort!
    end

    # The directory for this Collection, relative to the site source.
    #
    # Returns a String containing the directory name where the collection
    #   is stored on the filesystem.
    def relative_directory
      "_#{label}"
    end

    # The full path to the directory containing the
    #
    # Returns a String containing th directory name where the collection
    #   is stored on the filesystem.
    def directory
      Jekyll.sanitized_path(site.source, relative_directory)
    end

    # Determine whether the document at a given path is an allowed document.
    #
    # path - the path to the document within this collection
    #
    # Returns false if the site is in safe mode and the document is a symlink,
    #   true otherwise.
    def allowed_document?(path)
      !(site.safe && File.symlink?(path))
    end

    # An inspect string.
    #
    # Returns the inspecr string
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
      label.gsub(/[^a-z0-9_\-]/i, '')
    end

    # Produce a representation of this Collection for use in Liquid.
    # Exposes two attributes:
    #   - label
    #   - docs
    #
    # Returns a representation of this collection for use in Liquid.
    def to_liquid
      docs
    end

  end
end
