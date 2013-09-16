module Jekyll
  module Tags
    class IncludeTag < Liquid::Tag

      MATCHER = /([\w-]+)\s*=\s*(?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w\.-]+))/

      VALID_SYNTAX = "{% include file.ext param='value' param2='value' %}"

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
        validate_file_name
        validate_params
      end

      def validate_file_name
        if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
            raise SyntaxError.new <<-eos
Invalid syntax for include tag. File contains invalid characters or sequences:

	#{@file}

Valid syntax:

	#{VALID_SYNTAX}

eos
        end
      end

      def validate_params
        full_matcher = Regexp.compile('\A\s*(?:' + MATCHER.to_s + '(?=\s|\z)\s*)*\z')
        unless @params =~ full_matcher
          raise SyntaxError.new <<-eos
Invalid syntax for include tag:

	#{@params}

Valid syntax:

	#{VALID_SYNTAX}

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
        if File.symlink?(dir) && safe?
          return "Includes directory '#{dir}' cannot be a symlink"
        end
      end

      def validate_file(file, safe)
        if !File.exists?(file)
          return "Included file '#{@file}' not found in '#{INCLUDES_DIR}' directory"
        elsif File.symlink?(file) && safe?
          return "The included file '#{INCLUDES_DIR}/#{@file}' should not be a symlink"
        end
      end

      def blank?
        false
      end

      # This method allows to modify the file content by inheriting from the class.
      # Don’t refactor it. 
      def source(file)
        File.read(file)
      end
    end
  end
end

Liquid::Template.register_tag('include', Jekyll::Tags::IncludeTag)
