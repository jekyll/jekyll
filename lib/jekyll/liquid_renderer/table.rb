# frozen_string_literal: true

module Jekyll
  class LiquidRenderer::Table
    def initialize(stats)
      @stats = stats
    end

    def to_s(n = 50)
      data = data_for_table(n)
      widths = table_widths(data)
      generate_table(data, widths)
    end

    private

    def generate_table(data, widths)
      str = String.new("\n")

      header0 = data.shift
      header1 = data.shift
      footer  = data.pop
      str << generate_row(header0, widths)
      str << generate_row(header1, widths)
      str << generate_table_head_border(header0, widths)

      data.each do |row_data|
        str << generate_row(row_data, widths)
      end

      str << generate_table_head_border(header0, widths)
      str << generate_row(footer, widths)

      str << "\n"
      str
    end

    def generate_table_head_border(row_data, widths)
      str = String.new("")

      row_data.each_index do |cell_index|
        str << "-" * widths[cell_index]
        str << "-+-" unless cell_index == row_data.length - 1
      end

      str << "\n"
      str
    end

    def generate_row(row_data, widths)
      str = String.new("")

      row_data.each_with_index do |cell_data, cell_index|
        str << if cell_index.zero?
                 cell_data.ljust(widths[cell_index], " ")
               else
                 cell_data.rjust(widths[cell_index], " ")
               end

        str << " | " unless cell_index == row_data.length - 1
      end

      str << "\n"
      str
    end

    def table_widths(data)
      widths = []

      data.each do |row|
        row.each_with_index do |cell, index|
          widths[index] = [ cell.length, widths[index] ].compact.max
        end
      end

      widths
    end

    def data_for_table(n)
      sorted = @stats.sort_by { |_, file_stats| -file_stats[:liquid_time] }.slice(0, n)
      types  = %w(liquid markup)
      gauges = %w(count bytes time)
      total  = Hash.new { |hash, key| hash[key] = 0 }

      tabulate(sorted, types, gauges, total)
    end

    def tabulate(sorted, types, gauges, total)
      [].tap do |table|
        add_header(table, types, gauges.map(&:capitalize))

        sorted.each do |filename, file_stats|
          table << [filename].tap do |row|
            types.each do |type|
              gauges.each do |metric|
                key = "#{type}_#{metric}".to_sym
                total[key] += file_stats[key]
              end
              data_for_row(file_stats, type, row)
            end
          end
        end

        table << ["TOTAL"].tap do |row|
          types.each do |type|
            data_for_row(total, type, row)
          end
        end
      end
    end

    def data_for_row(hash, type, row)
      row << hash[:"#{type}_count"].to_s
      row << format_bytes(hash[:"#{type}_bytes"])
      row << format("%.3fs", hash[:"#{type}_time"])
    end

    def add_header(table, types, gauges)
      header0 = [""]
      types.each do |type|
        3.times { header0 << type.capitalize }
      end

      header1 = ["Filename"]
      2.times { header1 += gauges }

      table << header0
      table << header1
      table
    end

    def format_bytes(bytes)
      bytes /= 1024.0
      format("%.2fK", bytes)
    end
  end
end
