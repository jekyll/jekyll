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
      !(data.has_key?('published') && data['published'] == false)
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
      if name.start_with?("/")
        name = name.gsub("#{base}/", "")
      end
      filename = File.join(base, name)
      begin
        self.content = site.fs.read(filename, merged_file_read_opts(opts))
        if content =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
          self.content = $POSTMATCH
          self.data = SafeYAML.load($1)
        end
      rescue SyntaxError => e
        Jekyll.logger.warn "YAML Exception reading #{filename}: #{e.message}"
      rescue Exception => e
        Jekyll.logger.warn "Error reading file #{filename}: #{e.message}"
      end

      self.data ||= {}
    end

    # Transform the contents based on the content type.
    #
    # Returns nothing.
    def transform
      self.content = converter.convert(content)
    rescue => e
      Jekyll.logger.error "Conversion error:", "There was an error converting" +
        " '#{path}'."
      raise e
    end

    # Determine the extension depending on content_type.
    #
    # Returns the String extension for the output file.
    #   e.g. ".html" for an HTML output file.
    def output_ext
      converter.output_ext(ext)
    end

    # Determine which converter to use based on this convertible's
    # extension.
    #
    # Returns the Converter instance.
    def converter
      @converter ||= site.converters.find { |c| c.matches(ext) }
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
      if is_a?(Post)
        :post
      elsif is_a?(Page)
        :page
      elsif is_a?(Draft)
        :draft
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
