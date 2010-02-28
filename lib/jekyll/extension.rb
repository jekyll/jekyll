module Jekyll

  class Extension

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

      def all
        subclasses
      end

      # priority order of this converter
      def priority(priority = nil)
        if priority && PRIORITIES.has_key?(priority)
          @priority = priority
        end
        @priority || :normal
      end

      # Spaceship is priority [higher -> lower]
      #
      # Returns -1, 0, 1
      def <=>(other)
        cmp = PRIORITIES[other.priority] <=> PRIORITIES[self.priority]
        return cmp
      end
    end

    def initialize(config = {})
      #no-op for default
    end

  end

end