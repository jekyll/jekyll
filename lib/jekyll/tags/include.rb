module Jekyll
  module Tags
    class IncludeTag < Liquid::Tag
      def initialize(tag_name, params, tokens)
        super

        if (params.include?(' '))
          separator = params.index(' ')
          @file = params[0..separator].strip
          params(params[separator..-1])
        else
          @file = params.strip
        end
      end

      def params(markup)
        last_space = last_quote = last_pos = pos = 0
        last_key = nil
        in_quotes = false
        @params = {}
        if !(/^(\s*\b\S+="(?:\\"|.)*?")*\s*$/ =~ markup)
          raise SyntaxError.new <<-eos
Syntax error for 'include'  while parsing the following markup:

  #{markup}

Valid syntax: include param="value"
eos
        end

        while pos = markup.index(/[=\"\s]/, pos)
          str = markup[pos, 1]
          if /\s/ =~ str
            last_space = pos
          elsif str == '='
            if last_key != nil
              raise SyntaxError.new <<-eos
Syntax Error in tag 'include' (missing value) while parsing the following markup:

  #{markup}

Valid syntax: include param="value"
eos
            end
            last_key = markup[last_space+1..pos-1]
          elsif str == '"' && markup[pos - 1, 1] != '\\'
            in_quotes = !in_quotes
            if !in_quotes
              value = markup[last_quote+1..pos-1].gsub(/\\"/, '"')
              @params[last_key] = value
              last_key = nil
            end
            last_quote = pos
          end
          last_pos = pos += 1
        end

        if in_quotes
          raise SyntaxError.new <<-eos
Syntax Error in tag 'include' (unterminated value) while parsing the following markup:

  #{markup}

Valid syntax: include param="value"
eos
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
