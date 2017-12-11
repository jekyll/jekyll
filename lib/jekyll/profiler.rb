# frozen_string_literal: true

require_relative "profiler/table"

module Jekyll
  class Profiler
    attr_reader :site, :stats

    def initialize(site)
      @site = site
      reset
    end

    def reset
      @stats = Hash.new { |hash, filename| hash[filename] = build_profile_hash }
    end

    def increment_count(filename, context)
      site.profiler.stats[filename][context][:count] += 1
    end

    def increment_bytes(filename, context, bytes)
      site.profiler.stats[filename][context][:bytes] += bytes
    end

    def increment_time(filename, context, time)
      site.profiler.stats[filename][context][:time] += time
    end

    def measure_all(filename, context)
      increment_count(filename, context)
      measure_time(filename, context) do
        measure_bytes(filename, context) do
          yield
        end
      end
    end

    def measure_bytes(filename, context)
      yield.tap do |str|
        increment_bytes(filename, context, str.bytesize)
      end
    end

    def measure_time(filename, context)
      before = Time.now
      yield
    ensure
      after = Time.now
      increment_time(filename, context, after - before)
    end

    def stats_table(n = 50)
      Profiler::Table.new(@stats).to_s(n)
    end

    def build_profile_hash
      {
        :reading => {
          :bytes => 0,
          :count => 0,
          :time  => 0.0,
        },
        :rendering => {
          :bytes => 0,
          :count => 0,
          :time  => 0.0,
        },
        :markdown => {
          :bytes => 0,
          :count => 0,
          :time  => 0.0,
        },
        :liquid => {
          :bytes => 0,
          :count => 0,
          :time  => 0.0,
        },
        :writing => {
          :bytes => 0,
          :count => 0,
          :time  => 0.0,
        },
      }
    end

  end
end
