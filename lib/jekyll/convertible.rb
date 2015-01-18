# encoding: UTF-8

require 'set'

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
      content || ''
    end

    # Whether the file is published or not, as indicated in YAML front-matter
    def published?
      !(data.key?('published') && data['published'] == false)
    end

    # Returns merged option hash for File.read of self.site (if exists)
    # and a given param
    def merged_file_read_opts(opts)
      (site ? site.file_read_opts : {}).merge(opts)
    end

    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    # opts - optional parameter to File.read, default at site configs
    #
    # Returns nothing.
    def read_yaml(base, name, opts = {})
      begin
        self.content = File.read(site.in_source_dir(base, name),
                                 merged_file_read_opts(opts))
        if content =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
          self.content = $POSTMATCH
          self.data = SafeYAML.load($1)
        end
      rescue SyntaxError => e
        Jekyll.logger.warn "YAML Exception reading #{File.join(base, name)}: #{e.message}"
      rescue Exception => e
        Jekyll.logger.warn "Error reading file #{File.join(base, name)}: #{e.message}"
      end

      self.data ||= {}
    end

    # Transform the contents based on the content type.
    #
    # Returns the transformed contents.
    def transform
      converters.reduce(content) do |output, converter|
        begin
          converter.convert output
        rescue => e
          Jekyll.logger.error "Conversion error:", "#{converter.class} encountered an error while converting '#{path}':"
          Jekyll.logger.error("", e.to_s)
          raise e
        end
      end
    end

    # Determine the extension depending on content_type.
    #
    # Returns the String extension for the output file.
    #   e.g. ".html" for an HTML output file.
    def output_ext
      if converters.all? { |c| c.is_a?(Jekyll::Converters::Identity) }
        ext
      else
        converters.map { |c|
          c.output_ext(ext) unless c.is_a?(Jekyll::Converters::Identity)
        }.compact.last
      end
    end

    # Determine which converter to use based on this convertible's
    # extension.
    #
    # Returns the Converter instance.
    def converters
      @converters ||= site.converters.select { |c| c.matches(ext) }.sort
    end

    # Render Liquid in the content
    #
    # content - the raw Liquid content to render
    # payload - the payload for Liquid
    # info    - the info for Liquid
    #
    # Returns the converted content
    def render_liquid(content, payload, info, path = nil)
      Liquid::Template.parse(content).render!(payload, info)
    rescue Tags::IncludeTagError => e
      Jekyll.logger.error "Liquid Exception:", "#{e.message} in #{e.path}, included in #{path || self.path}"
      raise e
    rescue Exception => e
      Jekyll.logger.error "Liquid Exception:", "#{e.message} in #{path || self.path}"
      raise e
    end

    # Convert this Convertible's data to a Hash suitable for use by Liquid.
    #
    # Returns the Hash representation of this Convertible.
    def to_liquid(attrs = nil)
      further_data = Hash[(attrs || self.class::ATTRIBUTES_FOR_LIQUID).map { |attribute|
        [attribute, send(attribute)]
      }]

      defaults = site.frontmatter_defaults.all(relative_path, type)
      Utils.deep_merge_hashes defaults, Utils.deep_merge_hashes(data, further_data)
    end

    # The type of a document,
    #   i.e., its classname downcase'd and to_sym'd.
    #
    # Returns the type of self.
    def type
      if is_a?(Draft)
        :drafts
      elsif is_a?(Post)
        :posts
      elsif is_a?(Page)
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
      %w[.sass .scss].include?(ext)
    end

    # Determine whether the document is a CoffeeScript file.
    #
    # Returns true if extname == .coffee, false otherwise.
    def coffeescript_file?
      '.coffee'.eql?(ext)
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
      # recursively render layouts
      layout = layouts[data["layout"]]

      Jekyll.logger.warn("Build Warning:", "Layout '#{data["layout"]}' requested in #{path} does not exist.") if invalid_layout? layout

      used = Set.new([layout])

      while layout
        payload = Utils.deep_merge_hashes(payload, {"content" => output, "page" => layout.data})

        self.output = render_liquid(layout.content,
                                         payload,
                                         info,
                                         File.join(site.config['layouts'], layout.name))

        # Add layout to dependency tree
        site.regenerator.add_dependency(
          site.in_source_dir(path),
          site.in_source_dir(layout.path)
        )

        if layout = layouts[layout.data["layout"]]
          if used.include?(layout)
            layout = nil # avoid recursive chain
          else
            used << layout
          end
        end
      end
    end

    # Add any necessary layouts to this convertible document.
    #
    # payload - The site payload Hash.
    # layouts - A Hash of {"name" => "layout"}.
    #
    # Returns nothing.
    def do_layout(payload, layouts)
      info = { :filters => [Jekyll::Filters], :registers => { :site => site, :page => payload['page'] } }

      # render and transform content (this becomes the final content of the object)
      payload["highlighter_prefix"] = converters.first.highlighter_prefix
      payload["highlighter_suffix"] = converters.first.highlighter_suffix

      self.content = render_liquid(content, payload, info) if render_with_liquid?
      self.content = transform

      # output keeps track of what will finally be written
      self.output = content

      render_all_layouts(layouts, payload, info) if place_in_layout?
    end

    # Write the generated page file to the destination directory.
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
  end
end
