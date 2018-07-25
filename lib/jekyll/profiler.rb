# frozen_string_literal: true

module Jekyll
  class Profiler
    def initialize(site)
      @site = site
    end

    def profile_process
      profile_data = {}
      total_time = 0

      [:reset, :read, :generate, :render, :cleanup, :write].each do |method|
        start_time = Time.now
        @site.send(method)
        end_time = (Time.now - start_time).round(4)
        profile_data[method.to_s.upcase] = end_time
        total_time += end_time
      end

      profile_data["TOTAL TIME"] = total_time
      Jekyll.logger.info print_phase_stats(profile_data)

      Jekyll.logger.info "\nSite Render Stats:\n------------------"
      @site.print_stats
    end

    private

    # rubocop:disable Metrics/AbcSize
    def print_phase_stats(data)
      cell_width  = data.keys.map(&:length).max
      cell_border = "-" * (cell_width + 2)
      total_time  = data.delete("TOTAL TIME")

      table = +"\nBuild Process Summary:\n"
      table << "-" * 22 << "\n\n"
      table << format_data_cell("PHASE", "TIME", cell_width)
      table << divider(cell_border)

      data.each do |key, value|
        table << format_data_cell(key, format("%.4f", value), cell_width)
      end

      table << divider(cell_border)
      table << format_data_cell("TOTAL TIME", format("%.4f", total_time), cell_width)
    end
    # rubocop:enable Metrics/AbcSize

    def format_data_cell(key, val, width)
      row = +""
      row << key.to_s.ljust(width - 2).center(width + 2) << " | "
      row << val.to_s.rjust(width) << "\n"
    end

    def divider(cell_border)
      +"" << cell_border << "-+-" << cell_border << "\n"
    end
  end
end
