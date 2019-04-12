# frozen_string_literal: true

module Jekyll
  class LiquidRenderer
    class Table
      TYPES  = [:liquid, :markup].freeze
      GAUGES = [:count, :bytes, :time].freeze

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

        headers = data.shift(2)
        footer  = data.pop

        headers.each do |header|
          str << generate_row(header, widths)
        end

        str << generate_table_head_border(headers[0], widths)

        data.each do |row_data|
          str << generate_row(row_data, widths)
        end

        str << generate_table_head_border(headers[0], widths)
        str << generate_row(footer, widths).rstrip

        str << "\n"
        str
      end

      def generate_table_head_border(row_data, widths)
        str = +" "

        row_data.each_index do |index|
          str << "-" * widths[index]
          str << "-+-" unless index == row_data.length - 1
        end

        str << "\n"
        str
      end

      def generate_row(row_data, widths)
        str = +" "

        row_data.each_with_index do |cell, index|
          str << if index.zero?
                   cell.ljust(widths[index])
                 else
                   cell.rjust(widths[index])
                 end
          str << " | " unless index == row_data.length - 1
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
            row << format_bytes(file_stats[:"#{type}_bytes"])
            row << format("%.3fs", file_stats[:"#{type}_time"])
          end

          table << row
        end

        footer = []
        footer << "TOTAL (for #{sorted.size} files)"

        TYPES.each do |type|
          footer << totals[:"#{type}_count"].to_s
          footer << format_bytes(totals[:"#{type}_bytes"])
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

        # push each stringified type repeatedly into the first header row 3 times
        TYPES.each { |type| 3.times { header0 << type.to_s.capitalize } }

        # push each stringified gauge serially into the second header row twice
        2.times { GAUGES.each { |gauge| header1 << gauge.to_s } }

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
