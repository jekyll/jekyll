module Jekyll
  module Utils
    module Rouge

      def self.html_formatter(*args)
        Jekyll::External.require_with_graceful_fail("rouge")
        html_formatter = ::Rouge::Formatters::HTML.new(*args)
        return html_formatter if old_api?

        ::Rouge::Formatters::HTMLPygments.new(html_formatter)
      end

      def self.old_api?
        ::Rouge.version.to_s < "2"
      end

    end
  end
end
