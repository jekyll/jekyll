# frozen_string_literal: true

module Jekyll
  class Snippet
    FROZEN_READONLY_HASH = {}.freeze
    private_constant :FROZEN_READONLY_HASH

    attr_reader :site, :relative_path, :path
    attr_accessor :content

    def initialize(site, relative_path, theme = nil)
      @site = site
      @relative_path = relative_path
      @path = if theme
                site.in_theme_dir("_snippets", relative_path)
              else
                site.in_source_dir(site.config["snippets_dir"], relative_path)
              end
      @content = File.read(path)
    end

    def basename
      @basename ||= File.basename(@path)
    end

    def extname
      @extname ||= File.extname(@path)
    end

    # Redundant. Only for compatibility with rendering process.
    # `content` is not sliced to remove any front matter either.
    def data
      @data ||= FROZEN_READONLY_HASH
    end

    def output
      @output ||= Renderer.new(site, self, site.site_payload).run
    end

    def render_with_liquid?
      !!Utils.has_liquid_construct?(content)
    end

    def place_in_layout?
      false
    end

    def to_liquid
      @to_liquid ||= FROZEN_READONLY_HASH
    end

    def rendered?
      !!@output
    end

    # Redundant. Only for compatibility with the rendering process.
    def trigger_hooks(*args); end

    def inspect
      "#<#{self.class} #{@relative_path}>"
    end
    alias_method :to_s, :inspect
  end
end
