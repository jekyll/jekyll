# frozen_string_literal: true

require_relative "liquid_renderer/file"
require_relative "liquid_renderer/table"

module Jekyll
  class LiquidRenderer
    def initialize(site)
      @site = site
      Liquid::Template.error_mode = @site.config["liquid"]["error_mode"].to_sym
      reset
    end

    def reset
      @stats = {}
      @cache = {}
    end

    def file(filename)
      filename = normalize_path(filename)
      LiquidRenderer::File.new(self, filename).tap do
        @stats[filename] ||= new_profile_hash
      end
    end

    def increment_bytes(filename, bytes)
      @stats[filename][:bytes] += bytes
    end

    def increment_time(filename, time)
      @stats[filename][:time] += time
    end

    def increment_count(filename)
      @stats[filename][:count] += 1
    end

    def stats_table(num_of_rows = 50)
      LiquidRenderer::Table.new(@stats).to_s(num_of_rows)
    end

    def self.format_error(error, path)
      "#{error.message} in #{path}"
    end

    # A persistent cache to store and retrieve parsed templates based on the filename
    # via `LiquidRenderer::File#parse`
    #
    # It is emptied when `self.reset` is called.
    def cache
      @cache ||= {}
    end

    private

    def normalize_path(filename)
      @normalize_path ||= {}
      @normalize_path[filename] ||= begin
        theme_dir = @site.theme&.root
        case filename
        when %r!\A(#{Regexp.escape(@site.source)}/)(?<rest>.*)!io
          Regexp.last_match(:rest)
        when %r!(/gems/.*)*/gems/(?<dirname>[^/]+)(?<rest>.*)!,
             %r!(?<dirname>[^/]+/lib)(?<rest>.*)!
          "#{Regexp.last_match(:dirname)}#{Regexp.last_match(:rest)}"
        when theme_dir && %r!\A#{Regexp.escape(theme_dir)}/(?<rest>.*)!io
          PathManager.join(@site.theme.basename, Regexp.last_match(:rest))
        when %r!\A/(.*)!
          Regexp.last_match(1)
        else
          filename
        end
      end
    end

    def new_profile_hash
      Hash.new { |hash, key| hash[key] = 0 }
    end
  end
end
