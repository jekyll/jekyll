# encoding: UTF-8

module Jekyll
  class Document
    include Comparable

    attr_reader :path, :site, :extname, :collection
    attr_accessor :content, :output

    YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
    DATELESS_FILENAME_MATCHER = /^(.+\/)*(.*)(\.[^.]+)$/
    DATE_FILENAME_MATCHER = /^(.+\/)*(\d+-\d+-\d+)-(.*)(\.[^.]+)$/

    # Create a new Document.
    #
    # path - the path to the file
    # relations - a hash with keys :site and :collection, the values of which
    #             are the Jekyll::Site and Jekyll::Collection to which this
    #             Document belong.
    #
    # Returns nothing.
    def initialize(path, relations = {})
      @site = relations[:site]
      @path = path
      @extname = File.extname(path)
      @collection = relations[:collection]
      @has_yaml_header = nil

      if draft?
        categories_from_path("_drafts")
      else
        categories_from_path(collection.relative_directory)
      end

      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, collection.label, key)
      end

      trigger_hooks(:post_init)
    end

    # Fetch the Document's data.
    #
    # Returns a Hash containing the data. An empty hash is returned if
    #   no data was read.
    def data
      @data ||= {}
    end

    # Merge some data in with this document's data.
    #
    # Returns the merged data.
    def merge_data!(other, source: "YAML front matter")
      if other.key?('categories') && !other['categories'].nil?
        if other['categories'].is_a?(String)
          other['categories'] = other['categories'].split(" ").map(&:strip)
        end
        other['categories'] = (data['categories'] || []) | other['categories']
      end
      Utils.deep_merge_hashes!(data, other)
      if data.key?('date') && !data['date'].is_a?(Time)
        data['date'] = Utils.parse_date(
          data['date'].to_s,
          "Document '#{relative_path}' does not have a valid date in the #{source}."
        )
      end
      data
    end

    def date
      data['date'] ||= site.time
    end

    # Returns whether the document is a draft. This is only the case if
    # the document is in the 'posts' collection but in a different
    # directory than '_posts'.
    #
    # Returns whether the document is a draft.
    def draft?
      data['draft'] ||= relative_path.index(collection.relative_directory).nil? && collection.label == "posts"
    end

    # The path to the document, relative to the site source.
    #
    # Returns a String path which represents the relative path
    #   from the site source to this document
    def relative_path
      @relative_path ||= Pathname.new(path).relative_path_from(Pathname.new(site.source)).to_s
    end

    # The output extension of the document.
    #
    # Returns the output extension
    def output_ext
      Jekyll::Renderer.new(site, self).output_ext
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
        relative_path[0..-extname.length - 1].sub(collection.relative_directory, "")
    end

    # Determine whether the document is a YAML file.
    #
    # Returns true if the extname is either .yml or .yaml, false otherwise.
    def yaml_file?
      %w(.yaml .yml).include?(extname)
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
      %w(.sass .scss).include?(extname)
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
      @url_placeholders ||= Drops::UrlDrop.new(self)
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
        :template => url_template,
        :placeholders => url_placeholders,
        :permalink => permalink
      }).to_s
    end

    def [](key)
      data[key]
    end

    # The full path to the output file.
    #
    # base_directory - the base path of the output directory
    #
    # Returns the full path to the output file of this document.
    def destination(base_directory)
      dest = site.in_dest_dir(base_directory)
      path = site.in_dest_dir(dest, URL.unescape_path(url))
      path = File.join(path, "index.html") if url.end_with?("/")
      path << output_ext unless path.end_with? output_ext
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

      trigger_hooks(:post_write)
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
      Jekyll.logger.debug "Reading:", relative_path

      if yaml_file?
        @data = SafeYAML.load_file(path)
      else
        begin
          defaults = @site.frontmatter_defaults.all(url, collection.label.to_sym)
          merge_data!(defaults, source: "front matter defaults") unless defaults.empty?

          self.content = File.read(path, Utils.merged_file_read_opts(site, opts))
          if content =~ YAML_FRONT_MATTER_REGEXP
            self.content = $POSTMATCH
            data_file = SafeYAML.load(Regexp.last_match(1))
            merge_data!(data_file, source: "YAML front matter") if data_file
          end

          post_read
        rescue SyntaxError => e
          Jekyll.logger.error "Error:", "YAML Exception reading #{path}: #{e.message}"
        rescue Exception => e
          if e.is_a? Jekyll::Errors::FatalException
            raise e
          end
          Jekyll.logger.error "Error:", "could not read file #{path}: #{e.message}"
        end
      end
    end

    def post_read
      if relative_path =~ DATE_FILENAME_MATCHER
        date, slug, ext = $2, $3, $4
        if !data['date'] || data['date'].to_i == site.time.to_i
          merge_data!({"date" => date}, source: "filename")
        end
      elsif relative_path =~ DATELESS_FILENAME_MATCHER
        slug, ext = $2, $3
      end

      # Try to ensure the user gets a title.
      data["title"] ||= Utils.titleize_slug(slug)
      # Only overwrite slug & ext if they aren't specified.
      data['slug'] ||= slug
      data['ext']  ||= ext

      populate_categories
      populate_tags
      generate_excerpt
    end

    # Add superdirectories of the special_dir to categories.
    # In the case of es/_posts, 'es' is added as a category.
    # In the case of _posts/es, 'es' is NOT added as a category.
    #
    # Returns nothing.
    def categories_from_path(special_dir)
      superdirs = relative_path.sub(/#{special_dir}(.*)/, '').split(File::SEPARATOR).reject do |c|
        c.empty? || c.eql?(special_dir) || c.eql?(basename)
      end
      merge_data!({ 'categories' => superdirs }, source: "file path")
    end

    def populate_categories
      merge_data!({
        'categories' => (
          Array(data['categories']) + Utils.pluralized_array_from_hash(data, 'category', 'categories')
        ).map(&:to_s).flatten.uniq
      })
    end

    def populate_tags
      merge_data!({
        "tags" => Utils.pluralized_array_from_hash(data, "tag", "tags").flatten
      })
    end

    # Create a Liquid-understandable version of this Document.
    #
    # Returns a Hash representing this Document's data.
    def to_liquid
      @to_liquid ||= Drops::DocumentDrop.new(self)
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
      output || content || 'NO CONTENT'
    end

    # Compare this document against another document.
    # Comparison is a comparison between the 2 paths of the documents.
    #
    # Returns -1, 0, +1 or nil depending on whether this doc's path is less than,
    #   equal or greater than the other doc's path. See String#<=> for more details.
    def <=>(other)
      return nil unless other.respond_to?(:data)
      cmp = data['date'] <=> other.data['date']
      cmp = path <=> other.path if cmp.nil? || cmp == 0
      cmp
    end

    # Determine whether this document should be written.
    # Based on the Collection to which it belongs.
    #
    # True if the document has a collection and if that collection's #write?
    #   method returns true, otherwise false.
    def write?
      collection && collection.write?
    end

    # The Document excerpt_separator, from the YAML Front-Matter or site
    # default excerpt_separator value
    #
    # Returns the document excerpt_separator
    def excerpt_separator
      (data['excerpt_separator'] || site.config['excerpt_separator']).to_s
    end

    # Whether to generate an excerpt
    #
    # Returns true if the excerpt separator is configured.
    def generate_excerpt?
      !excerpt_separator.empty?
    end

    def next_doc
      pos = collection.docs.index { |post| post.equal?(self) }
      if pos && pos < collection.docs.length - 1
        collection.docs[pos + 1]
      else
        nil
      end
    end

    def previous_doc
      pos = collection.docs.index { |post| post.equal?(self) }
      if pos && pos > 0
        collection.docs[pos - 1]
      else
        nil
      end
    end

    def trigger_hooks(hook_name, *args)
      Jekyll::Hooks.trigger collection.label.to_sym, hook_name, self, *args if collection
      Jekyll::Hooks.trigger :documents, hook_name, self, *args
    end

    def id
      @id ||= File.join(File.dirname(url), (data['slug'] || basename_without_ext).to_s)
    end

    # Calculate related posts.
    #
    # Returns an Array of related Posts.
    def related_posts
      Jekyll::RelatedPosts.new(self).build
    end

    # Override of normal respond_to? to match method_missing's logic for
    # looking in @data.
    def respond_to?(method, include_private = false)
      data.key?(method.to_s) || super
    end

    # Override of method_missing to check in @data for the key.
    def method_missing(method, *args, &blck)
      if data.key?(method.to_s)
        Jekyll.logger.warn "Deprecation:", "Document##{method} is now a key in the #data hash."
        Jekyll.logger.warn "", "Called by #{caller.first}."
        data[method.to_s]
      else
        super
      end
    end

    private # :nodoc:
    def generate_excerpt
      if generate_excerpt?
        data["excerpt"] ||= Jekyll::Excerpt.new(self)
      end
    end
  end
end
