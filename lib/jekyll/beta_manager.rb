# frozen_string_literal: true

module Jekyll
  class BetaManager
    VALID_FEATURES = {}.freeze
    private_constant :VALID_FEATURES

    def initialize(site)
      @site = site
      @config = site.config["beta_features"]
      @config = {} unless @config.is_a?(Hash)
    end

    def enabled?(feature)
      return false unless VALID_FEATURES.key?(feature)

      @config[feature] == "enabled"
    end
  end
end
