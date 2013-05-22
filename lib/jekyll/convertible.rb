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
module Jekyll
  module Convertible
    # Returns the contents as a String.
    def to_s
      self.content || ''
    end

    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    #
    # Returns nothing.
    def read_yaml(base, name)
      begin
        self.content = File.read(File.join(base, name))

        # Look for a .metadata file nearby.

        if File.exists? File.join(base, "#{name}.metadata")
          # Yay, found metadata file.
          metadata = File.read(File.join(base, "#{name}.metadata"))
          self.data = YAML.safe_load(metadata)
        end

        if self.content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
          # File begins with YAML front matter
          self.content = $POSTMATCH
          if self.data
            # We already have some metadata, maybe from the external file;
            # the data in the file itself takes precedence.
            self.data.merge!(YAML.safe_load($1))
          else
            self.data = YAML.safe_load($1)
          end
        end
      rescue SyntaxError => e
        puts "YAML Exception reading #{File.join(base, name)}: #{e.message}"
      rescue Exception => e
        puts "Error reading file #{File.join(base, name)}: #{e.message}"
      end

      self.data ||= {}
    end

    # Transform the contents based on the content type.
    #
    # Returns nothing.
    def transform
      self.content = converter.convert(self.content)
    end

    # Determine the extension depending on content_type.
    #
    # Returns the String extension for the output file.
    #   e.g. ".html" for an HTML output file.
    def output_ext
      converter.output_ext(self.ext)
    end

    # Determine which converter to use based on this convertible's
    # extension.
    #
    # Returns the Converter instance.
    def converter
      @converter ||= self.site.converters.find { |c| c.matches(self.ext) }
    end

    # Render Liquid in the content
    #
    # content - the raw Liquid content to render
    # payload - the payload for Liquid
    # info    - the info for Liquid
    #
    # Returns the converted content
    def render_liquid(content, payload, info)
      Liquid::Template.parse(content).render!(payload, info)
    rescue Exception => e
      Jekyll.logger.error "Liquid Exception:", "#{e.message} in #{payload[:file]}"
      raise e
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
      layout = layouts[self.data["layout"]]
      used = Set.new([layout])

      while layout
        payload = payload.deep_merge({"content" => self.output, "page" => layout.data})

        self.output = self.render_liquid(layout.content,
                                         payload.merge({:file => layout.name}),
                                         info)

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
      info = { :filters => [Jekyll::Filters], :registers => { :site => self.site, :page => payload['page'] } }

      # render and transform content (this becomes the final content of the object)
      payload["pygments_prefix"] = converter.pygments_prefix
      payload["pygments_suffix"] = converter.pygments_suffix

      self.content = self.render_liquid(self.content,
                                        payload.merge({:file => self.name}),
                                        info)
      self.transform

      # output keeps track of what will finally be written
      self.output = self.content

      self.render_all_layouts(layouts, payload, info)
    end

    # Write the generated page file to the destination directory.
    #
    # dest - The String path to the destination dir.
    #
    # Returns nothing.
    def write(dest)
      path = destination(dest)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |f|
        f.write(self.output)
      end
    end
  end
end
