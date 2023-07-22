# frozen_string_literal: true

module Jekyll
  module Drops
    class ExcerptDrop < DocumentDrop
      def layout
        @obj.doc.data["layout"]
      end

      def date
        @obj.doc.date
      end

      def excerpt
        nil
      end

      def name
        @obj.doc.data["name"] || @obj.doc.basename
      end
    end
  end
end
