# frozen_string_literal: true

require 'jekyll'
require 'memory_profiler'

MemoryProfiler.report(allow_files: ['lib/jekyll/', 'lib/jekyll.rb']) do
  Jekyll::PluginManager.require_from_bundler
  Jekyll::Commands::Build.process({
    "source"             => File.expand_path(ARGV[0]),
    "destination"        => File.expand_path("#{ARGV[0]}/_site"),
    "disable_disk_cache" => true,
  })
  puts ''
end.pretty_print(scale_bytes: true, normalize_paths: true)
