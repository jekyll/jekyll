#!/usr/bin/env ruby

require "benchmark/ips"

PATH = "/../../..../...//.....//lorem/ipsum//dolor///sit.xyz"

def sanitize_with_regex
  "/" + PATH.gsub(%r!/{2,}!, "/").gsub(%r!\.+/|\A/+!, "")
end

def sanitize_with_builtin
  "/#{PATH}".gsub("..", "/").gsub("./", "").squeeze("/")
end

if sanitize_with_regex == sanitize_with_builtin
  Benchmark.ips do |x|
    x.report("sanitize w/ regexes") { sanitize_with_regex }
    x.report("sanitize w/ builtin") { sanitize_with_builtin }
    x.compare!
  end
else
  puts "w/ regexes: #{sanitize_with_regex}"
  puts "w/ builtin: #{sanitize_with_builtin}"
  puts ""
  puts "Thank you. Do try again :("
end
