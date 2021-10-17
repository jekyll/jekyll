#!/usr/bin/env ruby
# frozen_string_literal: true

require "benchmark/ips"
require "colorator"
require "jekyll"
require "memory_profiler"
require "terminal-table"

CONTEXT = { "variable" => "The quick brown fox" }

MARKUP_1 = %Q(snippet.html alpha = "double \\"quoted\\"" betaa = 'single \\'quoted\\'' gamma = variable).freeze
MARKUP_2 = %Q(snippet.html alpha = "double 'quoted'" betaa = 'single "quoted"' gamma = variable).freeze
MARKUP_3 = %Q(snippet.html alpha = "double quoted" betaa = 'single quoted').freeze
MARKUP_4 = %Q({{ file }} alpha = "double quoted" betaa = 'single quoted').freeze
MARKUP_5 = %Q({{ file }} alpha = "double \\"quoted\\"" betaa = 'single \\'quoted\\'' gamma = variable).freeze
MARKUP_6 = %Q({{ file }} alpha = "double 'quoted'" betaa = 'single "quoted"' gamma = variable).freeze

class Base
  PARAMS_PATTERN = Jekyll::Tags::IncludeTag::VALID_SYNTAX
  VARIABLE_FILE  = Jekyll::Tags::IncludeTag::VARIABLE_SYNTAX

  def render(context)
    1000.times do
      parse_params(context)
    end
  end
end

class LegacyInclude < Base
  def initialize(markup)
    matched = markup.strip.match(VARIABLE_FILE)
    if matched
      @file = matched["variable"].strip
      @params = matched["params"].strip
    else
      @file, @params = markup.strip.split(%r!\s+!, 2)
    end
  end

  def parse_params(context)
    params = {}
    markup = @params

    while (match = PARAMS_PATTERN.match(markup))
      markup = markup[match.end(0)..-1]

      value = if match[2]
                match[2].gsub('\\"', '"')
              elsif match[3]
                match[3].gsub("\\'", "'")
              elsif match[4]
                context[match[4]]
              end

      params[match[1]] = value
    end
    params
  end
end

class OptimizedInclude < Base
  def initialize(markup)
    markup  = markup.strip
    matched = markup.match(VARIABLE_FILE)
    if matched
      @file = matched["variable"].strip
      @params = matched["params"].strip
    else
      @file, @params = markup.split(%r!\s+!, 2)
    end
  end

  def parse_params(context)
    params = {}
    @params.scan(PARAMS_PATTERN) do |key, d_quoted, s_quoted, variable|
      value = if d_quoted
                d_quoted.include?('\\"') ? d_quoted.gsub('\\"', '"') : d_quoted
              elsif s_quoted
                s_quoted.include?("\\'") ? s_quoted.gsub("\\'", "'") : s_quoted
              elsif variable
                context[variable]
              end

      params[key] = value
    end
    params
  end
end

class SuperOptimizedInclude < Base
  class ParameterTokenList
    def initialize(list)
      @list = list.map! do |key, d_quoted, s_quoted, variable|
        [
          key,
          d_quoted&.include?('\\"') ? d_quoted.gsub('\\"', '"') : d_quoted,
          s_quoted&.include?("\\'") ? s_quoted.gsub("\\'", "'") : s_quoted,
          variable,
        ]
      end
      @variable = @list.any? { |token| token[3] }
    end

    def render(context)
      @variable ? variable_hash(context) : static_hash
    end

    def static_hash
      @static_hash ||= @list.each_with_object({}) do |(key, d_quoted, s_quoted, _), params|
        params[key] = d_quoted || s_quoted
      end
    end

    def variable_hash(context)
      @list.each_with_object({}) do |(key, d_quoted, s_quoted, variable), params|
        params[key] = d_quoted || s_quoted || context[variable]
      end
    end
  end

  def initialize(markup)
    markup  = markup.strip
    matched = markup.match(VARIABLE_FILE)
    if matched
      @file = matched["variable"].tap(&:strip!)
      @params = matched["params"].tap(&:strip!)
    else
      @file, @params = markup.split(%r!\s+!, 2)
    end
    return unless @params

    @params = nil if @params == ""
    @param_tokens = ParameterTokenList.new(@params.scan(PARAMS_PATTERN)) if @params
  end

  def parse_params(context)
    @param_tokens.render(context)
  end
end

#

class Profiler
  KLASSES = {
    'legacy'          => LegacyInclude,
    'optimized'       => OptimizedInclude,
    'super-optimized' => SuperOptimizedInclude
  }

  def initialize(markup)
    @markup = markup
    @stack  = []
  end

  def test
    puts ""
    puts "MARKUP: #{@markup.cyan}"
    puts ""
    puts <<~TEXT
      Param Hash Results #{"-" * 30}
      #{debug}
    TEXT
    puts ""
  end

  def benchmark
    Benchmark.ips do |x|
      KLASSES.each do |label, klass|
        x.report(label) { klass.new(@markup).render(CONTEXT) }
      end
      x.compare!
    end
  end

  def profile_memory
    KLASSES.each_value do |klass|
      @stack << MemoryProfiler.report { klass.new(@markup).render(CONTEXT) }
    end

    puts Terminal::Table.new(
      :title    => "MEMORY PROFILE",
      :headings => [" "].concat(KLASSES.keys),
      :rows     => memprof_reports
    )
    puts ""
    puts "=" * 100
  end

  private

  def debug
    KLASSES.map do |label, klass|
      [label.rjust(20), ": ", klass.new(@markup).parse_params(CONTEXT)].join
    end.join("\n")
  end

  def memprof_reports
    @stack.map do |reporter|
      allocated_memory  = reporter.scale_bytes(reporter.total_allocated_memsize)
      allocated_objects = reporter.total_allocated
      retained_memory   = reporter.scale_bytes(reporter.total_retained_memsize)
      retained_objects  = reporter.total_retained

      [
        "#{allocated_memory} (#{allocated_objects} objects)",
        "#{retained_memory} (#{retained_objects} objects)",
      ]
    end.transpose.tap { |rows| rows[0].unshift("Total allocated"); rows[1].unshift("Total retained") }
  end
end

[MARKUP_1, MARKUP_2, MARKUP_3, MARKUP_4, MARKUP_5, MARKUP_6].each do |markup|
  profiler = Profiler.new(markup)

  profiler.test
  profiler.benchmark
  profiler.profile_memory
end
