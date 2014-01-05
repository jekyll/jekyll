module Jekyll
  module Converters
   class Tilt < Converter
      safe true

      TILT_TO_HTML = %w[ad adoc asciidoc rdoc wiki creole mediawiki mw slim mab radius]
      TILT_TO_CSS  = %w[sass scss less]
      TILT_TO_JS   = %w[coffee]
      TILT_TO_XML  = %w[builder]

      TILT_EXTNAMES = TILT_TO_HTML | TILT_TO_CSS | TILT_TO_JS | TILT_TO_XML

      TILT_EXT_REXEP = Regexp.new(
        "(#{TILT_EXTNAMES.map{ |e| ".#{e}"}.join('|').gsub(/\./, '\.')})",
        Regexp::IGNORECASE
      )

      def matches(ext)
        @ext ||= ext
        !ext.match(TILT_EXT_REXEP).nil?
      end

      def output_ext(ext)
        subject = ext.strip.downcase.gsub(/^\./, '')
        if TILT_TO_HTML.include?(subject)
          ".html"
        elsif TILT_TO_CSS.include?(subject)
          ".css"
        elsif TILT_TO_JS.include?(subject)
          ".js"
        elsif TILT_TO_XML.include?(subject)
          ".xml"
        end
      end

      def convert(content)
        ::Tilt.new(current_filename) do |t|
          content
        end.render
      rescue LoadError => e
        raise FatalException.new("Missing dependency: #{e.message.to_s.split(' -- ').last}")
      end
    end
  end
end
