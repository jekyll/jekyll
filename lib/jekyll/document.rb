module Jekyll
  class Document
    include Comparable

    attr_reader   :path, :site
    attr_accessor :content, :collection, :output

    # Create a new Document.
    #
    # shit - the Jekyll::Site instance to which this Document belongs
    # path - the path to the file
    #
    # Returns nothing.
    def initialize(path, relations)
      @site = relations[:site]
      @path = path
      @collection = relations[:collection]
    end

    # Fetch the Document's data.
    #
    # Returns a Hash containing the data. An empty hash is returned if
    #   no data was read.
    def data
      @data ||= Hash.new
    end

    def relative_path
      Pathname.new(path).relative_path_from(Pathname.new(site.source)).to_s
    end

    def basename(suffix = "")
      File.basename(path, suffix)
    end

    def extname
      File.extname(path)
    end

    def cleaned_relative_path
      relative_path[0 .. -extname.length - 1].sub(collection.relative_directory, "")
    end

    def yaml_file?
      %w[.yaml .yml].include?(extname)
    end

    def asset_file?
      %w[.sass .scss .coffee].include?(extname)
    end

    def render_with_liquid?
      !(asset_file? || yaml_file?)
    end

    def url_template
      "/:collection/:path:output_ext"
    end

    def url_placeholders
      {
        collection: collection.label,
        path:       cleaned_relative_path,
        output_ext: Jekyll::Renderer.new(site, self).output_ext
      }
    end

    def permalink
      return nil if data.nil? || data['permalink'].nil?
      data['permalink']
    end

    def url
      @url ||= URL.new({
        :template     => url_template,
        :placeholders => url_placeholders,
        :permalink    => permalink
      }).to_s
    end

    def destination(base_directory)
      path = Jekyll.sanitized_path(base_directory, url)
      path = File.join(path, "index.html") if url =~ /\/$/
      path
    end

    # Write the generated Document file to the destination directory.
    #
    # dest - The String path to the destination dir.
    #
    # Returns nothing.
    def write(dest)
      path = destination(dest)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'wb') do |f|
        f.write(output)
      end
    end

    # Returns merged option hash for File.read of self.site (if exists)
    # and a given param
    #
    # opts - override options
    #
    # Return
    def merged_file_read_opts(opts)
      (site ? site.file_read_opts : {}).merge(opts)
    end

    # Whether the file is published or not, as indicated in YAML front-matter
    #
    # Returns true if the 'published' key is specified in the YAML front-matter and not `false`.
    def published?
      !(data.has_key?('published') && data['published'] == false)
    end

    # Read in the file and assign the content and data based on the file contents.
    #
    # Returns nothing.
    def read(opts = {})
      if yaml_file?
        @data = SafeYAML.load_file(path)
      else
        begin
          @content = File.read(path, merged_file_read_opts(opts))
          if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
            @content = $POSTMATCH
            @data    = SafeYAML.load($1)
          end
        rescue SyntaxError => e
          puts "YAML Exception reading #{path}: #{e.message}"
        rescue Exception => e
          puts "Error reading file #{path}: #{e.message}"
        end
      end
    end

    # Create a Liquid-understandable version of this Document.
    #
    # Returns a Hash representing this Document's data.
    def to_liquid
      data.merge({
        "content"       => content,
        "path"          => path,
        "relative_path" => relative_path,
        "url"           => url
      })
    end

    def inspect
      "#<Jekyll::Document #{relative_path} collection=#{collection.label}>"
    end

    def <=>(anotherDocument)
      path <=> anotherDocument.path
    end

  end
end
