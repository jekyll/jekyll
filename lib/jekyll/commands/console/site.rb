# frozen_string_literal: true

module Jekyll
  class ConsoleSite < Site
    METHOD_MESSAGE_MAP = {
      "process"  => "Running full build process",
      "reset"    => "Resetting",
      "read"     => "Reading files",
      "generate" => "Running generators",
      "render"   => "Rendering",
      "cleanup"  => "Removing obsolete files from destination",
      "write"    => "Writing to destination",
    }.freeze
    private_constant :METHOD_MESSAGE_MAP

    METHOD_MESSAGE_MAP.each do |name, message|
      define_method("timed_#{name}") do
        run_timed(message) { __send__(name) }
      end
    end

    def pre_render
      run_timed("Reset > Read > Generate ") do
        reset
        read
        generate
      end
    end

    def post_render
      run_timed("Cleanup > Write ") do
        cleanup
        write
      end
    end

    private

    def run_timed(message)
      Jekyll.logger.info "Site:", "#{message}..".cyan
      t = Time.now
      yield
      Jekyll.logger.info "", "done in #{(Time.now - t).round(3).to_s.cyan} seconds."
    end
  end
end
