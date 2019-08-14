# frozen_string_literal: true

require "jekyll"

namespace :profile do
  desc "Profile allocations from a build session"
  task :memory, [:file, :mode] do |_t, args|
    args.with_defaults(file: "memprof.txt", mode: "lite")

    build_phases = [:reset, :read, :generate, :render, :cleanup, :write]
    safe_mode    = false

    if args.mode == "lite"
      build_phases -= [:render, :generate]
      safe_mode     = true
    end

    require "memory_profiler"

    report = MemoryProfiler.report do
      site = Jekyll::Site.new(
        Jekyll.configuration(
          "source"      => File.expand_path("../docs", __dir__),
          "destination" => File.expand_path("../docs/_site", __dir__),
          "safe"        => safe_mode
        )
      )

      Jekyll.logger.info "Source:", site.source
      Jekyll.logger.info "Destination:", site.dest
      Jekyll.logger.info "Plugins and Cache:", site.safe ? "disabled" : "enabled"
      Jekyll.logger.info "Profiling phases:", build_phases.join(", ").cyan
      Jekyll.logger.info "Profiling..."

      build_phases.each { |phase| site.send phase }

      Jekyll.logger.info "", "and done. Generating results.."
      Jekyll.logger.info ""
    end

    if ENV["CI"]
      report.pretty_print(scale_bytes: true, color_output: false, normalize_paths: true)
    else
      FileUtils.mkdir_p("tmp")
      report_file = File.join("tmp", args.file)

      total_allocated_output = report.scale_bytes(report.total_allocated_memsize)
      total_retained_output  = report.scale_bytes(report.total_retained_memsize)

      Jekyll.logger.info "Total allocated: #{total_allocated_output} (#{report.total_allocated} objects)".cyan
      Jekyll.logger.info "Total retained:  #{total_retained_output} (#{report.total_retained} objects)".cyan

      report.pretty_print(to_file: report_file, scale_bytes: true, normalize_paths: true)
      Jekyll.logger.info "\nDetailed Report saved into:", report_file.cyan
    end
  end
end
