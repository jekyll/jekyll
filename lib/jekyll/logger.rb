module Jekyll
  module Logger
    # Public: Print a jekyll message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def info(topic, message)
      $stdout.puts Jekyll.message(topic, message)
    end

    # Public: Print a jekyll message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def warn(topic, message)
      $stderr.puts (Jekyll.message(topic, message)).yellow
    end

    # Public: Print a jekyll error message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def error(topic, message)
      $stderr.puts (Jekyll.message(topic, message)).red
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
