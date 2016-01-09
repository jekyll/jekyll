module Jekyll
  class Plugin
    PRIORITIES = {
      :low => -10,
      :highest => 100,
      :lowest => -100,
      :normal => 0,
      :high => 10
    }

    #

    def self.inherited(const)
      const.define_singleton_method :inherited do |const_|
        (@children ||= Set.new).merge [
          const_
        ]
      end
    end

    #

    def self.descendants
      @children || Set.new
    end

    # Get or set the priority of this plugin. When called without an
    # argument it returns the priority. When an argument is given, it will
    # set the priority.
    #
    # priority - The Symbol priority (default: nil). Valid options are:
    #            :lowest, :low, :normal, :high, :highest
    #
    # Returns the Symbol priority.
    def self.priority(priority = nil)
      @priority ||= nil
      if priority && PRIORITIES.key?(priority)
        @priority = priority
      end
      @priority || :normal
    end

    # Get or set the safety of this plugin. When called without an argument
    # it returns the safety. When an argument is given, it will set the
    # safety.
    #
    # safe - The Boolean safety (default: nil).
    #
    # Returns the safety Boolean.
    def self.safe(safe = nil)
      if safe
        @safe = safe
      end
      @safe || false
    end

    # Spaceship is priority [higher -> lower]
    #
    # other - The class to be compared.
    #
    # Returns -1, 0, 1.
    def self.<=>(other)
      PRIORITIES[other.priority] <=> PRIORITIES[self.priority]
    end

    # Spaceship is priority [higher -> lower]
    #
    # other - The class to be compared.
    #
    # Returns -1, 0, 1.
    def <=>(other)
      self.class <=> other.class
    end

    # Initialize a new plugin. This should be overridden by the subclass.
    #
    # config - The Hash of configuration options.
    #
    # Returns a new instance.
    def initialize(config = {})
      # no-op for default
    end
  end
end
