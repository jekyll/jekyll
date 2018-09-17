module Jekyll
  module Tags
    extend self
    def cache_include(key, subkey)
      @include_cache ||= {}
      @include_cache[key] ||= {}
      @include_cache[key][subkey] ||= yield
    end
  end
end
