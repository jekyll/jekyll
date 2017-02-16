module Jekyll
  module Utils
    module RougeFormatter

      def self.html(*args)
        Jekyll::External.require_with_graceful_fail("rouge")
        if Rouge.version < "2"
          Rouge::Formatters::HTML.new(*args)
        else
          Rouge::Formatters::HTMLPygments.new(*args)
        end
      end

    end
  end
end
