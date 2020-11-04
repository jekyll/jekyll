# frozen_string_literal: true

require_relative "liquid_renderer/template"

module Jekyll
  class LiquidRenderer
    def self.format_error(error, path)
      "#{error.message} in #{path}"
    end

    def initialize(site)
      @site = site
      Liquid::Template.error_mode = @site.config["liquid"]["error_mode"].to_sym
      reset
    end

    def reset
      @cache = {}
    end

    def file(filename)
      LiquidRenderer::Template.new(self, filename)
    end

    def increment_bytes(filename, bytes)
      raise NotImplementedError
    end

    def increment_time(filename, time)
      raise NotImplementedError
    end

    def increment_count(filename)
      raise NotImplementedError
    end

    def stats_table(num_of_rows = 50)
      Jekyll.logger.warn "Build site with --profile enabled to display stats"
    end

    # A persistent cache to store and retrieve parsed templates based on the filename
    # via `LiquidRenderer::File#parse`
    #
    # It is emptied when `self.reset` is called.
    def cache
      @cache ||= {}
    end
  end
end
