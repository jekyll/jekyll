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
      Jekyll.logger.debug "Rendering:", relative_path

      assign_pages
      assign_related_posts
      assign_highlighter_options

      Jekyll.logger.debug "Pre-Render Hooks:", relative_path
      document.trigger_hooks(:pre_render, payload)

      render_document

      document.output
    end

    # Set page content to payload and assign pager if document has one.
    #
    # Returns nothing
    private
    def assign_pages
      payload["page"] = document.to_liquid
      if document.respond_to? :pager
        payload["paginator"] = document.pager.to_liquid
      end
    end

    # Set related posts to payload if document is a post.
    #
    # Returns nothing
    private
    def assign_related_posts
      if document.is_a?(Document) && document.collection.label == "posts"
        payload["site"]["related_posts"] = document.related_posts
      else
        payload["site"]["related_posts"] = nil
      end
    end

    # Set highlighter prefix and suffix
    #
    # Returns nothing
    private
    def assign_highlighter_options
      payload["highlighter_prefix"] = converters.first.highlighter_prefix
      payload["highlighter_suffix"] = converters.first.highlighter_suffix
    end

    # Render the document.
    # Puts rendered content into document.output
    #
    # Returns nothing
    private
    def render_document
      if document.render_with_liquid?
        Jekyll.logger.debug "Rendering Liquid:", relative_path
        document.output = render_liquid(document.content, path)
      end

      document.content = convert

      if document.place_in_layout?
        Jekyll.logger.debug "Rendering Layout:", relative_path
        place_in_layouts
      end
    end

    # Convert the document using the converters which match this renderer's document.
    #
    # Returns the converted content.
    private
    def convert
      Jekyll.logger.debug "Rendering Markup:", relative_path
      document.output = converters.reduce(document.output) do |output, converter|
        begin
          converter.convert output
        rescue => e
          Jekyll.logger.error(
            "Conversion error:",
            "#{converter.class} encountered an error "\
            "while converting '#{relative_path}':"
          )
          Jekyll.logger.error("", e.to_s)
          raise e
        end
      end
    end

    # Render layouts and place document content inside.
    #
    # Returns nothing
    private
    def place_in_layouts
      layout = site.layouts[document.data["layout"]]
      validate_layout(layout)

      used = Set.new([layout])

      # Reset the payload layout data to ensure it starts fresh for each page.
      payload["layout"] = nil
      while layout
        render_layout(layout)
        add_layout_to_dependency(layout)

        if (layout = site.layouts[layout.data["layout"]])
          break if used.include?(layout)
          used << layout
        end
      end
    end

    # Render layout content into document.output
    #
    # Returns nothing
    private
    def render_layout(layout)
      payload["content"] = document.output
      payload["layout"]  = Utils.deep_merge_hashes(layout.data, payload["layout"] || {})

      document.output = render_liquid(layout.content, layout.relative_path)
    end

    # Checks if the layout specified in the document actually exists
    #
    # layout - the layout to check
    # Returns nothing
    private
    def validate_layout(layout)
      if !document.data["layout"].nil? && layout.nil?
        Jekyll.logger.warn(
          "Build Warning:",
          "Layout '#{document.data["layout"]}' requested "\
          "in #{relative_path} does not exist."
        )
      end
    end

    private
    def add_layout_to_dependency(layout)
      site.regenerator.add_dependency(
        site.in_source_dir(path),
        site.in_source_dir(layout.path)
      ) if document.write?
    end

    # Render Liquid in the content
    #
    # content - the raw Liquid content to render
    # path    - the path of file to render
    #
    # Returns String the converted content
    private
    def render_liquid(content, path)
      site.liquid_renderer.file(path).parse(content).render!(payload, liquid_info)
    rescue Tags::IncludeTagError => e
      Jekyll.logger.error(
        "Liquid Exception:",
        "#{e.message} in #{e.path}, included in #{path || self.path}"
      )
      raise e
    # rubocop:disable RescueException
    rescue Exception => e
      Jekyll.logger.error "Liquid Exception:", "#{e.message} in #{path || self.path}"
      raise e
    end
    # rubocop:enable RescueException

    private
    def liquid_info
      @liquid_info ||= {
        :filters   => [Jekyll::Filters],
        :registers => { :site => site, :page => payload["page"] }
      }
    end

    private
    def permalink_ext
      if document.permalink && !document.permalink.end_with?("/")
        permalink_ext = File.extname(document.permalink)
        permalink_ext unless permalink_ext.empty?
      end
    end

    private
    def converter_output_ext
      if output_exts.size == 1
        output_exts.last
      else
        output_exts[-2]
      end
    end

    private
    def output_exts
      @output_exts ||= converters.map do |c|
        c.output_ext(document.extname)
      end.compact
    end

    private
    def path
      document.path
    end

    private
    def relative_path
      document.relative_path
    end
  end
end
