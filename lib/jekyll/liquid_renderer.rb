# frozen_string_literal: true

require "jekyll/liquid_renderer/file"
require "jekyll/liquid_renderer/table"

module Jekyll
  class LiquidRenderer
    def initialize(site)
      @site = site
      @type = ""
      Liquid::Template.error_mode = @site.config["liquid"]["error_mode"].to_sym
      reset
    end

    def reset
      @stats = {}
    end

    def file(filename, type = "liquid")
      filename = @site.in_source_dir(filename).sub(
        %r!\A#{Regexp.escape(@site.source)}/!,
        ""
      )
      @type = type

      LiquidRenderer::File.new(self, filename).tap do
        stats[filename] ||= new_profile_hash
        stats[filename][stat_label("count")] += 1
      end
    end

    def increment_bytes(filename, bytes)
      stats[filename][stat_label("bytes")] += bytes
    end

    def increment_time(filename, time)
      stats[filename][stat_label("time")] += time
    end

    def stats_table(n = 50)
      LiquidRenderer::Table.new(stats).to_s(n)
    end

    def self.format_error(e, path)
      "#{e.message} in #{path}"
    end

    private
    attr_accessor :stats, :type

    def new_profile_hash
      Hash.new { |hash, key| hash[key] = 0 }
    end

    def stat_label(key)
      "#{type}_#{key}".to_sym
    end
  end
end
