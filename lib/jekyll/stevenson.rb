module Jekyll
  class Stevenson
    attr_accessor :log_level

    LOG_LEVELS = {
      debug: 0,
      info:  1,
      warn:  2,
      error: 3
    }

    # Public: Create a new instance of Stevenson, Jekyll's logger
    #
    # level - (optional, symbol) the log level
    #
    # Returns nothing
    def initialize(level = :info)
      @log_level = level
    end

    # Public: Print a jekyll debug message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def debug(topic, message = nil)
      $stdout.puts(message(topic, message)) if should_log(:debug)
    end

    # Public: Print a jekyll message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def info(topic, message = nil)
      $stdout.puts(message(topic, message)) if should_log(:info)
    end

    # Public: Print a jekyll message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def warn(topic, message = nil)
      $stderr.puts(message(topic, message).yellow) if should_log(:warn)
    end

    # Public: Print a jekyll error message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def error(topic, message = nil)
      $stderr.puts(message(topic, message).red) if should_log(:error)
    end

    # Public: Print a Jekyll error message to stderr and immediately abort the process
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail (can be omitted)
    #
    # Returns nothing
    def abort_with(topic, message = nil)
      error(topic, message)
      abort
    end

    # Public: Build a Jekyll topic method
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns the formatted message
    def message(topic, message)
      formatted_topic(topic) + message.to_s.gsub(/\s+/, ' ')
    end

    # Public: Format the topic
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    #
    # Returns the formatted topic statement
    def formatted_topic(topic)
      "#{topic} ".rjust(20)
    end

    # Public: Determine whether the current log level warrants logging at the
    #         proposed level.
    #
    # level_of_message - the log level of the message (symbol)
    #
    # Returns true if the log level of the message is greater than or equal to
    #   this logger's log level.
    def should_log(level_of_message)
      LOG_LEVELS.fetch(log_level) <= LOG_LEVELS.fetch(level_of_message)
    end
  end
end
