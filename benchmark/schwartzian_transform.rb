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
require File.expand_path("../lib/jekyll", __dir__)

site = Jekyll::Site.new(
  Jekyll.configuration("source" => File.expand_path("../docs", __dir__))
).tap(&:reset).tap(&:read)

def sort_by_property_directly(docs, meta_key)
  docs.sort do |apple, orange|
    apple_property = apple[meta_key]
    orange_property = orange[meta_key]

    if !apple_property.nil? && !orange_property.nil?
      apple_property <=> orange_property
    else
      apple <=> orange
    end
  end
end

def schwartzian_transform(docs, meta_key)
  docs.collect { |d|
    [d[meta_key], d]
  }.sort { |apple, orange|
    if !apple.first.nil? && !orange.first.nil?
      apple.first <=> orange.first
    else
      apple.last <=> orange.last
    end
  }.collect { |d| d.last }
end

# First, test with a property only a handful of documents have.
Benchmark.ips do |x|
  x.report('sort_by_property_directly with sparse property') do
    sort_by_property_directly(site.collections["docs"].docs, "redirect_from".freeze)
  end
  x.report('schwartzian_transform with sparse property') do
    schwartzian_transform(site.collections["docs"].docs, "redirect_from".freeze)
  end
  x.compare!
end

# Next, test with a property they all have.
Benchmark.ips do |x|
  x.report('sort_by_property_directly with non-sparse property') do
    sort_by_property_directly(site.collections["docs"].docs, "title".freeze)
  end
  x.report('schwartzian_transform with non-sparse property') do
    schwartzian_transform(site.collections["docs"].docs, "title".freeze)
  end
  x.compare!
end
