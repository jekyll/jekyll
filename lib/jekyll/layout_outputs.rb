# frozen_string_literal: true

module Jekyll
  # Additional layout outputs share the document's converted content, while the
  # document's public URL and output continue to represent its primary format.
  module LayoutOutputs
    attr_accessor :layout_outputs

    def alternate_layouts
      return [] unless place_in_layout?

      variants = renderer.layout_variants
      return [] if variants.size < 2

      primary = renderer.primary_layout
      variants.values.reject { |layout| layout.equal?(primary) }
    end

    def output_destinations(dest)
      [destination(dest)] + alternate_layouts.map { |layout| layout_destination(dest, layout.ext) }
    end

    def layout_destination(dest, extension)
      primary = destination(dest)
      primary.delete_suffix(File.extname(primary)) + extension
    end

    def write_layout_outputs(dest)
      (layout_outputs || {}).each do |extension, rendered|
        path = layout_destination(dest, extension)
        FileUtils.mkdir_p(File.dirname(path))
        Jekyll.logger.debug "Writing:", path
        File.write(path, rendered, :mode => "wb")
      end
    end
  end
end
