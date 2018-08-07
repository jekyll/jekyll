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
      @@caches ||= {}
      @cache = @@caches[name] ||= {}
      @name = name
      FileUtils.mkdir_p(path_to)
    end

    def self.clear
      delete_cache_files
      @@caches.each_value(&:clear)
    end
    # rubocop:enable Style/ClassVars

    def clear
      delete_cache_files(@name)
      @cache.clear
    end

    # rubocop:disable Security/MarshalLoad
    def [](key)
      return @cache[key] if @cache.key?(key)
      path = path_to(hash(key))
      if File.file?(path) && File.readable?(path)
        cached_file = File.open(path, "rb")
        value = Marshal.load(cached_file)
        cached_file.close
        @cache[key] = value
      else
        raise
      end
    end

    def getset(key)
      return @cache[key] if @cache.key?(key)
      path = path_to(hash(key))
      if File.file?(path) && File.readable?(path)
        cached_file = File.open(path, "rb")
        value = Marshal.load(cached_file)
      else
        value = yield
        cached_file = File.open(path, "wb")
        Marshal.dump(value, cached_file)
      end
      cached_file.close
      @cache[key] = value
    end
    # rubocop:enable Security/MarshalLoad

    def []=(key, value)
      @cache[key] = value
      path = path_to(hash(key))
      cached_file = File.open(path, "wb")
      Marshal.dump(value, cached_file)
      cached_file.close
    end

    def delete(key)
      @cache.delete(key)
      path = path_to(hash(key))
      File.delete(path)
    end

    def key?(key)
      return true if @cache.key?(key)
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
      base_dir = File.expand_path(".jekyll-cache/Jekyll/Cache/#{@name}")
      return base_dir if hash.nil?
      subdir = File.join(base_dir, "#{hash[0..1]}/")
      FileUtils.mkdir_p(subdir)
      File.join(subdir, hash[2..-1])
    end

    def hash(key)
      Digest::SHA2.hexdigest(key)
    end

    def self.delete_cache_files(name = "")
      FileUtils.rm_rf(".jekyll-cache/Jekyll/Cache/#{name}")
    end
    private_class_method :delete_cache_files
  end
end
