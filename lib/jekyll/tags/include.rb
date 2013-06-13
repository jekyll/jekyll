module Jekyll
  module Tags
    class IncludeTag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        super
        markup.strip!
        if markup.include?(' ')
          separator = markup.index(' ')
          @file = markup[0..separator].strip
          parse_params(markup[separator..-1])
        else
          @file = markup
        end
      end

      MATCHER = /(?<param>\w+)=(?:"(?<dvar>[^"\\]*(?:\\.[^"\\]*)*)"|'(?<svar>[^'\\]*(?:\\.[^'\\]*)*)')/

      def parse_params(markup)
        @params = {}
        pos = 0

	# ensure the entire markup string from start to end is valid syntax, and params are separated by spaces
        full_matcher = Regexp.compile('\A\s*(?:(?<=\s|\A)' + MATCHER.to_s + '\s*)*\z')
        if not markup =~ full_matcher
          raise SyntaxError.new <<-eos
Invalid syntax for include tag:

	#{markup}

Valid syntax:

	{% include file.ext param='value' param2="value" %}

eos
        end

        while match = MATCHER.match(markup, pos) do
          pos = match.end(0)

          if match[:dvar]
            value = match[:dvar].gsub(/\\"/, '"')
          elsif match[:svar]
            value = match[:svar].gsub(/\\'/, "'")
          end

          @params[match[:param]] = value
        end
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
            context['include'] = @params
            context.stack do
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
