module Jekyll
  class Stevenson
    attr_accessor :log_level

    DEBUG  = 0
    INFO   = 1
    WARN   = 2
    ERRROR = 3

    # Public: Create a new instance of Stevenson, Jekyll's logger
    #
    # level - (optional, integer) the log level
    #
    # Returns nothing
    def initialize(level = INFO)
      @log_level = level
    end

    # Public: Print a jekyll message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def info(topic, message)
      $stdout.puts(message(topic, message)) if log_level <= INFO
    end

    # Public: Print a jekyll message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def warn(topic, message)
      $stderr.puts(message(topic, message).yellow) if log_level <= WARN
    end

    # Public: Print a jekyll error message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def error(topic, message)
      $stderr.puts(message(topic, message).red) if log_level <= ERROR
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
  end
end
