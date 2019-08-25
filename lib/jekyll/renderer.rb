# frozen_string_literal: true

module Jekyll
  class Renderer
    attr_reader :document, :site
    attr_writer :layouts, :payload

    def initialize(site, document, site_payload = nil)
      @site     = site
      @document = document
      @payload  = site_payload
      @layouts  = nil
    end

    # Fetches the payload used in Liquid rendering.
    # It can be written with #payload=(new_payload)
    # Falls back to site.site_payload if no payload is set.
    #
    # Returns a Jekyll::Drops::UnifiedPayloadDrop
    def payload
      @payload ||= site.site_payload
    end

    # The list of layouts registered for this Renderer.
    # It can be written with #layouts=(new_layouts)
    # Falls back to site.layouts if no layouts are registered.
    #
    # Returns a Hash of String => Jekyll::Layout identified
    # as basename without the extension name.
    def layouts
      @layouts || site.layouts
    end

    # Determine which converters to use based on this document's
    # extension.
    #
    # Returns Array of Converter instances.
    def converters
      @converters ||= site.converters.select { |c| c.matches(document.extname) }.sort
    end

    # Determine the extname the outputted file should have
    #
    # Returns String the output extname including the leading period.
    def output_ext
      @output_ext ||= (permalink_ext || converter_output_ext)
    end

    # Prepare payload and render the document
    #
    # Returns String rendered document output
    def run
      Jekyll.logger.debug "Rendering:", document.relative_path

      assign_pages!
      assign_current_document!
      assign_highlighter_options!
      assign_layout_data!

      Jekyll.logger.debug "Pre-Render Hooks:", document.relative_path
      document.trigger_hooks(:pre_render, payload)

      render_document
    end

    # Render the document.
    #
    # Returns String rendered document output
    # rubocop: disable AbcSize
    def render_document
      info = {
        :registers        => { :site => site, :page => payload["page"] },
        :strict_filters   => liquid_options["strict_filters"],
        :strict_variables => liquid_options["strict_variables"],
      }

      output = document.content
      if document.render_with_liquid?
        Jekyll.logger.debug "Rendering Liquid:", document.relative_path
        output = render_liquid(output, payload, info, document.path)
      end

      Jekyll.logger.debug "Rendering Markup:", document.relative_path
      output = convert(output.to_s)
      document.content = output

      if document.place_in_layout?
        Jekyll.logger.debug "Rendering Layout:", document.relative_path
        output = place_in_layouts(output, payload, info)
      end

      output
    end
    # rubocop: enable AbcSize

    # Convert the document using the converters which match this renderer's document.
    #
    # Returns String the converted content.
    def convert(content)
      converters.reduce(content) do |output, converter|
        begin
          converter.convert output
        rescue StandardError => e
          Jekyll.logger.error "Conversion error:",
                              "#{converter.class} encountered an error while "\
                              "converting '#{document.relative_path}':"
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
    # Returns String the content, rendered by Liquid.
    def render_liquid(content, payload, info, path = nil)
      template = site.liquid_renderer.file(path).parse(content)
      template.warnings.each do |e|
        Jekyll.logger.warn "Liquid Warning:",
                           LiquidRenderer.format_error(e, path || document.relative_path)
      end
      template.render!(payload, info)
    # rubocop: disable RescueException
    rescue Exception => e
      Jekyll.logger.error "Liquid Exception:",
                          LiquidRenderer.format_error(e, path || document.relative_path)
      raise e
    end
    # rubocop: enable RescueException

    # Checks if the layout specified in the document actually exists
    #
    # layout - the layout to check
    #
    # Returns Boolean true if the layout is invalid, false if otherwise
    def invalid_layout?(layout)
      !document.data["layout"].nil? && layout.nil? && !(document.is_a? Jekyll::Excerpt)
    end

    # Render layouts and place document content inside.
    #
    # Returns String rendered content
    def place_in_layouts(content, payload, info)
      output = content.dup
      layout = layouts[document.data["layout"].to_s]
      validate_layout(layout)

      used = Set.new([layout])

      # Reset the payload layout data to ensure it starts fresh for each page.
      payload["layout"] = nil

      while layout
        output = render_layout(output, layout, info)
        add_regenerator_dependencies(layout)

        next unless (layout = site.layouts[layout.data["layout"]])
        break if used.include?(layout)

        used << layout
      end
      output
    end

    private

    # Checks if the layout specified in the document actually exists
    #
    # layout - the layout to check
    # Returns nothing
    def validate_layout(layout)
      if invalid_layout?(layout)
        Jekyll.logger.warn(
          "Build Warning:",
          "Layout '#{document.data["layout"]}' requested "\
          "in #{document.relative_path} does not exist."
        )
      elsif !layout.nil?
        layout_source = layout.path.start_with?(site.source) ? :site : :theme
        Jekyll.logger.debug "Layout source:", layout_source
      end
    end

    # Render layout content into document.output
    #
    # Returns String rendered content
    def render_layout(output, layout, info)
      payload["content"] = output
      payload["layout"]  = Utils.deep_merge_hashes(layout.data, payload["layout"] || {})

      render_liquid(
        layout.content,
        payload,
        info,
        layout.relative_path
      )
    end

    def add_regenerator_dependencies(layout)
      return unless document.write?

      site.regenerator.add_dependency(
        site.in_source_dir(document.path),
        layout.path
      )
    end

    # Set page content to payload and assign pager if document has one.
    #
    # Returns nothing
    def assign_pages!
      payload["page"] = document.to_liquid
      payload["paginator"] = (document.pager.to_liquid if document.respond_to?(:pager))
    end

    # Set related posts to payload if document is a post.
    #
    # Returns nothing
    def assign_current_document!
      payload["site"].current_document = document
    end

    # Set highlighter prefix and suffix
    #
    # Returns nothing
    def assign_highlighter_options!
      payload["highlighter_prefix"] = converters.first.highlighter_prefix
      payload["highlighter_suffix"] = converters.first.highlighter_suffix
    end

    def assign_layout_data!
      layout = layouts[document.data["layout"]]
      payload["layout"] = Utils.deep_merge_hashes(layout.data, payload["layout"] || {}) if layout
    end

    def permalink_ext
      document_permalink = document.permalink
      if document_permalink && !document_permalink.end_with?("/")
        permalink_ext = File.extname(document_permalink)
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

    def liquid_options
      @liquid_options ||= site.config["liquid"]
    end
  end
end
