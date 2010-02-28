module Jekyll

  class Converter < Extension

    class << self
      # prefix for highlighting
      def pygments_prefix(pygments_prefix = nil)
        @pygments_prefix = pygments_prefix if pygments_prefix
        @pygments_prefix
      end

      # suffix for highlighting
      def pygments_suffix(pygments_suffix = nil)
        @pygments_suffix = pygments_suffix if pygments_suffix
        @pygments_suffix
      end
    end

    # prefix for highlighting
    def pygments_prefix
      self.class.pygments_prefix
    end

    # suffix for highlighting
    def pygments_suffix
      self.class.pygments_suffix
    end

  end

end