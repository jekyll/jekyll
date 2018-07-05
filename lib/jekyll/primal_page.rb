# frozen_string_literal: true

module Jekyll
  # A precursor class that encompasses common methods for various convertible types (types that
  # are not considered 'static' and are processed during the build process).
  # Initializing this class directly is not recommended.
  class PrimalPage
    attr_reader   :site, :dir, :path, :relative_path

    attr_accessor :name, :ext, :basename_without_ext,
                  :data, :content, :output

    alias_method  :basename, :name
    alias_method  :extname, :ext

    attr_writer   :basename, :extname

    # For backwards compatibility with Jekyll::Page descendants older than v4.0, initialize a
    # slimmer version of the former Jekyll::Page::ATTRIBUTES_FOR_LIQUID to avoid unnecessary
    # computation.
    ATTRIBUTES_FOR_LIQUID = %w(dir name).freeze

    def initialize(site, base, dir, name)
      @site = site
      @dir  = dir
      @name = name
      base  = @site.source if base.nil? || base.empty? || base.include?("../")

      @relative_path = Jekyll.sanitized_path(dir, name).sub(%r!\A/!, "")
      @path = Jekyll.sanitized_path(base, @relative_path)

      process(name)

      @data = {} # ensures that data is always a Hash by default
      read_yaml File.join(base, dir), name # arguments passed only for compatibility with plugins.

      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, type, key)
      end

      trigger_hooks :post_init
    end

    def process(name)
      self.ext = File.extname(name)
      self.basename_without_ext = File.basename(name, ".*")
    end

    # The string representation for this document.
    #
    # Returns the content of the document
    def to_s
      output || content || "NO CONTENT"
    end

    # Whether the file is published or not, as indicated in YAML front-matter
    def published?
      !(data.key?("published") && data["published"] == false)
    end

    # Read the YAML frontmatter.
    #
    # opts - optional parameter to File.read, default at site configs
    #
    # Returns nothing.
    # rubocop:disable Metrics/AbcSize
    def read_yaml(*_args, **opts)
      begin
        self.content = File.read(path, Utils.merged_file_read_opts(site, opts))
        if content =~ Document::YAML_FRONT_MATTER_REGEXP
          self.content = $POSTMATCH
          self.data = SafeYAML.load(Regexp.last_match(1))
        end
      rescue Psych::SyntaxError => e
        Jekyll.logger.warn "YAML Exception reading #{path}: #{e.message}"
        raise e if site.config["strict_front_matter"]
      rescue StandardError => e
        Jekyll.logger.warn "Error reading file #{path}: #{e.message}"
        raise e if site.config["strict_front_matter"]
      end

      self.data ||= {}

      validate_data! path
      validate_permalink! path

      self.data
    end
    # rubocop:enable Metrics/AbcSize

    def validate_data!(filename)
      unless self.data.is_a?(Hash)
        raise Errors::InvalidYAMLFrontMatterError,
              "Invalid YAML front matter in #{filename}"
      end
    end

    def validate_permalink!(filename)
      if self.data["permalink"]&.to_s&.empty?
        raise Errors::InvalidPermalinkError, "Invalid permalink in #{filename}"
      end
    end

    # Returns the object as a debug String.
    def inspect
      "#<#{self.class.name} @name=#{name.inspect}>"
    end

    # Transform the contents based on the content type.
    #
    # Returns the transformed contents.
    def transform
      renderer.convert(content)
    end

    # Determine the extension depending on content_type.
    #
    # Returns the String extension for the output file.
    #   e.g. ".html" for an HTML output file.
    def output_ext
      renderer.output_ext
    end

    # Determine which converter to use based on this convertible's
    # extension.
    #
    # Returns the Converter instance.
    def converters
      renderer.converters
    end

    # Render Liquid in the content
    #
    # content - the raw Liquid content to render
    # payload - the payload for Liquid
    # info    - the info for Liquid
    #
    # Returns the converted content
    def render_liquid(content, payload, info, path)
      renderer.render_liquid(content, payload, info, path)
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
      extname == ".coffee"
    end

    # Determine whether the file should be rendered with Liquid.
    #
    # Returns false if the document is a yaml file, or if the document doesn't
    #   contain any Liquid Tags or Variables, true otherwise.
    def render_with_liquid?
      return false if data["render_with_liquid"] == false
      !(yaml_file? || !Utils.has_liquid_construct?(content))
    end

    # Determine whether the file should be placed into layouts.
    #
    # Returns false if the document is set to `layouts: none`, or is either an
    #   asset file or a yaml file. Returns true otherwise.
    def place_in_layout?
      !(asset_file? || yaml_file? || no_layout?)
    end

    # Checks if the layout specified in the document actually exists
    #
    # layout - the layout to check
    #
    # Returns true if the layout is invalid, false if otherwise
    def invalid_layout?(layout)
      !data["layout"].nil? && layout.nil? && !(is_a? Jekyll::Excerpt)
    end

    # Recursively render layouts
    #
    # layouts - a list of the layouts
    # payload - the payload for Liquid
    # info    - the info for Liquid
    #
    # Returns nothing
    def render_all_layouts(layouts, payload, info)
      renderer.layouts = layouts
      self.output = renderer.place_in_layouts(output, payload, info)
    end

    # Add any necessary layouts to this convertible document.
    #
    # payload - The site payload Drop or Hash.
    # layouts - A Hash of {"name" => "layout"}.
    #
    # Returns nothing.
    def do_layout(payload, layouts)
      self.output = renderer.tap do |render|
        render.layouts = layouts
        render.payload = payload
      end.run

      Jekyll.logger.debug "Post-Render Hooks:", relative_path
      trigger_hooks :post_render
    end

    # Write the generated page file to the destination directory.
    #
    # dest - The String path to the destination dir.
    #
    # Returns nothing.
    def write(dest)
      path = destination(dest)
      FileUtils.mkdir_p(File.dirname(path))
      Jekyll.logger.debug "Writing:", path
      File.write(path, output, :mode => "wb")

      trigger_hooks(:post_write)
    end

    # Create a Liquid-understandable version of this Page.
    #
    # Returns a Hash representing this Page's data.
    def to_liquid
      @to_liquid ||= Utils.deep_merge_hashes(
        site.frontmatter_defaults.all(relative_path, type),
        Utils.deep_merge_hashes(legacy_data, Drops::PageDrop.new(self))
      )
    end

    # Accessor for data properties by Liquid.
    #
    # property - The String name of the property to retrieve.
    #
    # Returns the String value or nil if the property isn't included.
    def [](property)
      to_liquid[property] || data[property]
    end

    def trigger_hooks(hook_name, *args)
      Jekyll::Hooks.trigger hook_owner, hook_name, self, *args
    end

    def type
      nil
    end

    private

    def legacy_data
      Hash[
        self.class::ATTRIBUTES_FOR_LIQUID.map { |attribute| [attribute, send(attribute)] }
      ]
    end

    def renderer
      @renderer ||= Jekyll::Renderer.new(@site, self)
    end

    def hook_owner
      nil
    end

    # Returns true if the Front Matter specifies that `layout` is set to `none`.
    def no_layout?
      data["layout"] == "none"
    end
  end
end
