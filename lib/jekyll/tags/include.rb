module Jekyll
  module Tags
    class IncludeTagError < StandardError
      attr_accessor :path

      def initialize(msg, path)
        super(msg)
        @path = path
      end
    end

    class IncludeTag < Liquid::Tag

      SYNTAX_EXAMPLE = "{% include file.ext param='value' param2='value' %}"

      VALID_SYNTAX = /([\w-]+)\s*=\s*(?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w\.-]+))/      

      INCLUDES_DIR = '_includes'

      def initialize(tag_name, markup, tokens)
        super
        @file, @params = markup.strip.split(' ', 2);
        validate_syntax
      end

      def validate_syntax
        validate_file_name
        validate_params if @params
      end

      def parse_params(context)
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
            raise ArgumentError.new <<-eos
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
          raise ArgumentError.new <<-eos
Invalid syntax for include tag:

	#{@params}

Valid syntax:

	#{SYNTAX_EXAMPLE}

eos
        end
      end

      # Grab file read opts in the context
      def file_read_opts(context)
        context.registers[:site].file_read_opts
      end

      def render(context)
        dir = File.join(context.registers[:site].source, INCLUDES_DIR)
        validate_dir(dir, context.registers[:site].safe)

        file = File.join(dir, @file)
        validate_file(file, context.registers[:site].safe)

        partial = Liquid::Template.parse(source(file, context))

        context.stack do
          context['include'] = parse_params(context) if @params
          begin
            partial.render!(context)
          rescue => e
            raise IncludeTagError.new e.message, File.join(INCLUDES_DIR, @file)
          end
        end
      end

      def validate_dir(dir, safe)
        if File.symlink?(dir) && safe
          raise IOError.new "Includes directory '#{dir}' cannot be a symlink"
        end
      end

      def validate_file(file, safe)
        if !File.exists?(file)
          raise IOError.new "Included file '#{@file}' not found in '#{INCLUDES_DIR}' directory"
        elsif File.symlink?(file) && safe
          raise IOError.new "The included file '#{INCLUDES_DIR}/#{@file}' should not be a symlink"
        end
      end

      def blank?
        false
      end

      # This method allows to modify the file content by inheriting from the class.
      def source(file, context)
        File.read_with_options(file, file_read_opts(context))
      end
    end
  end
end

Liquid::Template.register_tag('include', Jekyll::Tags::IncludeTag)
