# frozen_string_literal: true

module Jekyll
  module FilterCache
    class << self
      def cache_url(site, filter_name, input)
        @cache_url ||= {}
        @cache_url[site] ||= {}
        @cache_url[site][filter_name] ||= {}
        @cache_url[site][filter_name][input] ||= yield
      end
    end
  end
end
