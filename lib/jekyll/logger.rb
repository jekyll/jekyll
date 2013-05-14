require 'logger'

module Jekyll
  class Stevenson < Logger
    # Public: Print a jekyll message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def self.info(topic, message)
      $stdout.puts message(topic, message)
    end

    # Public: Print a jekyll message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def self.warn(topic, message)
      $stderr.puts message(topic, message).yellow
    end

    # Public: Print a jekyll error message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def self.error(topic, message)
      $stderr.puts message(topic, message).red
    end

    # Public: Build a Jekyll topic method
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns the formatted message
    def self.message(topic, message)
       formatted_topic(topic) + message.gsub(/\s+/, ' ')
    end

    # Public: Format the topic
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    #
    # Returns the formatted topic statement
    def self.formatted_topic(topic)
      "#{topic} ".rjust(20)
    end
  end
end
