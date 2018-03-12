# frozen_string_literal: true

module Jekyll
  module Drops
    class ExcerptDrop < DocumentDrop
      def layout
        @obj.doc.data["layout"]
      end

      def excerpt
        nil
      end
    end
  end
end
