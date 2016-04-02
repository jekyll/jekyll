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
      str = "\n"

      table_head = data.shift
      str << generate_row(table_head, widths)
      str << generate_table_head_border(table_head, widths)

      data.each do |row_data|
        str << generate_row(row_data, widths)
      end

      str << "\n"
      str
    end

    def generate_table_head_border(row_data, widths)
      str = ""

      row_data.each_index do |cell_index|
        str << '-' * widths[cell_index]
        str << '-+-' unless cell_index == row_data.length-1
      end

      str << "\n"
      str
    end

    def generate_row(row_data, widths)
      str = ''

      row_data.each_with_index do |cell_data, cell_index|
        if cell_index == 0
          str << cell_data.ljust(widths[cell_index], ' ')
        else
          str << cell_data.rjust(widths[cell_index], ' ')
        end

        str << ' | ' unless cell_index == row_data.length-1
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
      sorted = @stats.sort_by { |_, file_stats| -file_stats[:time] }
      sorted = sorted.slice(0, n)

      table = [%w(Filename Count Bytes Time)]

      sorted.each do |filename, file_stats|
        row = []
        row << filename
        row << file_stats[:count].to_s
        row << format_bytes(file_stats[:bytes])
        row << "%.3f" % file_stats[:time]
        table << row
      end

      table
    end

    def format_bytes(bytes)
      bytes /= 1024.0
      "%.2fK" % bytes
    end
  end
end
