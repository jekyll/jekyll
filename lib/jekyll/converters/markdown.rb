module Jekyll
  module Converters
    class Markdown < Converter
      safe true

      pygments_prefix "\n"
      pygments_suffix "\n"

      def setup
        return if @setup
        @parser =
          case @config['markdown']
            when 'redcarpet' then RedcarpetParser.new(@config)
            when 'kramdown' then KramdownParser.new(@config)
            when 'rdiscount' then RDiscountParser.new(@config)
            when 'maruku' then MarukuParser.new(@config)
          else
            # So they can't try some tricky bullshit or go down the ancestor chain, I hope.
            if @config['markdown'] !~ /[^A-Za-z0-9]/ && self.class.constants.map(&:to_s).include?(@config['markdown'])
              self.class.const_get(@config['markdown']).new(@config)
            else
              Jekyll.logger.error "Invalid Markdown Processor:", "#{@config['markdown']}"
              Jekyll.logger.error "", "Valid options are [ maruku | rdiscount | kramdown | redcarpet ]"
              raise FatalException, "Invalid Markdown process: #{@config['markdown']}"
            end
          end
        @setup = true
      end

      def matches(ext)
        rgx = '(' + @config['markdown_ext'].gsub(',','|') +')'
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
