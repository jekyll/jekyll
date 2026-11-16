# frozen_string_literal: true

module Jekyll
  module Drops
    class ThemeDrop < Drop
      delegate_method_as :runtime_dependencies, :dependencies

      def root
        @root ||= ENV["JEKYLL_ENV"] == "development" ? @obj.root : ""
      end

      def authors
        @authors ||= gemspec ? gemspec.authors.join(", ") : ""
      end

      def version
        @version ||= gemspec ? gemspec.version.to_s : ""
      end

      def description
        @description ||= gemspec ? (gemspec.description || gemspec.summary) : ""
      end

      def metadata
        @metadata ||= gemspec ? gemspec.metadata : {}
      end

      private

      def gemspec
        @gemspec ||= @obj.send(:gemspec)
      end

      def fallback_data
        @fallback_data ||= {}
      end
    end
  end
end
