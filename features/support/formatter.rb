require 'fileutils'
require 'colorator'
require 'cucumber/formatter/console'
require 'cucumber/formatter/io'

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
        :skipped   => "\u203D".blue
      }

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
      end

      #

      def before_features(features)
        print_profile_information
      end

      #

      def after_features(features)
        @io.puts
        print_summary(features)
      end

      #

      def before_feature(feature)
        @exceptions = []
        @indent = 0
      end

      #

      def tag_name(tag_name); end
      def comment_line(comment_line); end
      def after_feature_element(feature_element); end
      def after_tags(tags); end

      #

      def before_feature_element(feature_element)
        @indent = 2
        @scenario_indent = 2
      end

      #

      def before_background(background)
        @scenario_indent = 2
        @in_background = true
        @indent = 2
      end

      #

      def after_background(background)
        @in_background = nil
      end

      #

      def background_name(keyword, name, source_line, indend)
        print_feature_element_name(
          keyword, name, source_line, indend
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

      def before_step_result(keyword, step_match, multiline_arg, status, exception, \
          source_indent, background, file_colon_line)

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

      def step_name(keyword, step_match, status, source_indent, background, file_colon_line)
        @io.print CHARS[status]
        @io.print " "
      end

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

      private
      def print_feature_element_name(keyword, name, source_line, indent)
        @io.puts

        names = name.empty? ? [name] : name.each_line.to_a
        line  = "  #{keyword}: #{names[0]}"

        @io.print(source_line) if @options[:source]
        @io.print(line)
        @io.print " "
        @io.flush
      end

      #

      def cell_prefix(status)
        @prefixes[status]
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
