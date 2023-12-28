# frozen_string_literal: true

module Jekyll
  class Stevenson < ::Logger
    def initialize
      formatter = proc do |_, _, _, msg|
        msg.to_s
      end
      super($stdout, :formatter => formatter)
    end

    def add(severity, message = nil, progname = nil)
      severity ||= UNKNOWN
      @logdev = logdevice(severity)

      if @logdev.nil? || severity < @level
        return true
      end
      progname ||= @progname
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @progname
        end
      end
      @logdev.puts(
        format_message(format_severity(severity), Time.now, progname, message)
      )
      true
    end

    # Log a +WARN+ message
    def warn(progname = nil, &block)
      add(WARN, nil, progname.yellow, &block)
    end

    # Log an +ERROR+ message
    def error(progname = nil, &block)
      add(ERROR, nil, progname.red, &block)
    end

    def close
      # No LogDevice in use
    end

    private

    def logdevice(severity)
      if severity > INFO
        $stderr
      else
        $stdout
      end
    end
  end
end
