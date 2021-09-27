#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark/ips'
require_relative '../lib/jekyll'

puts ''
print 'Setting up... '

SITE = Jekyll::Site.new(
  Jekyll.configuration({
    "source"             => File.expand_path("../docs", __dir__),
    "destination"        => File.expand_path("../docs/_site", __dir__),
    "disable_disk_cache" => true,
    "quiet"              => true,
  })
)

TEMPLATE_1 = Liquid::Template.parse(<<~HTML)
  {%- assign doc = site.documents | where: 'url', '/docs/assets/' | first -%}
  {{- doc.title -}}
HTML

TEMPLATE_2 = Liquid::Template.parse(<<~HTML)
  {%- assign doc = site.documents | find: 'url', '/docs/assets/' -%}
  {{- doc.title -}}
HTML

[:reset, :read, :generate].each { |phase| SITE.send(phase) }

puts 'done.'
puts 'Testing... '
puts "  #{'where + first'.cyan} results in #{TEMPLATE_1.render(SITE.site_payload).inspect.green}"
puts "  #{'find'.cyan} results in #{TEMPLATE_2.render(SITE.site_payload).inspect.green}"

if TEMPLATE_1.render(SITE.site_payload) == TEMPLATE_2.render(SITE.site_payload)
  puts 'Success! Proceeding to run benchmarks.'.green
  puts ''
else
  puts 'Something went wrong. Aborting.'.magenta
  puts ''
  return
end

Benchmark.ips do |x|
  x.report('where + first') { TEMPLATE_1.render(SITE.site_payload) }
  x.report('find') { TEMPLATE_2.render(SITE.site_payload) }
  x.compare!
end
