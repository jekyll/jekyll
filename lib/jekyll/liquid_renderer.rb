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

    # rubocop:disable Metrics/AbcSize
    def print(data)
      cell_width  = data.keys.map(&:length).max
      cell_border = "-" * (cell_width + 2)
      total_time  = data.delete("TOTAL TIME")

      table = +"\nBuild Process Summary:\n"
      table << "-" * 22 << "\n\n"
      table << format_data_cell("METHOD", "TIME", cell_width)
      table << divider(cell_border)

      data.each do |key, value|
        table << format_data_cell(key, format("%.4f", value), cell_width)
      end

      table << divider(cell_border)
      table << format_data_cell("TOTAL TIME", format("%.4f", total_time), cell_width)
    end
    # rubocop:enable Metrics/AbcSize

    def self.format_error(error, path)
      "#{error.message} in #{path}"
    end

    private

    def filename_regex
      @filename_regex ||= %r!\A(#{source_dir}/|#{theme_dir}/|/*)(.*)!i
    end

    def new_profile_hash
      Hash.new { |hash, key| hash[key] = 0 }
    end

    def format_data_cell(key, val, width)
      row = +""
      row << key.to_s.ljust(width - 2).center(width + 2) << " | "
      row << val.to_s.rjust(width - 4).center(width + 2) << "\n"
    end

    def divider(cell_border)
      +"" << cell_border << "-+-" << cell_border << "\n"
    end
  end
end
