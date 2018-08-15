# frozen_string_literal: true

require "digest"
require "fileutils"
require "pstore"

module Jekyll
  class Cache
    extend Forwardable

    # Get an existing named cache, or create a new one if none exists
    #
    # name - name of the cache
    #
    # Returns nothing.
    # rubocop:disable Style/ClassVars
    def initialize(name)
      throw unless defined? @@safe
      @@base_dir ||= File.expand_path(".jekyll-cache/Jekyll/Cache")
      @@caches ||= {}
      @cache = @@caches[name] ||= {}
      @name = name
      FileUtils.mkdir_p(path_to) if @@safe
    end

    def self.clear
      delete_cache_files
      @@caches.each_value(&:clear)
    end

    def self.safe(safe = true)
      @@safe = safe
    end
    # rubocop:enable Style/ClassVars

    def clear
      delete_cache_files
      @cache.clear
    end

    def [](key)
      return @cache[key] if @cache.key?(key)
      path = path_to(hash(key))
      if @@safe && File.file?(path) && File.readable?(path)
        @cache[key] = load(path)
      else
        raise
      end
    end

    def getset(key)
      return @cache[key] if @cache.key?(key)
      path = path_to(hash(key))
      if @@safe && File.file?(path) && File.readable?(path)
        value = load(path)
      else
        value = yield
        dump(path, value) if @@safe
      end
      @cache[key] = value
    end

    def []=(key, value)
      @cache[key] = value
      if @@safe
        path = path_to(hash(key))
        dump(path, value)
      end
    end

    def delete(key)
      @cache.delete(key)
      if @@safe
        path = path_to(hash(key))
        File.delete(path)
      end
    end

    def key?(key)
      return true if @cache.key?(key)
      return false unless @@safe
      path = path_to(hash(key))
      File.file?(path) && File.readable?(path)
    end

    # rubocop:disable Style/ClassVars
    def self.clear_if_config_changed(config)
      config = config.inspect
      cache = Jekyll::Cache.new "Jekyll::Cache"
      unless cache.key?("config") && cache["config"] == config
        delete_cache_files
        @@caches = {}
        cache = Jekyll::Cache.new "Jekyll::Cache"
        cache["config"] = config
      end
    end
    # rubocop:enable Style/ClassVars

    private

    def path_to(hash = nil)
      @base_dir ||= File.join(@@base_dir, @name)
      return @base_dir if hash.nil?
      File.join(@base_dir, hash[0..1], hash[2..-1]).freeze
    end

    def hash(key)
      Digest::SHA2.hexdigest(key).freeze
    end

    def delete_cache_files
      FileUtils.rm_rf(path_to) if @@safe
    end

    # rubocop:disable Security/MarshalLoad
    def load(path)
      raise unless @@safe
      cached_file = File.open(path, "rb")
      value = Marshal.load(cached_file)
      cached_file.close
      value
    end
    # rubocop:enable Security/MarshalLoad

    def dump(path, value)
      return unless @@safe
      dir = File.dirname(path)
      FileUtils.mkdir_p(dir)
      File.open(path, "wb") do |cached_file|
        Marshal.dump(value, cached_file)
      end
    end

    def self.delete_cache_files
      FileUtils.rm_rf(@@base_dir) if @@safe
    end
    private_class_method :delete_cache_files
  end
end
