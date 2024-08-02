# frozen_string_literal: true

module Jekyll
  class Regenerator
    attr_reader :site, :metadata, :cache

    def initialize(site)
      @site = site
      clear
    end

    # Produce the absolute path of the metadata file
    #
    # Returns the String path of the file.
    def metadata_file
      @metadata_file ||= site.in_source_dir(".jekyll-metadata")
    end

    # -------------------------- For backwards-compatibility. --------------------------
    # See `lib/jekyll/incremental_regenertor.rb` for details and working implementation.

    def clear
      @metadata = {}
      clear_cache
    end

    def clear_cache
      @cache = {}
    end

    def add_dependency(path, dependency); end

    def write_metadata; end

    # ---
    # Following methods always return true for backwards-compatibility.
    # ---

    def regenerate?(_document)
      true
    end

    def add(_path)
      true
    end

    def force(_path)
      true
    end

    def source_modified_or_dest_missing?(_source_path, _dest_path)
      true
    end

    def modified?(_path)
      true
    end

    def disabled?
      true
    end
  end
end
