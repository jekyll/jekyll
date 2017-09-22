# frozen_string_literal: true

require "set"

# Convertible provides methods for converting a pagelike item
# from a certain type of markup into actual content
#
# Requires
#   self.site -> Jekyll::Site
#   self.content
#   self.content=
#   self.data=
#   self.ext=
#   self.output=
#   self.name
#   self.path
#   self.type -> :page, :post or :draft

module Jekyll
  module Convertible
    # Returns the contents as a String.
    def to_s
      content || ""
    end

    # Whether the file is published or not, as indicated in YAML front-matter
    def published?
      !(data.key?("published") && data["published"] == false)
    end

    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    # opts - optional parameter to File.read, default at site configs
    #
    # Returns nothing.
    # rubocop:disable Metrics/AbcSize
    def read_yaml(base, name, opts = {})
      filename = File.join(base, name)

      begin
        self.content = File.read(@path || site.in_source_dir(base, name),
                                 Utils.merged_file_read_opts(site, opts))
        if content =~ Document::YAML_FRONT_MATTER_REGEXP
          self.content = $POSTMATCH
          self.data = SafeYAML.load(Regexp.last_match(1))
        end
      rescue SyntaxError => e
        Jekyll.logger.warn "YAML Exception reading #{filename}: #{e.message}"
        raise e if self.site.config["strict_front_matter"]
      rescue => e
        Jekyll.logger.warn "Error reading file #{filename}: #{e.message}"
        raise e if self.site.config["strict_front_matter"]
      end

      self.data ||= {}

      validate_data! filename
      validate_permalink! filename

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
      if self.data["permalink"] && self.data["permalink"].to_s.empty?
        raise Errors::InvalidPermalinkError, "Invalid permalink in #{filename}"
      end
    end

    # Transform the contents based on the content type.
    #
    # Returns the transformed contents.
    def transform
      _renderer.convert(content)
    end

    # Determine the extension depending on content_type.
    #
    # Returns the String extension for the output file.
    #   e.g. ".html" for an HTML output file.
    def output_ext
      _renderer.output_ext
    end

    # Determine which converter to use based on this convertible's
    # extension.
    #
    # Returns the Converter instance.
    def converters
      _renderer.converters
    end

    # Render Liquid in the content
    #
    # content - the raw Liquid content to render
    # payload - the payload for Liquid
    # info    - the info for Liquid
    #
    # Returns the converted content
    def render_liquid(content, payload, info, path)
      _renderer.render_liquid(content, payload, info, path)
    end
    # rubocop: enable RescueException

    # Convert this Convertible's data to a Hash suitable for use by Liquid.
    #
    # Returns the Hash representation of this Convertible.
    def to_liquid(attrs = nil)
      further_data = Hash[(attrs || self.class::ATTRIBUTES_FOR_LIQUID).map do |attribute|
        [attribute, send(attribute)]
      end]

      defaults = site.frontmatter_defaults.all(relative_path, type)
      Utils.deep_merge_hashes defaults, Utils.deep_merge_hashes(data, further_data)
    end

    # The type of a document,
    #   i.e., its classname downcase'd and to_sym'd.
    #
    # Returns the type of self.
    def type
      if is_a?(Page)
        :pages
      end
    end

    # returns the owner symbol for hook triggering
    def hook_owner
      if is_a?(Page)
        :pages
      end
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
      %w(.sass .scss).include?(ext)
    end

    # Determine whether the document is a CoffeeScript file.
    #
    # Returns true if extname == .coffee, false otherwise.
    def coffeescript_file?
      ext == ".coffee"
    end

    # Determine whether the file should be rendered with Liquid.
    #
    # Always returns true.
    def render_with_liquid?
      true
    end

    # Determine whether the file should be placed into layouts.
    #
    # Returns false if the document is an asset file.
    def place_in_layout?
      !asset_file?
    end

    # Checks if the layout specified in the document actually exists
    #
    # layout - the layout to check
    #
    # Returns true if the layout is invalid, false if otherwise
    def invalid_layout?(layout)
      !data["layout"].nil? && layout.nil? && !(self.is_a? Jekyll::Excerpt)
    end

    # Recursively render layouts
    #
    # layouts - a list of the layouts
    # payload - the payload for Liquid
    # info    - the info for Liquid
    #
    # Returns nothing
    def render_all_layouts(layouts, payload, info)
      _renderer.layouts = layouts
      self.output = _renderer.place_in_layouts(output, payload, info)
    ensure
      @_renderer = nil # this will allow the modifications above to disappear
    end

    # Add any necessary layouts to this convertible document.
    #
    # payload - The site payload Drop or Hash.
    # layouts - A Hash of {"name" => "layout"}.
    #
    # Returns nothing.
    def do_layout(payload, layouts)
      self.output = _renderer.tap do |renderer|
        renderer.layouts = layouts
        renderer.payload = payload
      end.run

      Jekyll.logger.debug "Post-Render Hooks:", self.relative_path
      Jekyll::Hooks.trigger hook_owner, :post_render, self
    ensure
      @_renderer = nil # this will allow the modifications above to disappear
    end

    # Write the generated page file to the destination directory.
    #
    # dest - The String path to the destination dir.
    #
    # Returns nothing.
    def write(dest)
      path = destination(dest)
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, output, :mode => "wb")
      Jekyll::Hooks.trigger hook_owner, :post_write, self
    end

    # Accessor for data properties by Liquid.
    #
    # property - The String name of the property to retrieve.
    #
    # Returns the String value or nil if the property isn't included.
    def [](property)
      if self.class::ATTRIBUTES_FOR_LIQUID.include?(property)
        send(property)
      else
        data[property]
      end
    end

    private
    def _renderer
      @_renderer ||= Jekyll::Renderer.new(site, self)
    end
  end
end
