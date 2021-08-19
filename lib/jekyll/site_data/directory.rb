# frozen_string_literal: true

module Jekyll
  module SiteData
    class Directory < Hash
      attr_accessor :context

      def [](key)
        super.tap do |value|
          value.context = context if value.respond_to?(:context=)
        end
      end
    end
  end
end
