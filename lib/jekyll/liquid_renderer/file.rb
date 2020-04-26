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
          @renderer.cache[@filename] ||= Liquid::Template.parse(content, :line_numbers => true)
        end
        @template = @renderer.cache[@filename]

        self
      end

      def render(*args)
        reset_template_assigns

        measure_time do
          measure_bytes do
            measure_counts do
              @template.render(*args)
            end
          end
        end
      end

      # This method simply 'rethrows any error' before attempting to render the template.
      def render!(*args)
        reset_template_assigns

        measure_time do
          measure_bytes do
            measure_counts do
              @template.render!(*args)
            end
          end
        end
      end

      def warnings
        @template.warnings
      end

      private

      # clear assigns to `Liquid::Template` instance prior to rendering since
      # `Liquid::Template` instances are cached in Jekyll 4.
      def reset_template_assigns
        @template.instance_assigns.clear
      end

      def measure_counts
        @renderer.increment_count(@filename)
        yield
      end

      def measure_bytes
        yield.tap do |str|
          @renderer.increment_bytes(@filename, str.bytesize)
        end
      end

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
