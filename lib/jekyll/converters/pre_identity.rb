module Jekyll
  module Converters
    # The default converter to run before parsing liquid tags
    # Converters need to be direct descendents of the Converter
    # class, so we can't subclass Jekyll::Converters::Identity
    class PreIdentity < Converter
      run_before_liquid!

      safe true

      priority :lowest

      def matches(ext)
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
