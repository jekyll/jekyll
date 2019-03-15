# frozen_string_literal: true

require_relative "liquid_renderer/file"
require_relative "liquid_renderer/table"

module Jekyll
  class LiquidRenderer
    extend Forwardable

    private def_delegator :@site, :in_source_dir, :source_dir
    private def_delegator :@site, :in_theme_dir, :theme_dir

    def initialize(site)
      @site = site
      Liquid::Template.error_mode = @site.config["liquid"]["error_mode"].to_sym
      reset
    end

    def reset
      @stats = {}
    end

    def file(filename)
      filename.match(filename_regex)
      filename =
        if Regexp.last_match(1) == theme_dir("")
          ::File.join(::File.basename(Regexp.last_match(1)), Regexp.last_match(2))
        else
          Regexp.last_match(2)
        end
      LiquidRenderer::File.new(self, filename).tap do
        @stats[filename] ||= new_profile_hash
        @stats[filename][:count] += 1
      end
    end

    def increment_bytes(filename, bytes)
      @stats[filename][:bytes] += bytes
    end

    def increment_time(filename, time)
      @stats[filename][:time] += time
    end

    def stats_table(num_of_rows = 50)
      LiquidRenderer::Table.new(@stats).to_s(num_of_rows)
    end

    def self.format_error(error, path)
      "#{error.message} in #{path}"
    end

    private

    def filename_regex
      @filename_regex ||= begin
        %r!\A(#{Regexp.escape(source_dir)}/|#{Regexp.escape(theme_dir.to_s)}/|/*)(.*)!i
      end
    end

    def new_profile_hash
      Hash.new { |hash, key| hash[key] = 0 }
    end
  end
end
