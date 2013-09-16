module Jekyll
  module Tags
    class IncludeTag < Liquid::Tag

      MATCHER = /([\w-]+)\s*=\s*(?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w\.-]+))/

      INCLUDES_DIR = '_includes'

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
        dir = includes_dir(context)

        if error = validate_file(dir)
          return error
        end

        partial = Liquid::Template.parse(source(dir))

        context.stack do
          context['include'] = parse_params(context) if @params
          partial.render(context)
        end
      end

      def validate_file(dir)
        if File.symlink?(dir) && context.registers[:site].safe?
          return "Includes directory '#{dir}' cannot be a symlink"
        end

        if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
          return "Include file '#{@file}' contains invalid characters or sequences"
        end

        file = File.join(dir, @file)
        if !File.exists?(file)
          return "Included file #{@file} not found in #{INCLUDES_DIR} directory"
        elsif File.symlink?(file) && context.registers[:site].safe?
          return "The included file '#{INCLUDES_DIR}/#{@file}' should not be a symlink"
        end
      end

      def blank?
        false
      end

      # This method allows to modify the file content by inheriting from the class.
      # Don’t refactor it. 
      def source(dir)
        File.read(File.join(dir, @file))
      end

      def includes_dir(context)
        File.join(context.registers[:site].source, INCLUDES_DIR)
      end
    end
  end
end

Liquid::Template.register_tag('include', Jekyll::Tags::IncludeTag)
