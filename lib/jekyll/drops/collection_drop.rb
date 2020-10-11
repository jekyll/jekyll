# frozen_string_literal: true

module Jekyll
  module Drops
    class CollectionDrop < Drop
      extend Forwardable

      mutable false

      delegate_method_as :write?, :output
      delegate_methods :label, :docs, :files, :directory, :relative_directory

      private delegate_method_as :metadata, :fallback_data

      def to_s
        docs.to_s
      end
    end
  end
end
