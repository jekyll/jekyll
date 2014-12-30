module Jekyll
  class LogAdapter
    attr_reader :writer, :messages

    LOG_LEVELS = {
      :debug => ::Logger::DEBUG,
      :info  => ::Logger::INFO,
      :warn  => ::Logger::WARN,
      :error => ::Logger::ERROR
    }

    # Public: Create a new instance of Jekyll's log writer
    #
    # writer - Logger compatible instance
    # log_level - (optional, symbol) the log level
    #
    # Returns nothing
    def initialize(writer, level = :info)
      @messages = []
      @writer = writer
      self.log_level = level
    end

    # Public: Set the log level on the writer
    #
    # level - (symbol) the log level
    #
    # Returns nothing
    def log_level=(level)
      writer.level = LOG_LEVELS.fetch(level)
    end

    # Public: Print a jekyll debug message
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def debug(topic, message = nil)
      writer.debug(message(topic, message))
    end

    # Public: Print a jekyll message
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def info(topic, message = nil)
      writer.info(message(topic, message))
    end

    # Public: Print a jekyll message
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def warn(topic, message = nil)
      writer.warn(message(topic, message))
    end

    # Public: Print a jekyll error message
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def error(topic, message = nil)
      writer.error(message(topic, message))
    end

    # Public: Print a Jekyll error message and immediately abort the process
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail (can be omitted)
    #
    # Returns nothing
    def abort_with(topic, message = nil)
      error(topic, message)
      abort
    end

    # Internal: Build a Jekyll topic method
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns the formatted message
    def message(topic, message)
      msg = formatted_topic(topic) + message.to_s.gsub(/\s+/, ' ')
      messages << msg
      msg
    end

    # Internal: Format the topic
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    #
    # Returns the formatted topic statement
    def formatted_topic(topic)
      "#{topic} ".rjust(20)
    end
  end
end
