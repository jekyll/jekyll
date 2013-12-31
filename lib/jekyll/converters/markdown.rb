module Jekyll
  module Converters
    class Markdown < Converter
      safe true

      highlighter_prefix "\n"
      highlighter_suffix "\n"

      def setup
        return if @setup
        @parser =
          case @config['markdown'].downcase
            when 'redcarpet' then RedcarpetParser.new(@config)
            when 'kramdown' then KramdownParser.new(@config)
            when 'rdiscount' then RDiscountParser.new(@config)
            when 'maruku' then MarukuParser.new(@config)
          else
            # So they can't try some tricky bullshit or go down the ancestor chain, I hope.
            if allowed_custom_class?(@config['markdown'])
              self.class.const_get(@config['markdown']).new(@config)
            else
              Jekyll.logger.error "Invalid Markdown Processor:", "#{@config['markdown']}"
              Jekyll.logger.error "", "Valid options are [ maruku | rdiscount | kramdown | redcarpet ]"
              raise FatalException, "Invalid Markdown Processor: #{@config['markdown']}"
            end
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

      private

      # Private: Determine whether a class name is an allowed custom markdown
      # class name
      #
      # parser_name - the name of the parser class
      #
      # Returns true if the parser name contains only alphanumeric characters
      # and is defined within Jekyll::Converters::Markdown
      def allowed_custom_class?(parser_name)
        parser_name !~ /[^A-Za-z0-9]/ && self.class.constants.include?(parser_name.to_sym)
      end
    end
  end
end
