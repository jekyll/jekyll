# encoding: UTF-8

module Jekyll
  module Drops
    class UrlDrop < Drop
      extend Forwardable

      mutable false

      def_delegator :@obj, :cleaned_relative_path, :path
      def_delegator :@obj, :output_ext, :output_ext

      def collection
        @obj.collection.label
      end

      def name
        Utils.slugify(@obj.basename_without_ext)
      end

      def title
        Utils.slugify(@obj.data['slug'], :mode => "pretty", :cased => true) ||
          Utils.slugify(@obj.basename_without_ext, :mode => "pretty", :cased => true)
      end

      def slug
        Utils.slugify(@obj.data['slug']) || Utils.slugify(@obj.basename_without_ext)
      end

      def categories
        category_set = Set.new
        Array(@obj.data['categories']).each do |category|
          category_set << category.to_s.downcase
        end
        category_set.to_a.join('/')
      end

      def year
        @obj.date.strftime("%Y")
      end

      def month
        @obj.date.strftime("%m")
      end

      def day
        @obj.date.strftime("%d")
      end

      def hour
        @obj.date.strftime("%H")
      end

      def minute
        @obj.date.strftime("%M")
      end

      def second
        @obj.date.strftime("%S")
      end

      def i_day
        @obj.date.strftime("%-d")
      end

      def i_month
        @obj.date.strftime("%-m")
      end

      def short_month
        @obj.date.strftime("%b")
      end

      def short_year
        @obj.date.strftime("%y")
      end

      def y_day
        @obj.date.strftime("%j")
      end
    end
  end
end
