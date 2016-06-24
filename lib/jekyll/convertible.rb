# encoding: UTF-8

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
    #
    # Returns 'false' if the 'published' key is specified in the
    # YAML front-matter and is 'false'. Otherwise returns 'true'.
    def published?
      !(data.key?("published") && data["published"] == false)
    end

    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    # opts - optional parameter to File.read, default at site configs
    #
    # Returns String data read from file.
    def read_yaml(base, name, opts = {})
      filename = File.join(base, name)

      read_data filename, opts
      validate_data! filename
      validate_permalink! filename

      self.data
    end

    # Determine the extension depending on content_type.
    #
    # Returns the String extension for the output file.
    #   e.g. ".html" for an HTML output file.
    def output_ext
      Jekyll::Renderer.new(site, self).output_ext
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
      ".coffee" == ext
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

    # Write the generated page file to the destination directory.
    #
    # dest - The String path to the destination dir.
    #
    # Returns nothing.
    def write(dest)
      path = destination(dest)
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, output)
      trigger_hooks(:post_write)
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
    def read_data(filename, opts = {})
      begin
        self.content = File.read(@path || site.in_source_dir(filename),
                                 Utils.merged_file_read_opts(site, opts))
        if content =~ Document::YAML_FRONT_MATTER_REGEXP
          self.content = $POSTMATCH
          self.data = SafeYAML.load(Regexp.last_match(1))
        end
      rescue SyntaxError => e
        Jekyll.logger.warn "YAML Exception reading #{filename}: #{e.message}"
      # rubocop:disable RescueException
      rescue Exception => e
        Jekyll.logger.warn "Error reading file #{filename}: #{e.message}"
      end
      # rubocop:enable RescueException

      self.data ||= {}
    end

    private
    def validate_data!(filename)
      unless self.data.is_a?(Hash)
        raise(
          Errors::InvalidYAMLFrontMatterError,
          "Invalid YAML front matter in #{filename}"
        )
      end
    end

    private
    def validate_permalink!(filename)
      if self.data["permalink"] && self.data["permalink"].empty?
        raise Errors::InvalidPermalinkError, "Invalid permalink in #{filename}"
      end
    end
  end
end
