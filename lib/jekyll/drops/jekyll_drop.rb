# encoding: UTF-8

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
    end
  end
end
