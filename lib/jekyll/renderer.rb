module Jekyll
  class Renderer

    attr_reader :document, :site

    def initialize(site, document)
      @site     = site
      @document = document
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
      }, site.site_payload)

      info = {
        filters:   [Jekyll::Filters],
        registers: { :site => site, :page => payload["page"] }
      }

      # render and transform content (this becomes the final content of the object)
      payload["highlighter_prefix"] = converters.first.highlighter_prefix
      payload["highlighter_suffix"] = converters.first.highlighter_suffix

      output = document.content

      if document.render_with_liquid?
        output = render_liquid(output, payload, info)
      end

      if document.place_in_layout?
        place_in_layouts(
          convert(output),
          payload,
          info
        )
      else
        convert(output)
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
          Jekyll.logger.error "Conversion error:", "#{converter.class} encountered an error converting '#{document.relative_path}'."
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

    # Render layouts and place given content inside.
    #
    # content - the content to be placed in the layout
    #
    #
    # Returns the content placed in the Liquid-rendered layouts
    def place_in_layouts(content, payload, info)
      output = content.dup
      layout = site.layouts[document.data["layout"]]
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
          File.join(site.config["layouts"], layout.name)
        )

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
