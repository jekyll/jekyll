#!/usr/bin/env ruby
# frozen_string_literal: true

require "forwardable"
require "colorator"
require "liquid"
require "benchmark/ips"
require "memory_profiler"

# Set up (memory) profiler

class Profiler
  def self.run
    yield new(ARGV[0] || 10_000)
  end

  def initialize(count)
    @count = count.to_i
  end

  def report(label, color, &block)
    prof_report = MemoryProfiler.report { @count.to_i.times(&block) }

    allocated_memory  = prof_report.scale_bytes(prof_report.total_allocated_memsize)
    allocated_objects = prof_report.total_allocated
    retained_memory   = prof_report.scale_bytes(prof_report.total_retained_memsize)
    retained_objects  = prof_report.total_retained

    puts <<~MSG.send(color)
      With #{label} calls

      Total allocated: #{allocated_memory} (#{allocated_objects} objects)
      Total retained:  #{retained_memory} (#{retained_objects} objects)
    MSG
  end
end

# Set up stage

class Drop < Liquid::Drop
  def initialize(obj)
    @obj = obj
  end
end

class ForwardDrop < Drop
  extend Forwardable
  def_delegators :@obj, :name
end

class StaticDrop < Drop
  def name
    @obj.name
  end
end

class Document
  def name
    "lipsum"
  end
end

# Set up actors

document = Document.new
alpha    = ForwardDrop.new(document)
beta     = StaticDrop.new(document)
count    = ARGV[0] || 10_000

# Run profilers
puts "\nMemory profiles for #{count} calls to invoke drop key:"
Profiler.run do |x|
  x.report("forwarded", :cyan) { alpha["name"] }
  x.report("static", :green) { beta["name"] }
end

# Benchmark
puts "\nBenchmarking the two scenarios..."
Benchmark.ips do |x|
  x.report("forwarded".cyan) { alpha["name"] }
  x.report("static".green) { beta["name"] }
  x.compare!
end
