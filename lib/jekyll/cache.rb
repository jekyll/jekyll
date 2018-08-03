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

    def self.clear
      @@caches ||= {}
      @@caches.clear
    end
    # rubocop:enable Style/ClassVars

    # rubocop:disable Lint/UselessSetterCall
    def self.clear_if_config_changed(config)
      cache = Jekyll::Cache.new "Jekyll::Cache"
      clear unless cache["config"] == config
      cache["config"] = config
    end
    # rubocop:enable Lint/UselessSetterCall

    def getset(key)
      if key?(key)
        @cache[key]
      else
        @cache[key] = yield
      end
    end
  end
end
