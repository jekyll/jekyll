# frozen_string_literal: true

module Jekyll
  module Drops
    class UrlDrop < Drop
      extend Forwardable

      def self.strftime_delegator(notation, method)
        define_method(method) do
          @obj.date.strftime(notation)
        end
      end
      private_class_method :strftime_delegator

      #

      mutable false

      def_delegator :@obj, :cleaned_relative_path, :path
      def_delegator :@obj, :output_ext, :output_ext

      strftime_delegator "%Y",  :year
      strftime_delegator "%m",  :month
      strftime_delegator "%d",  :day
      strftime_delegator "%H",  :hour
      strftime_delegator "%M",  :minute
      strftime_delegator "%S",  :second
      strftime_delegator "%b",  :short_month
      strftime_delegator "%y",  :short_year
      strftime_delegator "%j",  :y_day
      strftime_delegator "%-d", :i_day
      strftime_delegator "%-m", :i_month

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

      private

      def fallback_data
        {}
      end
    end
  end
end
