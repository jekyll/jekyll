# frozen_string_literal: true

module Jekyll
  module Drops
    class PageDrop < Drop
      extend Forwardable

      mutable false

      def_delegators :@obj, :content, :dir, :name, :path, :url
      private def_delegator :@obj, :data, :fallback_data
    end
  end
end
