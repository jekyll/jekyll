require "benchmark"
require "objspace"

def measure_time(label)
  t = Benchmark.realtime { yield }
  puts "Time: #{t.round(4)}s"
end

def measure_memory(label)
  GC.start
  mem_before = ObjectSpace.memsize_of_all
  yield
  GC.start
  mem_after = ObjectSpace.memsize_of_all
  mem_used = mem_after - mem_before
  puts "Memory: #{mem_used / 1024.0} KB"
end

def measure(label)
  puts label
  measure_time(label) do
    measure_memory(label) do
      yield
    end
  end
end

measure("lib/jekyll.rb load") do
  load_relative = File.expand_path("../lib/jekyll.rb", __dir__)
  load load_relative
end
