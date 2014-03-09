module Jekyll
  class Stevenson
    attr_accessor :log_level

    DEBUG  = 0
    INFO   = 1
    WARN   = 2
    ERROR  = 3

    SYMBOL_MAP = {
      :debug => DEBUG,
      :info  => INFO,
      :warn  => WARN,
      :error => ERROR
    }

    # Public: Create a new instance of Stevenson, Jekyll's logger
    #
    # level - (optional, integer) the log level
    #
    # Returns nothing
    def initialize(level = INFO)
      set_log_level(level)
    end

    def set_log_level(level)
      if level.is_a?(Fixnum)
        @log_level = level
      elsif (level.is_a?(Symbol) || level.is_a?(String)) && SYMBOL_MAP.has_key?(level.to_sym)
        @log_level = SYMBOL_MAP[level.to_sym]
      else
        abort_with("Log level '#{level}' is not a valid log level.")
      end
    end

    # Public: Print a jekyll debug message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def debug(topic, message = nil)
      tell(message(topic, message), $stdout) if log_level <= DEBUG
    end

    # Public: Print a jekyll message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def info(topic, message = nil)
      tell(message(topic, message), $stdout) if log_level <= INFO
    end

    # Public: Print a jekyll message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def warn(topic, message = nil)
      tell(message(topic, message).yellow, $stderr) if log_level <= WARN
    end

    # Public: Print a jekyll error message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def error(topic, message = nil)
      tell(message(topic, message).red, $stderr) if log_level <= ERROR
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

    # Public: All the messages which have been printed
    #
    # Returns an array of strings which have been printed.
    def messages
      @messages ||= []
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

    # Internal: Save the message and print to the output buffer
    #
    # Returns nothing
    def tell(the_message, output_buffer = $stdout)
      messages << the_message
      buffer.puts(the_message)
    end
  end
end
