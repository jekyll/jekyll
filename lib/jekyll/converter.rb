# frozen_string_literal: true

module Jekyll
  class Converter < Plugin
    # Public: Get or set the highlighter prefix. When an argument is specified,
    # the prefix will be set. If no argument is specified, the current prefix
    # will be returned.
    #
    # highlighter_prefix - The String prefix (default: nil).
    #
    # Returns the String prefix.
    def self.highlighter_prefix(highlighter_prefix = nil)
      unless defined?(@highlighter_prefix) && highlighter_prefix.nil?
        @highlighter_prefix = highlighter_prefix
      end
      @highlighter_prefix
    end

    # Public: Get or set the highlighter suffix. When an argument is specified,
    # the suffix will be set. If no argument is specified, the current suffix
    # will be returned.
    #
    # highlighter_suffix - The String suffix (default: nil).
    #
    # Returns the String suffix.
    def self.highlighter_suffix(highlighter_suffix = nil)
      unless defined?(@highlighter_suffix) && highlighter_suffix.nil?
        @highlighter_suffix = highlighter_suffix
      end
      @highlighter_suffix
    end

    # Initialize the converter.
    #
    # Returns an initialized Converter.
    def initialize(config = {})
      @config = config
    end

    # Get the highlighter prefix.
    #
    # Returns the String prefix.
    def highlighter_prefix
      self.class.highlighter_prefix
    end

    # Get the highlighter suffix.
    #
    # Returns the String suffix.
    def highlighter_suffix
      self.class.highlighter_suffix
    end
  end
end
