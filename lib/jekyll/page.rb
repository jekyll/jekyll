module Jekyll
  class Page < Document

    class << self
      # Class: An Array of attributes of this page which are used to generate
      #        page data for liquid templates.
      #
      # Returns an array of attributes
      def liquid_attributes
        @liquid_attributes ||= %w[
          content
          dir
          name
          path
          url
        ]
      end
    end

    # The full path and filename of the post. Defined in the YAML of the post
    # body.
    #
    # Returns the String permalink or nil if none has been set.
    def permalink
      return nil if data.nil? || data['permalink'].nil?
      if site.config['relative_permalinks']
        File.join(containing_dir, data['permalink'])
      else
        data['permalink']
      end
    end

    # The path to the source file
    #
    # Returns the path to the source file
    def path
      data.fetch('path', relative_path.sub(/\A\//, ''))
    end

    # Obtain destination path.
    #
    # dest - The String path to the destination dir.
    #
    # Returns the destination file path String.
    def destination(dest)
      path = Jekyll.sanitized_path(dest, url)
      path = File.join(path, "index.html") if url =~ /\/$/
      path
    end

    # Returns the Boolean of whether this Page is HTML or not.
    def html?
      p site
      DocumentConverter.new(self).output_ext == '.html'
    end

    # Returns the Boolean of whether this Page is an index file or not.
    def index?
      basename == 'index'
    end

    def uses_relative_permalinks?
      permalink && !containing_dir.empty? && site.config['relative_permalinks']
    end
  end
end
