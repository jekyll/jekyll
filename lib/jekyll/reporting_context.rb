# frozen_string_literal: true

module Jekyll
  class ReportingContext < Liquid::Context
    SAFE_KEYS = %w(jekyll site).freeze

    def find_variable(key)
      @cachable = false unless SAFE_KEYS.include? key
      super
    end

    def cachable?
      @cachable != false
    end
  end
end
