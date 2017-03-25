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

      def year
        @obj.date.strftime("%Y") # CCYY
      end

      def month
        @obj.date.strftime("%m") # MM
      end

      def day
        @obj.date.strftime("%d") # DD
      end

      def hour
        @obj.date.strftime("%H") # hh
      end

      def minute
        @obj.date.strftime("%M") # mm
      end

      def second
        @obj.date.strftime("%S") # ss
      end

      def i_day
        @obj.date.strftime("%-d") # D
      end

      def i_month
        @obj.date.strftime("%-m") # M
      end

      def short_month
        @obj.date.strftime("%^b") # MMM, uppercase
      end

      def long_month
        @obj.date.strftime("%B") # MMMM, initial capital
      end

      def short_year
        @obj.date.strftime("%y") # YY
      end

      def w_year
        @obj.date.strftime("%G") # CCYYw, ISO week date, same as %Y except for the first and last week of the year
      end

      def week
        @obj.date.strftime("%V") # WW, %W and %U do not comply with ISO 8601-1
      end

      def w_day
        @obj.date.strftime("%u") # d, 1..7
      end

      def short_day
        @obj.date.strftime("%^a") # dd, uppercase
      end

      def long_day
        @obj.date.strftime("%A") # ddd, initial capital
      end

      private
      def fallback_data
        {}
      end
    end
  end
end
