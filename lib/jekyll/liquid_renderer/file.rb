# frozen_string_literal: true

module Jekyll
  class LiquidRenderer
    class File
      def initialize(renderer, filename)
        @renderer = renderer
        @filename = filename
      end

      def parse(content)
        measure_time("liquid") do
          @renderer.cache[@filename] ||= Liquid::Template.parse(content, :line_numbers => true)
        end
        @template = @renderer.cache[@filename]

        self
      end

      def render_markup(converter, content)
        profile("markup") do
          converter.convert(content)
        end
      end

      def render(*args)
        profile do
          @template.render(*args)
        end
      end

      # This method simply 'rethrows any error' before attempting to render the template.
      def render!(*args)
        profile do
          @template.render!(*args)
        end
      end

      def warnings
        @template.warnings
      end

      private

      def measure_counts(type)
        @renderer.increment_count(@filename, type)
        yield
      end

      def measure_bytes(type)
        yield.tap do |str|
          @renderer.increment_bytes(@filename, str.bytesize, type)
        end
      end

      def measure_time(type)
        before = Time.now
        yield
      ensure
        after = Time.now
        @renderer.increment_time(@filename, (after - before), type)
      end

      def profile(type = "liquid")
        measure_time(type) do
          measure_bytes(type) do
            measure_counts(type) do
              yield
            end
          end
        end
      end
    end
  end
end
