module Jekyll

  class Converter

    PRIORITIES = { :lowest => -100,
                   :low => -10,
                   :normal => 0,
                   :high => 10,
                   :highest => 100 }

    class << self
      def subclasses
        @subclasses ||= []
      end

      def inherited(base)
        subclasses << base
        subclasses.sort!
      end

      # priority order of this converter
      def priority(priority = nil)
        if priority && PRIORITIES.has_key?(priority)
          @priority = priority
        end
        @priority || :normal
      end

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

      # Spaceship is priority [higher -> lower]
      #
      # Returns -1, 0, 1
      def <=>(other)
        cmp = PRIORITIES[other.priority] <=> PRIORITIES[self.priority]
        return cmp
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