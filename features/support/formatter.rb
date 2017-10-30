# frozen_string_literal: true

require "fileutils"
require "colorator"
require "cucumber/formatter/console"
require "cucumber/formatter/io"

module Jekyll
  module Cucumber
    class Formatter
      attr_accessor :indent, :runtime
      include ::Cucumber::Formatter::Console
      include ::Cucumber::Formatter::Io
      include FileUtils

      CHARS = {
        :failed    => "\u2718".red,
        :pending   => "\u203D".yellow,
        :undefined => "\u2718".red,
        :passed    => "\u2714".green,
        :skipped   => "\u203D".blue,
      }.freeze

      #

      def initialize(runtime, path_or_io, options)
        @runtime = runtime
        @snippets_input = []
        @io = ensure_io(path_or_io)
        @prefixes = options[:prefixes] || {}
        @delayed_messages = []
        @options = options
        @exceptions = []
        @indent = 0
        @timings = {}
      end

      #

      def before_features(_features)
        print_profile_information
      end

      #

      def after_features(features)
        @io.puts
        print_worst_offenders
        print_summary(features)
      end

      #

      def before_feature(_feature)
        @exceptions = []
        @indent = 0
      end

      #

      def feature_element_timing_key(feature_element)
        "\"#{feature_element.name}\" (#{feature_element.location})"
      end

      #

      def before_feature_element(feature_element)
        @indent = 2
        @scenario_indent = 2
        @timings[feature_element_timing_key(feature_element)] = Time.now
      end

      #

      def after_feature_element(feature_element)
        @timings[feature_element_timing_key(feature_element)] = Time.now - @timings[feature_element_timing_key(feature_element)]
        @io.print " (#{@timings[feature_element_timing_key(feature_element)]}s)"
      end

      #

      def tag_name(tag_name); end

      def comment_line(comment_line); end

      def after_tags(tags); end

      #

      def before_background(_background)
        @scenario_indent = 2
        @in_background = true
        @indent = 2
      end

      #

      def after_background(_background)
        @in_background = nil
      end

      #

      def background_name(keyword, name, source_line, indent)
        print_feature_element_name(
          keyword, name, source_line, indent
        )
      end

      #

      def scenario_name(keyword, name, source_line, indent)
        print_feature_element_name(
          keyword, name, source_line, indent
        )
      end

      #

      def before_step(step)
        @current_step = step
      end

      #

      # rubocop:disable Metrics/ParameterLists
      def before_step_result(_keyword, _step_match, _multiline_arg, status, exception, \
              _source_indent, background, _file_colon_line)

        @hide_this_step = false
        if exception
          if @exceptions.include?(exception)
            @hide_this_step = true
            return
          end

          @exceptions << exception
        end

        if status != :failed && @in_background ^ background
          @hide_this_step = true
          return
        end

        @status = status
      end

      #

      def step_name(_keyword, _step_match, status, _source_indent, _background, _file_colon_line)
        @io.print CHARS[status]
        @io.print " "
      end
      # rubocop:enable Metrics/ParameterLists

      #

      def exception(exception, status)
        return if @hide_this_step

        @io.puts
        print_exception(exception, status, @indent)
        @io.flush
      end

      #

      def after_test_step(test_step, result)
        collect_snippet_data(
          test_step, result
        )
      end

      #

      def print_feature_element_name(feature_element)
        @io.print "\n#{feature_element.location}  Scenario: #{feature_element.name} "
        @io.flush
      end

      #

      def cell_prefix(status)
        @prefixes[status]
      end

      #

      def print_worst_offenders
        @io.puts
        @io.puts "Worst offenders:"
        @timings.sort_by { |_f, t| -t }.take(10).each do |(f, t)|
          @io.puts "  #{t}s for #{f}"
        end
        @io.puts
      end

      #

      def print_summary(features)
        @io.puts
        print_stats(features, @options)
        print_snippets(@options)
        print_passing_wip(@options)
      end
    end
  end
end

AfterConfiguration do |config|
  f = Jekyll::Cucumber::Formatter.new(nil, $stdout, {})

  config.on_event :test_case_started do |event|
    f.print_feature_element_name(event.test_case)
    f.before_feature_element(event.test_case)
  end

  config.on_event :test_case_finished do |event|
    f.after_feature_element(event.test_case)
  end

  config.on_event :test_run_finished do
    f.print_worst_offenders
  end
end
