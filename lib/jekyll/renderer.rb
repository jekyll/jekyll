# encoding: UTF-8

module Jekyll
  class Renderer

    attr_reader :document, :site, :site_payload

    def initialize(site, document, site_payload = nil)
      @site         = site
      @document     = document
      @site_payload = site_payload
    end

    # Determine which converters to use based on this document's
    # extension.
    #
    # Returns an array of Converter instances.
    def converters
      @converters ||= site.converters.select { |c| c.matches(document.extname) }
    end

    # Determine the extname the outputted file should have
    #
    # Returns the output extname including the leading period.
    def output_ext
      converters.first.output_ext(document.extname)
    end

    ######################
    ## DAT RENDER THO
    ######################

    def run
      payload = Utils.deep_merge_hashes({
        "page" => document.to_liquid
      }, site_payload || site.site_payload)

      info = {
        filters:   [Jekyll::Filters],
        registers: { :site => site, :page => payload['page'] }
      }

      # render and transform content (this becomes the final content of the object)
      payload["highlighter_prefix"] = converters.first.highlighter_prefix
      payload["highlighter_suffix"] = converters.first.highlighter_suffix

      output = document.content

      if document.render_with_liquid?
        output = render_liquid(output, payload, info)
      end

      output = convert(output)
      document.content = output

      if document.place_in_layout?
        place_in_layouts(
          output,
          payload,
          info
        )
      else
        output
      end
    end

    # Convert the given content using the converters which match this renderer's document.
    #
    # content - the raw, unconverted content
    #
    # Returns the converted content.
    def convert(content)
      converters.reduce(content) do |output, converter|
        begin
          converter.convert output
        rescue => e
          Jekyll.logger.error "Conversion error:", "#{converter.class} encountered an error while converting '#{document.relative_path}':"
          Jekyll.logger.error("", e.to_s)
          raise e
        end
      end
    end

    # Render the given content with the payload and info
    #
    # content -
    # payload -
    # info    -
    # path    - (optional) the path to the file, for use in ex
    #
    # Returns the content, rendered by Liquid.
    def render_liquid(content, payload, info, path = nil)
      Liquid::Template.parse(content).render!(payload, info)
    rescue Tags::IncludeTagError => e
      Jekyll.logger.error "Liquid Exception:", "#{e.message} in #{e.path}, included in #{path || document.relative_path}"
      raise e
    rescue Exception => e
      Jekyll.logger.error "Liquid Exception:", "#{e.message} in #{path || document.relative_path}"
      raise e
    end

    # Checks if the layout specified in the document actually exists
    #
    # layout - the layout to check
    #
    # Returns true if the layout is invalid, false if otherwise
    def invalid_layout?(layout)
      !document.data["layout"].nil? && layout.nil?
    end

    # Render layouts and place given content inside.
    #
    # content - the content to be placed in the layout
    #
    #
    # Returns the content placed in the Liquid-rendered layouts
    def place_in_layouts(content, payload, info)
      output = content.dup
      layout = site.layouts[document.data["layout"]]

      Jekyll.logger.warn("Build Warning:", "Layout '#{document.data["layout"]}' requested in #{document.relative_path} does not exist.") if invalid_layout? layout

      used   = Set.new([layout])

      while layout
        payload = Utils.deep_merge_hashes(
          payload,
          {
            "content" => output,
            "page"    => document.to_liquid,
            "layout"  => layout.data
          }
        )

        output = render_liquid(
          layout.content,
          payload,
          info,
          File.join(site.config['layouts'], layout.name)
        )

        # Add layout to dependency tree
        site.regenerator.add_dependency(
          site.in_source_dir(document.path),
          site.in_source_dir(layout.path)
        ) if document.write?

        if layout = site.layouts[layout.data["layout"]]
          if used.include?(layout)
            layout = nil # avoid recursive chain
          else
            used << layout
          end
        end
      end

      output
    end

  end
end
