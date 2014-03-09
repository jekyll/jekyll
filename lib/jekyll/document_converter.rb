module Jekyll
  class DocumentConverter
    attr_reader :document

    DONT_RENDER = %w[
      .sass
      .scss
    ]

    DONT_CONVERT = %w[]

    def initialize(document)
      @document = document
    end

    def site
      document.site
    end

    def base_payload
      Utils.deep_merge_hashes({
        "page"      => document.to_liquid,
        "paginator" => pager.to_liquid
      }, site.site_payload)
    end

    def info(payload)
      {
        :filters => [Jekyll::Filters],
        :registers => { :site => site, :page => payload["page"] }
      }
    end

    def layouts
      @layouts ||= site.layouts
    end

    # Public: Transform
    #
    #
    def transform
      convert if convert?
      render_liquid(document.content, base_payload, info(base_payload)) if render_liquid?
      place_in_layouts
    end

    # Determine which converters to use based on the document's extension.
    #
    # Returns an array the Converter instance.
    def converters
      @converters ||= site.converters.select { |c| c.matches(document.extname) }
    end

    # Determine if the document should be converted
    #
    # Returns true unless the document's extname is in a pre-defined blacklist
    def convert?
      !DONT_CONVERT.include?(document.extname)
    end

    # Convert the document.
    #
    # Returns nothing.
    def convert
      converters.each do |converter|
        document.content = converter.convert(document.content)
      end
    rescue => e
      Jekyll.logger.error "Conversion error:", "There was an error converting" +
        " '#{document.relative_path}'."
      raise e
    end

    # Determine whether this document should be rendered with Liquid
    #
    # Returns true if the document's extname isn't in a pre-defined blacklist
    def render_liquid?
      !DONT_RENDER.include?(document.extname)
    end

    # Render Liquid in the content
    #
    # content - the raw Liquid content to render
    # payload - the payload for Liquid
    # info    - the info for Liquid
    #
    # Returns the converted content
    def render_liquid(content, payload, info, path = nil)
      Liquid::Template.parse(content).render!(payload, info(payload))
    rescue Tags::IncludeTagError => e
      Jekyll.logger.error "Liquid Exception:", "#{e.message} in #{e.path}, included in #{path || document.relative_path}"
      raise e
    rescue Exception => e
      Jekyll.logger.error "Liquid Exception:", "#{e.message} in #{path || document.relative_path}"
      raise e
    end

    # Recursively render layouts
    #
    # Returns nothing
    def place_in_layouts
      # recursively render layouts
      layout = layouts[document.data["layout"]]
      used = Set.new([layout])

      while layout
        payload = Utils.deep_merge_hashes(
          base_payload,
          {
            "content" => document.output,
            "page"    => Utils.deep_merge_hashes(layout.data, document.data)
          }
        )

        document.output = render_liquid(layout.content, payload, info(payload), File.join(site.config['layouts'], layout.name))

        if layout = layouts[layout.data["layout"]]
          if used.include?(layout)
            layout = nil # avoid recursive chain
          else
            used << layout
          end
        end
      end
    end

    # Determine the extension depending on the extname of the document.
    #
    # Returns the String extension for the output file.
    #   e.g. ".html" for an HTML output file.
    def output_ext
      converters.last.output_ext(document.extname)
    end
  end
end
