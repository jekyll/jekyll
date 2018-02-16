# frozen_string_literal: true

module Jekyll
  module Utils
    module Rouge

      def self.html_formatter(*args)
        Jekyll::External.require_with_graceful_fail("rouge") unless defined?(::Rouge)
        if old_api?
          ::Rouge::Formatters::HTML.new(*args)
        else
          ::Rouge::Formatters::HTMLLegacy.new(*args)
        end
      end

      def self.old_api?
        ::Rouge.version.to_s < "2"
      end
    end
  end
end
