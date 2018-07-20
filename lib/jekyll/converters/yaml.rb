# frozen_string_literal: true

module Jekyll
  module Converters
    class Yaml < Converter
      safe true

      def matches(ext)
        %w(.yaml .yml).include?(ext.downcase)
      end

      def output_ext(ext)
        ".html"
      end

      def convert(content)
        content || ""
      end
    end
  end
end
