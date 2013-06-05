module Jekyll
  class Stevenson
    attr_reader :log_level

    DEBUG = 0
    INFO  = 1
    WARN  = 2
    ERROR = 3

    # Public: Create a new instance of Stevenson, Jekyll's logger
    #
    # level - a Symbol indicating the log level. One of:
    #   - :debug
    #   - :info
    #   - :warn
    #   - :error
    #
    # Returns nothing
    def initialize(level = :info)
      log_level = level
    end

    # Public: Set the log level
    #
    # level - a Symbol indicating the log level.
    #
    # Returns nothing.
    def log_level=(level)
      @log_level = level.to_sym
      @log_level_int = log_level_as_int(@log_level)
    end

    # Public: Print a jekyll message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def info(topic, message)
      $stdout.puts(message(topic, message)) if @log_level_int <= INFO
    end

    # Public: Print a jekyll message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def warn(topic, message)
      $stderr.puts(message(topic, message).yellow) if @log_level_int <= WARN
    end

    # Public: Print a jekyll error message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def error(topic, message)
      $stderr.puts(message(topic, message).red) if @log_level_int <= ERROR
    end

    # Public: Build a Jekyll topic method
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns the formatted message
    def message(topic, message)
      formatted_topic(topic) + message.gsub(/\s+/, ' ')
    end

    # Public: Format the topic
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    #
    # Returns the formatted topic statement
    def formatted_topic(topic)
      "#{topic} ".rjust(20)
    end

    private

    # Private: Determine the integer representation of the given log level.
    #
    # level - a Symbol representing the log level
    #
    # Throws: ArgumentError when the log level is invalid.
    #
    # Returns an integer representation of the log level.
    def log_level_as_int(level)
      case level
      when :debug
        DEBUG
      when :info
        INFO
      when :warn
        WARN
      when :error
        ERROR
      else
        raise ArgumentError.new("The log level '#{level}' is not a valid log level.")
      end
    end
  end
end
