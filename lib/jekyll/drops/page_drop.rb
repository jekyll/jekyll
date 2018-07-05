# frozen_string_literal: true

module Jekyll
  module Drops
    class PageDrop < Drop
      extend Forwardable

      mutable false

      PAGE_ATTRIBUTES = [:name, :content, :dir, :url].freeze
      private def_delegator :@obj, :data, :fallback_data

      PAGE_ATTRIBUTES.each do |attribute|
        define_method attribute do
          fallback_data[attribute.to_s] || @obj.send(attribute)
        end
      end

      def path
        fallback_data["path"] || @obj.relative_path
      end
    end
  end
end
