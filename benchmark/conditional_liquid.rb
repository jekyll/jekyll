#!/usr/bin/env ruby
# frozen_string_literal: true

require "liquid"
require "benchmark/ips"

# Test if processing content string without any Liquid constructs, via Liquid,
# is slower than checking whether constructs exist ( using `String#include?` )
# and return-ing the "plaintext" content string as is..
#
# Ref: https://github.com/jekyll/jekyll/pull/6735

# Sample contents
WITHOUT_LIQUID = <<-TEXT.freeze
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor libero at
pharetra tempus. Etiam bibendum magna et metus fermentum, eu cursus lorem
mattis. Curabitur vel dui et lacus rutrum suscipit et eget neque.

Nullam luctus fermentum est id blandit. Phasellus consectetur ullamcorper
ligula, at finibus eros laoreet id. Etiam sit amet est in libero efficitur
tristique. Ut nec magna augue. Quisque ut fringilla lacus, ac dictum enim.
Aliquam vel ornare mauris. Suspendisse ornare diam tempor nulla facilisis
aliquet. Sed ultrices placerat ultricies.
TEXT

WITH_LIQUID = <<-LIQUID.freeze
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor libero at
pharetra tempus. {{ author }} et metus fermentum, eu cursus lorem
mattis. Curabitur vel dui et lacus rutrum suscipit et eget neque.

Nullam luctus fermentum est id blandit. Phasellus consectetur ullamcorper
ligula, {% if author == "Jane Doe" %} at finibus eros laoreet id. {% else %}
Etiam sit amet est in libero efficitur.{% endif %}
tristique. Ut nec magna augue. Quisque ut fringilla lacus, ac dictum enim.
Aliquam vel ornare mauris. Suspendisse ornare diam tempor nulla facilisis
aliquet. Sed ultrices placerat ultricies.
LIQUID

WITH_JUST_LIQUID_VAR = <<-LIQUID.freeze
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor libero at
pharetra tempus. et metus fermentum, eu cursus lorem, ac dictum enim.
mattis. Curabitur vel dui et lacus rutrum suscipit et {{ title }} neque.

Nullam luctus fermentum est id blandit. Phasellus consectetur ullamcorper
ligula, at finibus eros laoreet id. Etiam sit amet est in libero efficitur.
tristique. Ut nec magna augue. {{ author }} Quisque ut fringilla lacus
Aliquam vel ornare mauris. Suspendisse ornare diam tempor nulla facilisis
aliquet. Sed ultrices placerat ultricies.
LIQUID

SUITE = {
  :"plain text"  => WITHOUT_LIQUID,
  :"tags n vars" => WITH_LIQUID,
  :"just vars"   => WITH_JUST_LIQUID_VAR,
}.freeze

# Mimic how Jekyll's LiquidRenderer would process a non-static file, with
# some dummy payload
def always_liquid(content)
  Liquid::Template.error_mode = :warn
  Liquid::Template.parse(content, :line_numbers => true).render(
    "author" => "John Doe",
    "title"  => "FooBar"
  )
end

# Mimic how the proposed change would first execute a couple of checks and
# proceed to process with Liquid if necessary
def conditional_liquid(content)
  return content if content.nil? || content.empty?
  return content unless content.include?("{%") || content.include?("{{")
  always_liquid(content)
end

# Test https://github.com/jekyll/jekyll/pull/6735#discussion_r165499868
# ------------------------------------------------------------------------
def check_with_regex(content)
  !content.to_s.match?(%r!{[{%]!)
end

def check_with_builtin(content)
  content.include?("{%") || content.include?("{{")
end

SUITE.each do |key, text|
  Benchmark.ips do |x|
    x.report("regex-check   - #{key}") { check_with_regex(text) }
    x.report("builtin-check - #{key}") { check_with_builtin(text) }
    x.compare!
  end
end
# ------------------------------------------------------------------------

# Let's roll!
SUITE.each do |key, text|
  Benchmark.ips do |x|
    x.report("always thru liquid - #{key}") { always_liquid(text) }
    x.report("conditional liquid - #{key}") { conditional_liquid(text) }
    x.compare!
  end
end
