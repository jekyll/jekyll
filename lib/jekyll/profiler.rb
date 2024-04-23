# frozen_string_literal: true

module Jekyll
  class Profiler
    TERMINAL_TABLE_STYLES = {
      :alignment     => :right,
      :border_top    => false,
      :border_bottom => false,
    }.freeze
    private_constant :TERMINAL_TABLE_STYLES

    def self.tabulate(table_rows)
      require "terminal-table"

      rows   = table_rows.dup
      header = rows.shift
      output = +"\n"

      table = Terminal::Table.new do |t|
        t << header
        t << :separator
        rows.each { |row| t << row }
        t.style = TERMINAL_TABLE_STYLES
        t.align_column(0, :left)
      end

      output << table.to_s << "\n"
    end

    def initialize(site)
      @site = site
    end

    def profile_process
      profile_data = { "PHASE" => "TIME" }

      [:reset, :read, :generate, :render, :cleanup, :write].each do |method|
        start_time = Time.now
        @site.send(method)
        end_time = (Time.now - start_time).round(4)
        profile_data[method.to_s.upcase] = format("%.4f", end_time)
      end

      Jekyll.logger.info "\nBuild Process Summary:"
      Jekyll.logger.info Profiler.tabulate(Array(profile_data))

      Jekyll.logger.info "\nSite Render Stats:"
      @site.print_stats
    end
  end
end
