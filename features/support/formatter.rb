# frozen_string_literal: true

require "cucumber/formatter/io"

module Jekyll
  module Cucumber
    class Formatter
      include ::Cucumber::Formatter::Io

      def initialize(path_or_io, error_stream)
        @io = ensure_io(path_or_io, error_stream)
        @timings = {}
      end

      def before_test_case(test_case)
        @timings[timing_key(test_case)] = Time.now
      end

      def after_test_case(test_case)
        @timings[timing_key(test_case)] = Time.now - @timings[timing_key(test_case)]
      end

      def print_test_case_info(test_case)
        @io.print "\n#{test_case.location}  #{truncate(test_case.name).inspect}  "
        @io.flush
      end

      def print_test_case_duration(test_case)
        @io.print format("  (%.3fs)", @timings[timing_key(test_case)])
      end

      def print_worst_offenders
        @io.puts "\n\nWorst offenders:"

        rows = @timings.sort_by { |_f, t| -t }.take(10).map! { |r| r[0].split(" \t ", 2).push(r[1]) }
        padding = rows.max_by { |r| r[0].length }.first.length + 2
        rows.each { |row| @io.puts format_row_data(row, padding) }
      end

      private

      def format_row_data(row, padding)
        [
          row[0].ljust(padding).rjust(padding + 2),
          row[1].ljust(45),
          format("(%.3fs)", row[2]),
        ].join
      end

      def timing_key(test_case)
        "#{test_case.location} \t #{truncate(test_case.name).inspect}"
      end

      def truncate(input, max_len: 40)
        str = input.to_s
        str.length > max_len ? "#{str[0..(max_len - 2)]}..." : str
      end
    end
  end
end

InstallPlugin do |config|
  progress_fmt = config.to_hash[:formats][0][0] == "progress"
  f = Jekyll::Cucumber::Formatter.new($stdout, $stderr)

  config.on_event :test_case_started do |event|
    test_case = event.test_case

    f.print_test_case_info(test_case) if progress_fmt
    f.before_test_case(test_case)
  end

  config.on_event :test_case_finished do |event|
    test_case = event.test_case

    f.after_test_case(test_case)
    f.print_test_case_duration(test_case) if progress_fmt
  end

  config.on_event :test_run_finished do
    f.print_worst_offenders
  end
end
