# encoding: UTF-8

module Jekyll
  class Document
    include Comparable

    attr_reader   :path, :site, :extname
    attr_accessor :content, :collection, :output

    YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m

    # Create a new Document.
    #
    # site - the Jekyll::Site instance to which this Document belongs
    # path - the path to the file
    #
    # Returns nothing.
    def initialize(path, relations)
      @site = relations[:site]
      @path = path
      @extname = File.extname(path)
      @collection = relations[:collection]
      @has_yaml_header = nil
    end

    # Fetch the Document's data.
    #
    # Returns a Hash containing the data. An empty hash is returned if
    #   no data was read.
    def data
      @data ||= Hash.new
    end

    # The path to the document, relative to the site source.
    #
    # Returns a String path which represents the relative path
    #   from the site source to this document
    def relative_path
      @relative_path ||= Pathname.new(path).relative_path_from(Pathname.new(site.source)).to_s
    end

    # The base filename of the document, without the file extname.
    #
    # Returns the basename without the file extname.
    def basename_without_ext
      @basename_without_ext ||= File.basename(path, '.*')
    end

    # The base filename of the document.
    #
    # Returns the base filename of the document.
    def basename
      @basename ||= File.basename(path)
    end

    # Produces a "cleaned" relative path.
    # The "cleaned" relative path is the relative path without the extname
    #   and with the collection's directory removed as well.
    # This method is useful when building the URL of the document.
    #
    # Examples:
    #   When relative_path is "_methods/site/generate.md":
    #     cleaned_relative_path
    #     # => "/site/generate"
    #
    # Returns the cleaned relative path of the document.
    def cleaned_relative_path
      @cleaned_relative_path ||=
        relative_path[0 .. -extname.length - 1].sub(collection.relative_directory, "")
    end

    # Determine whether the document is a YAML file.
    #
    # Returns true if the extname is either .yml or .yaml, false otherwise.
    def yaml_file?
      %w[.yaml .yml].include?(extname)
    end

    # Determine whether the document is an asset file.
    # Asset files include CoffeeScript files and Sass/SCSS files.
    #
    # Returns true if the extname belongs to the set of extensions
    #   that asset files use.
    def asset_file?
      sass_file? || coffeescript_file?
    end

    # Determine whether the document is a Sass file.
    #
    # Returns true if extname == .sass or .scss, false otherwise.
    def sass_file?
      %w[.sass .scss].include?(extname)
    end

    # Determine whether the document is a CoffeeScript file.
    #
    # Returns true if extname == .coffee, false otherwise.
    def coffeescript_file?
      '.coffee'.eql?(extname)
    end

    # Determine whether the file should be rendered with Liquid.
    #
    # Returns false if the document is either an asset file or a yaml file,
    #   true otherwise.
    def render_with_liquid?
      !(coffeescript_file? || yaml_file?)
    end

    # Determine whether the file should be placed into layouts.
    #
    # Returns false if the document is either an asset file or a yaml file,
    #   true otherwise.
    def place_in_layout?
      !(asset_file? || yaml_file?)
    end

    # The URL template where the document would be accessible.
    #
    # Returns the URL template for the document.
    def url_template
      collection.url_template
    end

    # Construct a Hash of key-value pairs which contain a mapping between
    #   a key in the URL template and the corresponding value for this document.
    #
    # Returns the Hash of key-value pairs for replacement in the URL.
    def url_placeholders
      {
        collection: collection.label,
        path:       cleaned_relative_path,
        output_ext: Jekyll::Renderer.new(site, self).output_ext,
        name:       Utils.slugify(basename_without_ext),
        title:      Utils.slugify(data['title']) || Utils.slugify(basename_without_ext)
      }
    end

    # The permalink for this Document.
    # Permalink is set via the data Hash.
    #
    # Returns the permalink or nil if no permalink was set in the data.
    def permalink
      data && data.is_a?(Hash) && data['permalink']
    end

    # The computed URL for the document. See `Jekyll::URL#to_s` for more details.
    #
    # Returns the computed URL for the document.
    def url
      @url = URL.new({
        template:     url_template,
        placeholders: url_placeholders,
        permalink:    permalink
      }).to_s
    end

    # The full path to the output file.
    #
    # base_directory - the base path of the output directory
    #
    # Returns the full path to the output file of this document.
    def destination(base_directory)
      dest = site.in_dest_dir(base_directory)
      path = site.in_dest_dir(dest, URL.unescape_path(url))
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
    # Return the file read options hash.
    def merged_file_read_opts(opts)
      site ? site.file_read_opts.merge(opts) : opts
    end

    # Whether the file is published or not, as indicated in YAML front-matter
    #
    # Returns true if the 'published' key is specified in the YAML front-matter and not `false`.
    def published?
      !(data.key?('published') && data['published'] == false)
    end

    # Read in the file and assign the content and data based on the file contents.
    # Merge the frontmatter of the file with the frontmatter default
    # values
    #
    # Returns nothing.
    def read(opts = {})
      if yaml_file?
        @data = SafeYAML.load_file(path)
      else
        begin
          defaults = @site.frontmatter_defaults.all(url, collection.label.to_sym)
          unless defaults.empty?
            @data = defaults
          end
          @content = File.read(path, merged_file_read_opts(opts))
          if content =~ YAML_FRONT_MATTER_REGEXP
            @content = $POSTMATCH
            data_file = SafeYAML.load($1)
            unless data_file.nil?
              @data = Utils.deep_merge_hashes(defaults, data_file)
            end
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
      if data.is_a?(Hash)
        Utils.deep_merge_hashes data, {
          "output"        => output,
          "content"       => content,
          "relative_path" => relative_path,
          "path"          => relative_path,
          "url"           => url,
          "collection"    => collection.label
        }
      else
        data
      end
    end

    # The inspect string for this document.
    # Includes the relative path and the collection label.
    #
    # Returns the inspect string for this document.
    def inspect
      "#<Jekyll::Document #{relative_path} collection=#{collection.label}>"
    end

    # The string representation for this document.
    #
    # Returns the content of the document
    def to_s
      content || ''
    end

    # Compare this document against another document.
    # Comparison is a comparison between the 2 paths of the documents.
    #
    # Returns -1, 0, +1 or nil depending on whether this doc's path is less than,
    #   equal or greater than the other doc's path. See String#<=> for more details.
    def <=>(anotherDocument)
      path <=> anotherDocument.path
    end

    # Determine whether this document should be written.
    # Based on the Collection to which it belongs.
    #
    # True if the document has a collection and if that collection's #write?
    #   method returns true, otherwise false.
    def write?
      collection && collection.write?
    end

  end
end
