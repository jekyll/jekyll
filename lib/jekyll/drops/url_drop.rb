# frozen_string_literal: true

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
        Utils.slugify(@obj.data["slug"], :mode => "pretty", :cased => true) ||
          Utils.slugify(@obj.basename_without_ext, :mode => "pretty", :cased => true)
      end

      def slug
        Utils.slugify(@obj.data["slug"]) || Utils.slugify(@obj.basename_without_ext)
      end

      def categories
        category_set = Set.new
        Array(@obj.data["categories"]).each do |category|
          category_set << category.to_s.downcase
        end
        category_set.to_a.join("/")
      end

      # CCYY
      def year
        @obj.date.strftime("%Y")
      end

      # MM: 01..12
      def month
        @obj.date.strftime("%m")
      end

      # DD: 01..31
      def day
        @obj.date.strftime("%d")
      end

      # hh: 00..23
      def hour
        @obj.date.strftime("%H")
      end

      # mm: 00..59
      def minute
        @obj.date.strftime("%M")
      end

      # ss: 00..59
      def second
        @obj.date.strftime("%S")
      end

      # D: 1..31
      def i_day
        @obj.date.strftime("%-d")
      end

      # M: 1..12
      def i_month
        @obj.date.strftime("%-m")
      end

      # MMM: Jan..Dec
      def short_month
        @obj.date.strftime("%b")
      end

      # MMMM: January..December
      def long_month
        @obj.date.strftime("%B")
      end

      # YY: 00..99
      def short_year
        @obj.date.strftime("%y")
      end

      # CCYYw, ISO week year
      # may differ from CCYY for the first days of January and last days of December
      def w_year
        @obj.date.strftime("%G")
      end

      # WW: 01..53
      # %W and %U do not comply with ISO 8601-1
      def week
        @obj.date.strftime("%V")
      end

      # d: 1..7 (Monday..Sunday)
      def w_day
        @obj.date.strftime("%u")
      end

      # dd: Mon..Sun
      def short_day
        @obj.date.strftime("%a")
      end

      # ddd: Monday..Sunday
      def long_day
        @obj.date.strftime("%A")
      end

      # DDD: 001..366
      def y_day
        @obj.date.strftime("%j")
      end

      private

      def fallback_data
        @fallback_data ||= {}
      end
    end
  end
end
