module Jekyll
  module Tags
    class IncludeTag < Liquid::Tag

      MATCHER = /([\w-]+)\s*=\s*(?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w\.-]+))/

      attr_accessor :includes_dir

      def initialize(tag_name, markup, tokens)
        super
        @file, @params = markup.strip.split(' ', 2);
      end

      def parse_params(context)
        validate_syntax

        params = {}
        markup = @params

        while match = MATCHER.match(markup) do
          markup = markup[match.end(0)..-1]

          value = if match[2]
            match[2].gsub(/\\"/, '"')
          elsif match[3]
            match[3].gsub(/\\'/, "'")
          elsif match[4]
            context[match[4]]
          end

          params[match[1]] = value
        end
        params
      end

      # ensure the entire markup string from start to end is valid syntax, and params are separated by spaces
      def validate_syntax
        full_matcher = Regexp.compile('\A\s*(?:' + MATCHER.to_s + '(?=\s|\z)\s*)*\z')
        unless @params =~ full_matcher
          raise SyntaxError.new <<-eos
Invalid syntax for include tag:

	#{@params}

Valid syntax:

	{% include file.ext param='value' param2="value" %}

eos
        end
      end

      def render(context)
        self.includes_dir = File.join(context.registers[:site].source, '_includes')

        return error if error = validate_file


        source = File.read(File.join(includes_dir, @file))
        partial = Liquid::Template.parse(source)

        context.stack do
          context['include'] = parse_params(context) if @params
          partial.render(context)
        end
      end

      def validate_file
        if File.symlink?(self.includes_dir)
          return "Includes directory '#{self.includes_dir}' cannot be a symlink"
        end

        if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
          return "Include file '#{@file}' contains invalid characters or sequences"
        end

        file = File.join(self.includes_dir, @file)
        if !File.exists?(file)
          return "Included file #{@file} not found in _includes directory"
        elsif File.symlink?(file)
          return "The included file '_includes/#{@file}' should not be a symlink"
        end
      end
    end
  end
end

Liquid::Template.register_tag('include', Jekyll::Tags::IncludeTag)
