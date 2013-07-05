module Jekyll
  module Tags
    class IncludeTag < Liquid::Tag

      MATCHER = /([\w-]+)\s*=\s*(?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w\.-]+))/

      def initialize(tag_name, markup, tokens)
        super
        @file, @params = markup.strip.split(' ', 2);
      end

      def parse_params(markup, context)
        params = {}
        pos = 0

	# ensure the entire markup string from start to end is valid syntax, and params are separated by spaces
        full_matcher = Regexp.compile('\A\s*(?:' + MATCHER.to_s + '(?=\s|\z)\s*)*\z')
        unless markup =~ full_matcher
          raise SyntaxError.new <<-eos
Invalid syntax for include tag:

	#{markup}

Valid syntax:

	{% include file.ext param='value' param2="value" %}

eos
        end

        while match = MATCHER.match(markup) do
          markup = markup[match.end(0)..-1]

          if match[2]
            value = match[2].gsub(/\\"/, '"')
          elsif match[3]
            value = match[3].gsub(/\\'/, "'")
          elsif match[4]
            value = context[match[4]]
          end

          params[match[1]] = value
        end
        params
      end

      def render(context)
        includes_dir = File.join(context.registers[:site].source, '_includes')

        if File.symlink?(includes_dir)
          return "Includes directory '#{includes_dir}' cannot be a symlink"
        end

        if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
          return "Include file '#{@file}' contains invalid characters or sequences"
        end

        Dir.chdir(includes_dir) do
          choices = Dir['**/*'].reject { |x| File.symlink?(x) }
          if choices.include?(@file)
            source = File.read(@file)
            partial = Liquid::Template.parse(source)

            context.stack do
              context['include'] = parse_params(@params, context) if @params
              partial.render(context)
            end
          else
            "Included file '#{@file}' not found in _includes directory"
          end
        end
      end
    end
  end
end

Liquid::Template.register_tag('include', Jekyll::Tags::IncludeTag)
