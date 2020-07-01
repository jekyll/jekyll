# frozen_string_literal: true

module Jekyll
  class PageExcerpt < Excerpt
    attr_reader :doc
    alias_method :id, :relative_path

    EXCERPT_ATTRIBUTES = (Page::ATTRIBUTES_FOR_LIQUID - %w(excerpt)).freeze
    private_constant :EXCERPT_ATTRIBUTES

    def to_liquid
      @to_liquid ||= doc.to_liquid(EXCERPT_ATTRIBUTES)
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
