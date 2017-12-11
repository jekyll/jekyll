# frozen_string_literal: true

module Jekyll
  class LiquidRenderer
    class File
      def initialize(renderer, filename)
        @renderer = renderer
        @filename = filename
      end

      def parse(content)
        measure_time do
          @template = Liquid::Template.parse(content, :line_numbers => true)
        end

        self
      end

      def render(*args)
        measure_time do
          measure_bytes do
            @template.render(*args)
          end
        end
      end

      def render!(*args)
        measure_time do
          measure_bytes do
            @template.render!(*args)
          end
        end
      end

      def warnings
        @template.warnings
      end

      private

      def measure_bytes
        yield.tap do |str|
          @renderer.site.profiler.increment_bytes(@filename, :liquid, str.bytesize)
        end
      end

      def measure_time
        before = Time.now
        yield
      ensure
        after = Time.now
        @renderer.site.profiler.increment_time(@filename, :liquid, after - before)
      end
    end
  end
end
