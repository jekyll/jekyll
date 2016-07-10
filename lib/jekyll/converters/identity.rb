module Jekyll
  module Converters
    class Identity < Converter
      safe true

      priority :lowest

      def matches(_ext)
        true
      end

      def output_ext(ext)
        ext
      end

      def convert(content)
        content
      end
    end
  end
end
