module Jekyll
  class LogAdapter
    attr_reader :writer, :messages

    LOG_LEVELS = {
      :debug => ::Logger::DEBUG,
      :info  => ::Logger::INFO,
      :warn  => ::Logger::WARN,
      :error => ::Logger::ERROR,
    }.freeze

    # Public: Create a new instance of a log writer
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

    def adjust_verbosity(options = {})
      # Quiet always wins.
      if options[:quiet]
        self.log_level = :error
      elsif options[:verbose]
        self.log_level = :debug
      end
      debug "Logging at level:", LOG_LEVELS.key(writer.level).to_s
    end

    # Public: Print a debug message
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def debug(topic, message = nil)
      writer.debug(message(topic, message))
    end

    # Public: Print a message
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def info(topic, message = nil)
      writer.info(message(topic, message))
    end

    # Public: Print a message
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def warn(topic, message = nil)
      writer.warn(message(topic, message))
    end

    # Public: Print an error message
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def error(topic, message = nil)
      writer.error(message(topic, message))
    end

    # Public: Print an error message and immediately abort the process
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail (can be omitted)
    #
    # Returns nothing
    def abort_with(topic, message = nil)
      error(topic, message)
      abort
    end

    # Internal: Build a topic method
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns the formatted message
    def message(topic, message)
      msg = formatted_topic(topic) + message.to_s.gsub(%r!\s+!, " ")
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
