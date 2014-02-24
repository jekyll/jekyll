module Jekyll
  class Document

    attr_reader :site, :filename, :containing_dir
    attr_accessor :content, :data, :output

    # Public: Initialize a new Document
    #
    # site - the Jekyll::Site of which this Document is a part
    # collection - the Jekyll::Collection to which this Document belongs
    # full_path - the full path of the file, relative to the site source
    #
    # Returns nothing.
    def initialize(site, collection, full_path)
      @site           = site
      @collection     = collection
      @containing_dir = File.dirname(full_path)
      @filename       = File.basename(full_path)
      @data           = Hash.new
      @content        = nil
    end

    # Public: Read in and parse the contents of the file.
    #
    # Returns the content of the file without the YAML front-matter.
    def read
      begin
        full_contents = File.read(relative_path)
        if full_contents =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
          @content = $POSTMATCH
          @data    = SafeYAML.load($1)
        end
      rescue SyntaxError => e
        puts "YAML Exception reading #{File.join(base, name)}: #{e.message}"
      rescue Exception => e
        puts "Error reading file #{File.join(base, name)}: #{e.message}"
      end
    end

    # Public: Fetch the full path to the post source file, relative to the site source
    #
    # Returns the full path of the source file relative to the site source
    def relative_path
      File.join(*[containing_dir, filename].map(&:to_s).reject(&:empty?))
    end

    # Public: The generated URL for this Document relative to the output root.
    #
    # Returns the String URL.
    def url
      @url ||= URL.new({
        :template => template,
        :placeholders => url_placeholders,
        :permalink => permalink
      }).to_s
    end

    # Public:
    #
    # Returns the directory of the output file
    def output_directory
      return url if url =~ /\/\z/
      File.dirname(url)
    end

    # Public: Fetch the extname of the Document, including the preceding period
    #
    # Returns the extname of the Document
    def extname
      File.extname(filename)
    end

    private #==================================================================

    def self.has_yaml_header?(file)
      "---" == File.open(file) { |fd| fd.read(3) }
    end

  end
end
