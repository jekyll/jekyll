#!/usr/bin/env ruby

require "benchmark/ips"

PATH = "../../../lorem/ipsum//dolor///sit"

def sanitize_with_regex
  "/" + PATH.gsub(%r!/{2,}!, "/").gsub(%r!\.+/|\A/+!, "")
end

def sanitize_with_builtin
  "/#{PATH}".delete(".").squeeze("/")
end

if sanitize_with_regex == sanitize_with_builtin
  Benchmark.ips do |x|
    x.report("sanitize w/ regexes") { sanitize_with_regex }
    x.report("sanitize w/ builtin") { sanitize_with_builtin }
    x.compare!
  end
else
  puts "Thank you. Do try again :("
end
