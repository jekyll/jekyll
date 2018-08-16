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
      unless defined? @@disk_cache_enabled
        @@disk_cache_enabled = true
      end
      @@base_dir ||= File.expand_path(".jekyll-cache/Jekyll/Cache")
      @@caches ||= {}
      @cache = @@caches[name] ||= {}
      @name = name.gsub(%r![^\w\s-]!, "-")
      FileUtils.mkdir_p(path_to) if @@disk_cache_enabled
    end

    def self.clear
      delete_cache_files
      @@caches.each_value(&:clear)
    end

    def self.disable_disk_cache!
      @@disk_cache_enabled = false
    end
    # rubocop:enable Style/ClassVars

    def clear
      delete_cache_files
      @cache.clear
    end

    def [](key)
      return @cache[key] if @cache.key?(key)
      path = path_to(hash(key))
      if @@disk_cache_enabled && File.file?(path) && File.readable?(path)
        @cache[key] = load(path)
      else
        raise
      end
    end

    def []=(key, value)
      @cache[key] = value
      if @@disk_cache_enabled
        path = path_to(hash(key))
        dump(path, value)
      end
    end

    def getset(key)
      self[key]
    rescue StandardError
      value = yield
      self[key] = value
      value
    end

    def delete(key)
      @cache.delete(key)
      if @@disk_cache_enabled
        path = path_to(hash(key))
        File.delete(path)
      end
    end

    def key?(key)
      return true if @cache.key?(key)
      return false unless @@disk_cache_enabled
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
      FileUtils.rm_rf(path_to) if @@disk_cache_enabled
    end

    # rubocop:disable Security/MarshalLoad
    def load(path)
      raise unless @@disk_cache_enabled
      cached_file = File.open(path, "rb")
      value = Marshal.load(cached_file)
      cached_file.close
      value
    end
    # rubocop:enable Security/MarshalLoad

    def dump(path, value)
      return unless @@disk_cache_enabled
      dir = File.dirname(path)
      FileUtils.mkdir_p(dir)
      File.open(path, "wb") do |cached_file|
        Marshal.dump(value, cached_file)
      end
    end

    def self.delete_cache_files
      FileUtils.rm_rf(@@base_dir) if @@disk_cache_enabled
    end
    private_class_method :delete_cache_files
  end
end
