# frozen_string_literal: true

require 'benchmark/ips'
require 'jekyll'

class FooPage
  def initialize(dir:, name:)
    @dir = dir
    @name = name
  end

  def slow_path
    File.join(*[@dir, @name].map(&:to_s).reject(&:empty?)).sub(%r!\A/!, "")
  end

  def fast_path
    Jekyll::PathManager.join(@dir, @name).sub(%r!\A/!, "")
  end
end

nil_page     = FooPage.new(:dir => nil, :name => nil)
empty_page   = FooPage.new(:dir => "", :name => "")
root_page    = FooPage.new(:dir => "", :name => "ipsum.md")
nested_page  = FooPage.new(:dir => "lorem", :name => "ipsum.md")
slashed_page = FooPage.new(:dir => "/lorem/", :name => "/ipsum.md")

if nil_page.slow_path == nil_page.fast_path
  Benchmark.ips do |x|
    x.report('nil_page slow') { nil_page.slow_path }
    x.report('nil_page fast') { nil_page.fast_path }
    x.compare!
  end
end

if empty_page.slow_path == empty_page.fast_path
  Benchmark.ips do |x|
    x.report('empty_page slow') { empty_page.slow_path }
    x.report('empty_page fast') { empty_page.fast_path }
    x.compare!
  end
end

if root_page.slow_path == root_page.fast_path
  Benchmark.ips do |x|
    x.report('root_page slow') { root_page.slow_path }
    x.report('root_page fast') { root_page.fast_path }
    x.compare!
  end
end

if nested_page.slow_path == nested_page.fast_path
  Benchmark.ips do |x|
    x.report('nested_page slow') { nested_page.slow_path }
    x.report('nested_page fast') { nested_page.fast_path }
    x.compare!
  end
end

if slashed_page.slow_path == slashed_page.fast_path
  Benchmark.ips do |x|
    x.report('slashed_page slow') { slashed_page.slow_path }
    x.report('slashed_page fast') { slashed_page.fast_path }
    x.compare!
  end
end
