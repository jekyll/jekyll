#!/usr/bin/env ruby
# frozen_string_literal: true

require "benchmark/ips"
require_relative "../lib/jekyll"
require "memory_profiler"

class FakeFile
  attr_reader :relative_path
  def initialize(path)
    @relative_path = path
  end
end

class FakeParseContext
  def line_number
    1
  end
end

class LinkBenchmark
  def initialize()
    @site = Jekyll::Site.new(Jekyll.configuration({"quiet" => true}))
    @site.instance_variable_set(:@pages, [])
    site_files = ["index.md"] + (0..999).map { |i| "page#{i}.md" }
    site_files.each { |f| @site.pages << FakeFile.new(f) }
  end

  def build_memoized_tag()
    fake_context = FakeParseContext.new
    tag = Jekyll::Tags::Link.allocate
    tag.send(:initialize, "link", "{{ file_path }}", fake_context)
    tag
  end

  def build_no_cache_tag()
    fake_context = FakeParseContext.new
    tag = Class.new(Jekyll::Tags::Link) do
      def render(context)
        @context = context
        site = context.registers[:site]
        relative_path = Liquid::Template.parse(@relative_path).render(context)
        relative_path_with_leading_slash = Jekyll::PathManager.join("", relative_path)

        site.each_site_file do |item|
          return relative_url(item) if item.relative_path == relative_path
          return relative_url(item) if item.relative_path == relative_path_with_leading_slash
        end

        raise ArgumentError, "Could not find document '#{relative_path}'"
      end
    end.allocate
    tag.send(:initialize, "link", "{{ file_path }}", fake_context)
    tag
  end

  def worst_case_contexts
    @site.pages.map { |p| { "file_path" => p.relative_path } }
  end

  def average_case_contexts
    Array.new(1000) do
      { "file_path" => @site.pages.sample.relative_path }
    end
  end

  def run(worst_case: false)
    if worst_case
      name = "worst case"
      contexts = worst_case_contexts
    else
      name = "average case"
      contexts = average_case_contexts
    end
    puts "Benchmark (#{name}):"

    Benchmark.ips do |x|
      x.config(time: 5, warmup: 2)
      x.report("Without cache") do
        tag = build_no_cache_tag()
        contexts.each { |ctx| tag.render(Liquid::Context.new(ctx, {}, { site: @site })) }
      end

      x.report("With cache") do
        tag = build_memoized_tag()
        contexts.each { |ctx| tag.render(Liquid::Context.new(ctx, {}, { site: @site })) }
      end
      x.compare!
    end

    profile_memory("Without cache", contexts, name) do |ctx|
      tag = build_no_cache_tag()
      tag.render(Liquid::Context.new(ctx, {}, { site: @site }))
    end

    profile_memory("With cache", contexts, name) do |ctx|
      tag = build_memoized_tag()
      tag.render(Liquid::Context.new(ctx, {}, { site: @site }))
    end
  end

  def profile_memory(label, contexts, name)
    report = MemoryProfiler.report do
      contexts.each do |ctx|
        yield(ctx)
      end
    end

    puts "Memory profile for #{label} (#{name}):"
    puts "Total allocated: #{report.total_allocated_memsize / 1024.0} KB (#{report.total_allocated} objects)"
    puts "Total retained:  #{report.total_retained_memsize / 1024.0} KB (#{report.total_retained} objects)"
  end
end

LinkBenchmark.new().run(worst_case: false)
puts
LinkBenchmark.new().run(worst_case: true)
