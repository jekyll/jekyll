# frozen_string_literal: true

module Jekyll
  module Drops
    class JekyllDrop < Liquid::Drop
      class << self
        def global
          @global ||= JekyllDrop.new
        end
      end

      def version
        Jekyll::VERSION
      end

      def environment
        Jekyll.env
      end

      def to_h
        @to_h ||= {
          "version"     => version,
          "environment" => environment,
        }
      end

      def to_json(state = nil)
        require "json"
        JSON.generate(to_h, state)
      end
    end
  end
end
