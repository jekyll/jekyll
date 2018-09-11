# frozen_string_literal: true

module Jekyll
  class LocaleHandler
    def initialize(site)
      @site   = site
      @config = site.config
    end

    def reset
      @data = nil
    end

    def data
      @data ||= begin
        fallback = site.site_data.dig(config["locales_dir"], config["locale"])
        return {} unless fallback.is_a?(Hash)

        # transform hash to one with "latinized lowercased string keys"
        Utils.snake_case_keys(fallback)
      end
    end

    private

    attr_reader :site, :config
  end
end
