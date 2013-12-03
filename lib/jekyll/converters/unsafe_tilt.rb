module Jekyll
  module Converters
    class UnsafeTilt < Converter
      safe false

      TO_HTML = %w[haml]

      UNSAFE_TILT_EXTNAMES = TO_HTML

      TILT_EXT_REXEP = Regexp.new(
        "(#{UNSAFE_TILT_EXTNAMES.map{ |e| ".#{e}"}.join('|').gsub(/\./, '\.')})",
        Regexp::IGNORECASE
      )

      def matches(ext)
        !ext.match(TILT_EXT_REXEP).nil?
      end

      def output_ext(ext)
        subject = ext.strip.downcase.gsub(/^\./, '')
        if TILT_TO_HTML.include?(subject)
          ".html"
        end
      end

      def convert(content)
        ::Tilt.new(current_filename) do |t|
          content
        end.render
      rescue LoadError => e
        raise FatalException.new("Tilt Exception when converting #{current_filename}: #{e.message}")
      end
    end
  end
end