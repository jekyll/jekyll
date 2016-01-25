# encoding: UTF-8

module Jekyll
  class Renderer
    attr_reader :document, :site, :payload

    def initialize(site, document, site_payload = nil)
      @site     = site
      @document = document
      @payload  = site_payload || site.site_payload
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
      @output_ext ||= (permalink_ext || converter_output_ext)
    end

    ######################
    ## DAT RENDER THO
    ######################

    def run
      Jekyll.logger.debug "Rendering:", document.relative_path

      payload["page"] = document.to_liquid

      if document.respond_to? :pager
        payload["paginator"] = document.pager.to_liquid
      end

      if document.is_a?(Document) && document.collection.label == 'posts'
        payload['site']['related_posts'] = document.related_posts
      end

      # render and transform content (this becomes the final content of the object)
      payload['highlighter_prefix'] = converters.first.highlighter_prefix
      payload['highlighter_suffix'] = converters.first.highlighter_suffix

      Jekyll.logger.debug "Pre-Render Hooks:", document.relative_path
      document.trigger_hooks(:pre_render, payload)

      info = {
        :filters   => [Jekyll::Filters],
        :registers => { :site => site, :page => payload['page'] }
      }

      output = document.content

      if document.render_with_liquid?
        Jekyll.logger.debug "Rendering Liquid:", document.relative_path
        output = render_liquid(output, payload, info, document.path)
      end

      Jekyll.logger.debug "Rendering Markup:", document.relative_path
      output = convert(output)
      document.content = output

      if document.place_in_layout?
        Jekyll.logger.debug "Rendering Layout:", document.relative_path
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
      site.liquid_renderer.file(path).parse(content).render!(payload, info)
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
        payload['content'] = output
        payload['page']    = document.to_liquid
        payload['layout']  = Utils.deep_merge_hashes(payload['layout'] || {}, layout.data)

        output = render_liquid(
          layout.content,
          payload,
          info,
          File.join(site.config['layouts_dir'], layout.name)
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

    private

    def permalink_ext
      if document.permalink && !document.permalink.end_with?("/")
        permalink_ext = File.extname(document.permalink)
        permalink_ext unless permalink_ext.empty?
      end
    end

    def converter_output_ext
      if output_exts.size == 1
        output_exts.last
      else
        output_exts[-2]
      end
    end

    def output_exts
      @output_exts ||= converters.map do |c|
        c.output_ext(document.extname)
      end.compact
    end
  end
end
