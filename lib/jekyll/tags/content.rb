module Jekyll
  module Tags
    class Content < Liquid::Tag
      def initialize(tag_name, name, tokens)
        @name = name
      end

      def render(context)
        site = context.registers[:site]

        # Chunk of logic to get the Document/Page object from the context object
        # by comparing paths
        @document = context[@name]
        if @document["type"] == "document"
          collection = site.collections[@document["collection"]]
          @document = collection.docs.find { |doc| doc.relative_path == @document["path"] }
        elsif @document["type"] == "page"
          @document = site.pages.find { |page| page.path == @document["path"] }
        else
          raise Exception.new("Could not match document or page in content tag")
        end

        # Store dependency in metadata
        if context.registers[:page] and context.registers[:page].has_key? "path"
          Jekyll.logger.debug "Content Tag:", "Adding dependency to regenerator metadata"
          site.regenerator.add_dependency(
            site.in_source_dir(context.registers[:page]["path"]),
            @document.path
          )
        end

        # Return content if already rendered
        return @document.content unless @document.output.nil?

        # Otherwise, render
        Jekyll.logger.debug "Content Tag:", "Rendering included document"
        if @document.is_a? Jekyll::Document
          Jekyll::Renderer.new(site, @document, site.site_payload).run
        else
          @document.render(site.layouts, site.site_payload)
        end

        # Return rendered content
        return @document.content
      end
    end
  end
end

Liquid::Template.register_tag('content', Jekyll::Tags::Content)
