module Jekyll
  module Traits
    module Categorable

      def categories
        @categories ||= []
      end

      def populate_categories
        categories_from_data = Utils.pluralized_array_from_hash(data, 'category', 'categories')
        @categories = (
          Array(categories) + categories_from_data
        ).map { |c| c.to_s }.flatten.uniq
      end

    end
  end
end
