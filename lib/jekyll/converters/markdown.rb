module Jekyll
  module Converters
    class Markdown < Converter
      safe true

      highlighter_prefix "\n"
      highlighter_suffix "\n"

      def setup
        return if @setup
        @parser = case @config['markdown']
          when 'redcarpet'
            RedcarpetParser.new @config
          when 'kramdown'
            KramdownParser.new @config
          when 'rdiscount'
            RDiscountParser.new @config
          when 'maruku'
            MarukuParser.new @config
          else
            STDERR.puts "Invalid Markdown processor: #{@config['markdown']}"
            STDERR.puts "  Valid options are [ maruku | rdiscount | kramdown | redcarpet ]"
            raise FatalException.new("Invalid Markdown process: #{@config['markdown']}")
        end
        @setup = true
      end

      def matches(ext)
        rgx = '^\.(' + @config['markdown_ext'].gsub(',','|') +')$'
        ext =~ Regexp.new(rgx, Regexp::IGNORECASE)
      end

      def output_ext(ext)
        ".html"
      end

      def convert(content)
        setup
        @parser.convert(content)
      end
    end
  end
end
