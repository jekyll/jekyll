module Jekyll
  class LiquidRenderer
    class File
      def initialize(renderer, filename)
        @renderer = renderer
        @filename = filename
      end

      def parse(content)
        measure_time do
          @template = Liquid::Template.parse(content)
        end

        self
      end

      def render(*args)
        measure_time do
          @template.render(*args)
        end
      end

      def render!(*args)
        measure_time do
          @template.render!(*args)
        end
      end

      private

      def measure_time
        before = Time.now
        yield
      ensure
        after = Time.now
        @renderer.increment_time(@filename, after - before)
      end
    end
  end
end
