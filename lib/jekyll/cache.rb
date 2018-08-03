# frozen_string_literal: true

module Jekyll
  class Cache
    extend Forwardable

    def_delegators :@cache, :[], :[]=, :clear, :delete, :key?

    # Get an existing named cache, or create a new one if none exists
    #
    # name - name of the cache
    #
    # Returns nothing.
    # rubocop:disable Style/ClassVars
    def initialize(name)
      @@caches ||= {}
      @@caches[name] ||= {}
      @cache = @@caches[name]
    end
    # rubocop:enable Style/ClassVars

    def self.clear
      @@caches.clear
    end

    def getset(key)
      if key?(key)
        @cache[key]
      else
        @cache[key] = yield
      end
    end
  end
end
