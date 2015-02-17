require 'fileutils'
require 'colorator'
require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'gherkin/formatter/escaping'

module Features
  module Support
    # The formatter used for <tt>--format pretty</tt> (the default formatter).
    #
    # This formatter prints features to plain text - exactly how they were parsed,
    # just prettier. That means with proper indentation and alignment of table columns.
    #
    # If the output is STDOUT (and not a file), there are bright colours to watch too.
    #
    class Overview
      include FileUtils
      include Cucumber::Formatter::Console
      include Cucumber::Formatter::Io
      include Gherkin::Formatter::Escaping
      attr_writer :indent
      attr_reader :runtime

      def initialize(runtime, path_or_io, options)
        @runtime, @io, @options = runtime, ensure_io(path_or_io, "pretty"), options
        @exceptions = []
        @indent = 0
        @prefixes = options[:prefixes] || {}
        @delayed_messages = []
      end

      def before_features(features)
        print_profile_information
      end

      def after_features(features)
        @io.puts
        print_summary(features)
      end

      def before_feature(feature)
        @exceptions = []
        @indent = 0
      end

      def comment_line(comment_line)
      end

      def after_tags(tags)
      end

      def tag_name(tag_name)
      end

      def before_feature_element(feature_element)
        @indent = 2
        @scenario_indent = 2
      end

      def after_feature_element(feature_element)
      end

      def before_background(background)
        @indent = 2
        @scenario_indent = 2
        @in_background = true
      end

      def after_background(background)
        @in_background = nil
      end

      def background_name(keyword, name, file_colon_line, source_indent)
        print_feature_element_name(keyword, name, file_colon_line, source_indent)
      end

      def scenario_name(keyword, name, file_colon_line, source_indent)
        print_feature_element_name(keyword, name, file_colon_line, source_indent)
      end

      def before_step(step)
        @current_step = step
      end

      def before_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line)
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

      CHARS = {
        :failed    => "x".red,
        :pending   => "?".yellow,
        :undefined => "x".red,
        :passed    => ".".green,
        :skipped   => "-".blue
      }

      def step_name(keyword, step_match, status, source_indent, background, file_colon_line)
        @io.print CHARS[status]
      end

      def exception(exception, status)
        return if @hide_this_step
        @io.puts
        print_exception(exception, status, @indent)
        @io.flush
      end

      private

      def print_feature_element_name(keyword, name, file_colon_line, source_indent)
        @io.puts
        names = name.empty? ? [name] : name.split("\n")
        line = "  #{keyword}: #{names[0]}"
        if @options[:source]
          line_comment = "#{file_colon_line}"
          @io.print(line_comment)
        end
        @io.print(line)
        @io.print " "
        @io.flush
      end

      def cell_prefix(status)
        @prefixes[status]
      end

      def print_summary(features)
        @io.puts
        print_stats(features, @options)
        print_snippets(@options)
        print_passing_wip(@options)
      end
    end
  end
end
