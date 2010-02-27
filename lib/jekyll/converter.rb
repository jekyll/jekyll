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

      # priority order of this converter
      def content_type(content_type = nil)
        @content_type = content_type if content_type
        @content_type || self.name.downcase.gsub(/^.*::/, '').gsub(/converter$/, '')
      end

      # Spaceship is priority [higher -> lower]
      #
      # Returns -1, 0, 1
      def <=>(other)
        cmp = PRIORITIES[other.priority] <=> PRIORITIES[self.priority]
        return cmp
      end
    end

    def content_type
      self.class.content_type
    end

  end

end