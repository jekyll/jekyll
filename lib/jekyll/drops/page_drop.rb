# frozen_string_literal: true

module Jekyll
  module Drops
    class PageDrop < Drop
      extend Forwardable

      mutable false

      def_delegators :@obj, :content, :dir, :name, :path, :url, :excerpt
      private def_delegator :@obj, :data, :fallback_data

      def title
        @obj.data["title"]
      end
    end
  end
end
