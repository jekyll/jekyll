module Jekyll
  class Collection
    attr_reader :site, :label

    def initialize(site, label)
      @site  = site
      @label = label
    end

    def docs
      @docs ||= []
    end

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

    def directory
      Jekyll.sanitized_path(site.source, "_#{label}")
    end

    def allowed_document?(path)
      !(site.safe && File.symlink?(path))
    end

    def inspect
      "#<Jekyll::Collection @label=#{label} docs=#{docs}>"
    end

    def to_liquid
      {
        "label" => label,
        "docs"  => docs
      }
    end

  end
end
