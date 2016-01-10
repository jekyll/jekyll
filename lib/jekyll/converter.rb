module Jekyll
  class Converter < Plugin
    extend Forwardable

    #

    def_delegator :"self.class", :highlighter_prefix
    def_delegator :"self.class", :highlighter_suffix

    #

    def initialize(config = {})
      @config = config
    end

    # highlighter_prefix - The String prefix (default: nil).
    # Public: Get or set the highlighter prefix. When an argument is
    # specified, the prefix will be set. If no argument is specified, the
    # current prefix will be returned.
    # Returns the String prefix.

    def self.highlighter_prefix(highlighter_prefix = nil)
      @highlighter_prefix = highlighter_prefix if highlighter_prefix
      @highlighter_prefix
    end

    # highlighter_suffix - The String suffix (default: nil).
    # Public: Get or set the highlighter suffix. When an argument is
    # specified, the suffix will be set. If no argument is specified, the
    # current suffix will be returned.
    # Returns the String suffix.

    def self.highlighter_suffix(highlighter_suffix = nil)
      @highlighter_suffix = highlighter_suffix if highlighter_suffix
      @highlighter_suffix
    end
  end
end
