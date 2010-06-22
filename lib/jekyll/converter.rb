module Jekyll

  class Converter < Plugin
    # Public: Get or set the pygments prefix. When an argument is specified,
    # the prefix will be set. If no argument is specified, the current prefix
    # will be returned.
    #
    # pygments_prefix - The String prefix (default: nil).
    #
    # Returns the String prefix.
    def self.pygments_prefix(pygments_prefix = nil)
      @pygments_prefix = pygments_prefix if pygments_prefix
      @pygments_prefix
    end

    # Public: Get or set the pygments suffix. When an argument is specified,
    # the suffix will be set. If no argument is specified, the current suffix
    # will be returned.
    #
    # pygments_suffix - The String suffix (default: nil).
    #
    # Returns the String suffix.
    def self.pygments_suffix(pygments_suffix = nil)
      @pygments_suffix = pygments_suffix if pygments_suffix
      @pygments_suffix
    end

    # Initialize the converter.
    #
    # Returns an initialized Converter.
    def initialize(config = {})
      @config = config
    end

    # Get the pygments prefix.
    #
    # Returns the String prefix.
    def pygments_prefix
      self.class.pygments_prefix
    end

    # Get the pygments suffix.
    #
    # Returns the String suffix.
    def pygments_suffix
      self.class.pygments_suffix
    end
  end

end