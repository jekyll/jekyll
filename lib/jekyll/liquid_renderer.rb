# frozen_string_literal: true

require "jekyll/liquid_renderer/file"

module Jekyll
  class LiquidRenderer
    attr_reader :site

    def initialize(site)
      @site = site
      Liquid::Template.error_mode = site.config["liquid"]["error_mode"].to_sym
    end

    def file(filename)
      filename = @site.in_source_dir(filename).sub(
        %r!\A#{Regexp.escape(site.source)}/!,
        ""
      )

      LiquidRenderer::File.new(self, filename).tap do
        site.profiler.increment_count(filename, :liquid)
      end
    end

    def self.format_error(e, path)
      "#{e.message} in #{path}"
    end
  end
end
