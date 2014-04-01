module Jekyll
  class Document

    attr_reader   :path
    attr_accessor :content

    # Create a new Document.
    #
    # site - the Jekyll::Site instance to which this Document belongs
    # path - the path to the file
    #
    # Returns nothing.
    def initialize(site, path)
      @site = site
      @path = path
    end

    # Fetch the Document's data.
    #
    # Returns a Hash containing the data. An empty hash is returned if
    #   no data was read.
    def data
      @data ||= Hash.new
    end

    def extname
      File.extname(path)
    end

    def yaml_file?
      %w[.yaml .yml].include?(extname)
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
    def read
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
        "content" => content,
        "path"    => path
      })
    end

  end
end
