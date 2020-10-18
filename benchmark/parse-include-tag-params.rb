#!/usr/bin/env ruby
# frozen_string_literal: true

# For pull request: https://github.com/jekyll/jekyll/pull/8192

require 'benchmark/ips'
require 'bundler/setup'
require 'memory_profiler'
require 'jekyll'

CONTEXT = {"bar"=>"The quick brown fox"}
MARKUP_1 = %Q(foo=bar lorem="ipsum \\"dolor\\"" alpha='beta \\'gamma\\'').freeze
MARKUP_2 = %Q(foo=bar lorem="ipsum 'dolor'" alpha='beta "gamma"').freeze

#

def old_parse_params(markup)
  params = {}

  while (match = Jekyll::Tags::IncludeTag::VALID_SYNTAX.match(markup))
    markup = markup[match.end(0)..-1]

    value = if match[2]
              match[2].gsub('\\"', '"')
            elsif match[3]
              match[3].gsub("\\'", "'")
            elsif match[4]
              CONTEXT[match[4]]
            end

    params[match[1]] = value
  end
  params
end

def new_parse_params(markup)
  params = {}
  markup.scan(Jekyll::Tags::IncludeTag::VALID_SYNTAX) do |key, d_quoted, s_quoted, variable|
    value = if d_quoted
              d_quoted.include?('\\"') ? d_quoted.gsub('\\"', '"') : d_quoted
            elsif s_quoted
              s_quoted.include?("\\'") ? s_quoted.gsub("\\'", "'") : s_quoted
            elsif variable
              CONTEXT[variable]
            end

    params[key] = value
  end
  params
end

#

def report(label, markup, color)
  prof_report = MemoryProfiler.report { yield }

  allocated_memory  = prof_report.scale_bytes(prof_report.total_allocated_memsize)
  allocated_objects = prof_report.total_allocated
  retained_memory   = prof_report.scale_bytes(prof_report.total_retained_memsize)
  retained_objects  = prof_report.total_retained

  puts <<~MSG.send(color)
    #{(label + " ").ljust(49, "-")}

    MARKUP: #{markup}
    RESULT: #{yield}

    Total allocated: #{allocated_memory} (#{allocated_objects} objects)
    Total retained:  #{retained_memory} (#{retained_objects} objects)
  MSG
end

report('old w/ escaping', MARKUP_1, :magenta) { old_parse_params(MARKUP_1) }
report('new w/ escaping', MARKUP_1, :cyan)    { new_parse_params(MARKUP_1) }

report('old no escaping', MARKUP_2, :green)  { old_parse_params(MARKUP_2) }
report('new no escaping', MARKUP_2, :yellow) { new_parse_params(MARKUP_2) }

#

Benchmark.ips do |x|
  x.report("old + esc".magenta) { old_parse_params(MARKUP_1) }
  x.report("new + esc".cyan)    { new_parse_params(MARKUP_1) }
  x.compare!
end

Benchmark.ips do |x|
  x.report("old - esc".green)  { old_parse_params(MARKUP_2) }
  x.report("new - esc".yellow) { new_parse_params(MARKUP_2) }
  x.compare!
end
