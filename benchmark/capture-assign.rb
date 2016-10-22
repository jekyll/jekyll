#!/usr/bin/env ruby
require "liquid"
require "benchmark/ips"

puts "Ruby #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
puts "Liquid #{Liquid::VERSION}"

template1 = '{% capture foobar %}foo{{ bar }}{% endcapture %}{{ foo }}{{ foobar }}'
template2 = '{% assign foobar = "foo" | append: bar %}{{ foobar }}'

def render(template)
  Liquid::Template.parse(template).render("bar" => "42")
end

puts render(template1)
puts render(template2)

Benchmark.ips do |x|
  x.report('capture') { render(template1) }
  x.report('assign')  { render(template2) }
end
