# frozen_string_literal: true

module Jekyll
  class LiquidRenderer
    class Table
      TYPES  = [:liquid, :markup].freeze
      GAUGES = [:count, :time].freeze

      def initialize(stats)
        @stats = stats
      end

      def to_s(num_of_rows = 50)
        data = data_for_table(num_of_rows)
        widths = table_widths(data)
        generate_table(data, widths)
      end

      private

      def generate_table(data, widths)
        str = +"\n"

        table_heads = data.shift(2)
        table_foot  = data.pop

        table_heads.each do |table_head|
          str << generate_row(table_head, widths)
        end
        str << generate_table_head_border(table_heads[0], widths)

        data.each do |row_data|
          str << generate_row(row_data, widths)
        end

        str << generate_table_head_border(table_foot, widths)
        str << generate_row(table_foot, widths).rstrip

        str << "\n"
        str
      end

      def generate_table_head_border(row_data, widths)
        str = +" "

        row_data.each_index do |cell_index|
          str << "-" * widths[cell_index]
          str << "-+-" unless cell_index == row_data.length - 1
        end

        str << "\n"
        str
      end

      def generate_row(row_data, widths)
        str = +" "

        row_data.each_with_index do |cell_data, cell_index|
          str << if cell_index.zero?
                   cell_data.ljust(widths[cell_index])
                 else
                   cell_data.rjust(widths[cell_index])
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
            widths[index] = [cell.length, widths[index]].compact.max
          end
        end

        widths
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def data_for_table(num_of_rows)
        sorted = @stats.sort_by { |_, file_stats| -file_stats[:liquid_time] }
        sorted = sorted.slice(0, num_of_rows)

        table  = initialize_table
        totals = Hash.new { |hash, key| hash[key] = 0 }

        sorted.each do |filename, file_stats|
          row = []
          row << truncate(filename)

          TYPES.each do |type|
            GAUGES.each do |gauge|
              key = "#{type}_#{gauge}".to_sym
              totals[key] += file_stats[key]
            end

            row << file_stats[:"#{type}_count"].to_s
            row << format("%.3fs", file_stats[:"#{type}_time"])
          end

          table << row
        end

        footer = []
        footer << "TOTAL (for #{sorted.size} files)"

        TYPES.each do |type|
          footer << totals[:"#{type}_count"].to_s
          footer << format("%.3fs", totals[:"#{type}_time"])
        end

        table << footer
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def initialize_table
        # simulate rowspan with two header rows
        header0 = ["        "]
        header1 = ["Filename"]

        # push each stringified type repeatedly into the first header row for each gauge
        gauge_count = GAUGES.count
        TYPES.each { |type| gauge_count.times { header0 << type.to_s.capitalize } }

        # push each stringified gauge serially into the second header row for each type
        TYPES.count.times { GAUGES.each { |gauge| header1 << gauge.to_s } }

        # finally return the table skeleton
        [].tap do |table|
          table << header0
          table << header1
        end
      end

      def format_bytes(bytes)
        bytes /= 1024.0
        format("%.2fK", bytes)
      end

      def truncate(input, max_size = 36)
        return input unless input.length > max_size

        "#{input[0...max_size]}..."
      end
    end
  end
end
