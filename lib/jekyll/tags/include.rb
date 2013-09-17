module Jekyll
  module Tags
    class IncludeTag < Liquid::Tag

      VALID_SYNTAX = /([\w-]+)\s*=\s*(?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w\.-]+))/

      SYNTAX_EXAMPLE = "{% include file.ext param='value' param2='value' %}"

      INCLUDES_DIR = '_includes'

      def initialize(tag_name, markup, tokens)
        super
        @file, @params = markup.strip.split(' ', 2);
        validate_file_name
      end

      def parse_params(context)
        validate_params

        params = {}
        markup = @params

        while match = VALID_SYNTAX.match(markup) do
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

      def validate_file_name
        if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
            raise SyntaxError.new <<-eos
Invalid syntax for include tag. File contains invalid characters or sequences:

	#{@file}

Valid syntax:

	#{SYNTAX_EXAMPLE}

eos
        end
      end

      def validate_params
        full_valid_syntax = Regexp.compile('\A\s*(?:' + VALID_SYNTAX.to_s + '(?=\s|\z)\s*)*\z')
        unless @params =~ full_valid_syntax
          raise SyntaxError.new <<-eos
Invalid syntax for include tag:

	#{@params}

Valid syntax:

	#{SYNTAX_EXAMPLE}

eos
        end
      end

      def render(context)
        dir = File.join(context.registers[:site].source, INCLUDES_DIR)
        if error = validate_dir(dir, context.registers[:site].safe)
          return error
        end

        file = File.join(dir, @file)
        if error = validate_file(dir, context.registers[:site].safe)
          return error
        end

        partial = Liquid::Template.parse(source(file))

        context.stack do
          context['include'] = parse_params(context) if @params
          partial.render(context)
        end
      end

      def validate_dir(dir, safe)
        if File.symlink?(dir) && safe
          "Includes directory '#{dir}' cannot be a symlink"
        end
      end

      def validate_file(file, safe)
        if !File.exists?(file)
          "Included file '#{@file}' not found in '#{INCLUDES_DIR}' directory"
        elsif File.symlink?(file) && safe
          "The included file '#{INCLUDES_DIR}/#{@file}' should not be a symlink"
        end
      end

      def blank?
        false
      end

      # This method allows to modify the file content by inheriting from the class.
      def source(file)
        File.read(file)
      end
    end
  end
end

Liquid::Template.register_tag('include', Jekyll::Tags::IncludeTag)
