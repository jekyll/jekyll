module Jekyll
  class Document

    attr_reader :site, :collection, :filename, :containing_dir
    attr_accessor :content, :data, :output

    YAML_FRONTMATTER_REGEXP = /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m

    class << self
      def filename_matcher
        /(.*)\.(\w+)/m
      end

      def parse_filename(name)
        filename_matcher.match(name)
      end
      # Class: Check if the filename is a valid filename for this class
      #
      # name - the questionable filename
      #
      # Returns true if valid, false if not.
      def valid_filename?(name)
        !!parse_filename(name)
      end
    end

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
      @containing_dir = full_path.include?("/") ? File.dirname(full_path) : ""
      @filename       = File.basename(full_path)
      @data           = Hash.new
    end

    # Public: The UID for this document (useful in feeds).
    #
    # Returns the String UID.
    def id
      relative_path
    end

    # Returns the shorthand String identifier of this Document
    def inspect
      "<#{self.class}(#{id})>"
    end

    # Public: Read in and parse the contents of the file.
    #
    # Returns the content of the file without the YAML front-matter.
    def read
      begin
        full_contents = File.read(absolute_path)
        if full_contents =~ YAML_FRONTMATTER_REGEXP
          @content = $POSTMATCH
          @data    = SafeYAML.load($1)
        end
        true
      rescue SyntaxError => e
        Jekyll.logger.warn "YAML Exception reading #{relative_path}: #{e.message}"
        false
      rescue Exception => e
        Jekyll.logger.warn "Error reading file #{relative_path}: #{e.message}"
        false
      end
    end

    # Public: Fetch the full path to the post source file, relative to the site source
    #
    # Returns the full path of the source file relative to the site source
    def relative_path
      File.join(*[collection.relative_directory, containing_dir, filename].map(&:to_s).reject(&:empty?))
    end

    # Public: Fetch the absolute path to the post source file
    #
    # Returns the full path of the source file relative to the site source
    def absolute_path
      File.join(*[collection.directory, containing_dir, filename].map(&:to_s).reject(&:empty?))
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

    # The template of the permalink.
    #
    # Returns the template String.
    def template
      if site.permalink_style == :pretty
        if index? && html?
          "/:path/"
        elsif html?
          "/:path/:basename/"
        else
          "/:path/:basename:output_ext"
        end
      else
        "/:path/:basename:output_ext"
      end
    end

    # Returns a hash of URL placeholder names (as symbols) mapping to the
    # desired placeholder replacements. For details see "url.rb"
    def url_placeholders
      {
        :path       => containing_dir,
        :basename   => filename,
        :output_ext => output_ext
      }
    end

    # Public: Fetches the output directory of
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
