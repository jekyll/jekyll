module Jekyll
  module Traits
    module Taggable

      attr_accessor :tags

      def populate_tags
        @tags ||= Utils.pluralized_array_from_hash(data, "tag", "tags").flatten
      end

    end
  end
end
