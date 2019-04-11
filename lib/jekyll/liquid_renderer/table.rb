# frozen_string_literal: true

module Jekyll
  class LiquidRenderer
    class Table
      def initialize(stats)
        @stats = stats
      end

      def to_s(num_of_rows = 50)
        data = data_for_table(num_of_rows)
        widths = table_widths(data)
        generate_table(data, widths)
      end

      private

      def inject_data(initial = " ")
        str = +initial

        yield str

        str << "\n"
        str
      end

      def generate_table(data, widths)
        inject_data("\n") do |str|
          headers = data.shift(2)
          footer  = data.pop

          headers.each { |header| str << generate_row(header, widths) }
          str << generate_table_head_border(headers[0], widths)

          data.each { |row_data| str << generate_row(row_data, widths) }

          str << generate_table_head_border(headers[0], widths)
          str << generate_row(footer, widths)
        end
      end

      def generate_table_head_border(row_data, widths)
        inject_data do |str|
          row_data.each_index do |index|
            str << "-" * widths[index]
            str << "-+-" unless index == row_data.length - 1
          end
        end
      end

      def generate_row(row_data, widths)
        inject_data do |str|
          row_data.each_with_index do |cell, index|
            str << if index.zero?
                     cell.ljust(widths[index])
                   else
                     cell.rjust(widths[index])
                   end
            str << " | " unless index == row_data.length - 1
          end
        end
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

      def data_for_table(num_of_rows)
        sorted = @stats.sort_by { |_, file_stats| -file_stats[:liquid_time] }
        sorted = sorted.slice(0, num_of_rows)

        types  = %w(liquid markup)
        gauges = %w(count bytes time)
        total  = Hash.new { |hash, key| hash[key] = 0 }

        tabulate(sorted, types, gauges, total)
      end

      def tabulate(sorted, types, gauges, total)
        [].tap do |table|
          add_header(table, types, gauges.map(&:capitalize))

          sorted.each do |filename, file_stats|
            table << [truncate(filename)].tap do |row|
              types.each do |type|
                gauges.each do |metric|
                  key = "#{type}_#{metric}".to_sym
                  total[key] += file_stats[key]
                end
                data_for_row(file_stats, type, row)
              end
            end
          end

          table << ["TOTAL (for #{sorted.size} files)"].tap do |row|
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

      def truncate(input, max_size = 36)
        return input unless input.length > max_size

        "#{input[0...max_size]}..."
      end
    end
  end
end
