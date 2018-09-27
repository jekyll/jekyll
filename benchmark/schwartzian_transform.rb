#!/usr/bin/env ruby
# frozen_string_literal: true
#
# The Ruby documentation for #sort_by describes what's called a Schwartzian transform:
#
#  > A more efficient technique is to cache the sort keys (modification times in this case)
#  > before the sort. Perl users often call this approach a Schwartzian transform, after
#  > Randal Schwartz. We construct a temporary array, where each element is an array
#  > containing our sort key along with the filename. We sort this array, and then extract
#  > the filename from the result.
#  > This is exactly what sort_by does internally.
#
# The well-documented efficiency of sort_by is a good reason to use it. However, when a property
# does not exist on an item being sorted, it can cause issues (no nil's allowed!)
# In Jekyll::Filters#sort_input, we extract the property in each iteration of #sort,
# which is quite inefficient! How inefficient? This benchmark will tell you just how, and how much
# it can be improved by using the Schwartzian transform. Thanks, Randall!

require 'benchmark/ips'
require 'minitest'
require File.expand_path("../lib/jekyll", __dir__)

def site
  @site ||= Jekyll::Site.new(
    Jekyll.configuration("source" => File.expand_path("../docs", __dir__))
  ).tap(&:reset).tap(&:read)
end

def site_docs
  site.collections["docs"].docs.dup
end

def sort_by_property_directly(docs, meta_key)
  docs.sort! do |apple, orange|
    apple_property = apple[meta_key]
    orange_property = orange[meta_key]

    if !apple_property.nil? && !orange_property.nil?
      apple_property <=> orange_property
    elsif !apple_property.nil? && orange_property.nil?
      -1
    elsif apple_property.nil? && !orange_property.nil?
      1
    else
      apple <=> orange
    end
  end
end

def schwartzian_transform(docs, meta_key)
  docs.collect! { |d|
    [d[meta_key], d]
  }.sort! { |apple, orange|
    if !apple[0].nil? && !orange[0].nil?
      apple.first <=> orange.first
    elsif !apple[0].nil? && orange[0].nil?
      -1
    elsif apple[0].nil? && !orange[0].nil?
      1
    else
      apple[-1] <=> orange[-1]
    end
  }.collect! { |d| d[-1] }
end

# Before we test efficiency, do they produce the same output?
class Correctness
  include Minitest::Assertions

  require "pp"
  define_method :mu_pp, &:pretty_inspect

  attr_accessor :assertions

  def initialize(docs, property)
    @assertions = 0
    @docs = docs
    @property = property
  end

  def assert!
    assert sort_by_property_directly(@docs, @property).is_a?(Array), "sort_by_property_directly must return an array"
    assert schwartzian_transform(@docs, @property).is_a?(Array), "schwartzian_transform must return an array"
    assert_equal sort_by_property_directly(@docs, @property),
      schwartzian_transform(@docs, @property)
    puts "Yeah, ok, correctness all checks out for property #{@property.inspect}"
  end
end

Correctness.new(site_docs, "redirect_from".freeze).assert!
Correctness.new(site_docs, "title".freeze).assert!

def test_property(property, meta_key)
  Benchmark.ips do |x|
    x.config(time: 10, warmup: 5)
    x.report("sort_by_property_directly with #{property} property") do
      sort_by_property_directly(site_docs, meta_key)
    end
    x.report("schwartzian_transform with #{property} property") do
      schwartzian_transform(site_docs, meta_key)
    end
    x.compare!
  end
end

# First, test with a property only a handful of documents have.
test_property('sparse', 'redirect_from')

# Next, test with a property they all have.
test_property('non-sparse', 'title')
