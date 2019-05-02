# frozen_string_literal: true

module Jekyll
  class PageExcerpt < Excerpt
    attr_reader :output, :doc
    alias_method :id, :relative_path

    # The Liquid representation of this instance is simply the rendered output string.
    alias_method :to_liquid, :output

    def initialize(doc)
      super
      self.output = Renderer.new(site, self, site.site_payload).run
    end

    def render_with_liquid?
      return false if data["render_with_liquid"] == false

      Jekyll::Utils.has_liquid_construct?(content)
    end

    def inspect
      "#<#{self.class} id=#{id.inspect}>"
    end
  end
end
