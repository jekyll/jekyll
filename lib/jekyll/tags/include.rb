# frozen_string_literal: true

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
      VALID_SYNTAX = %r!
        ([\w-]+)\s*=\s*
        (?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w\.-]+))
      !x
      VARIABLE_SYNTAX = %r!
        (?<variable>[^{]*(\{\{\s*[\w\-\.]+\s*(\|.*)?\}\}[^\s{}]*)+)
        (?<params>.*)
      !x

      def initialize(tag_name, markup, tokens)
        super
        matched = markup.strip.match(VARIABLE_SYNTAX)
        if matched
          @file = matched["variable"].strip
          @params = matched["params"].strip
        else
          @file, @params = markup.strip.split(%r!\s+!, 2)
        end
        validate_params if @params
        @tag_name = tag_name
      end

      def syntax_example
        "{% #{@tag_name} file.ext param='value' param2='value' %}"
      end

      def parse_params(context)
        params = {}
        markup = @params

        while (match = VALID_SYNTAX.match(markup))
          markup = markup[match.end(0)..-1]

          value = if match[2]
                    match[2].gsub(%r!\\"!, '"')
                  elsif match[3]
                    match[3].gsub(%r!\\'!, "'")
                  elsif match[4]
                    context[match[4]]
                  end

          params[match[1]] = value
        end
        params
      end

      def validate_file_name(file)
        if file !~ %r!^[a-zA-Z0-9_/\.-]+$! || file =~ %r!\./! || file =~ %r!/\.!
          raise ArgumentError, <<-MSG
Invalid syntax for include tag. File contains invalid characters or sequences:

  #{file}

Valid syntax:

  #{syntax_example}

MSG
        end
      end

      def validate_params
        full_valid_syntax = %r!\A\s*(?:#{VALID_SYNTAX}(?=\s|\z)\s*)*\z!
        unless @params =~ full_valid_syntax
          raise ArgumentError, <<-MSG
Invalid syntax for include tag:

  #{@params}

Valid syntax:

  #{syntax_example}

MSG
        end
      end

      # Grab file read opts in the context
      def file_read_opts(context)
        context.registers[:site].file_read_opts
      end

      # Render the variable if required
      def render_variable(context)
        if @file.match(VARIABLE_SYNTAX)
          partial = context.registers[:site]
            .liquid_renderer
            .file("(variable)")
            .parse(@file)
          partial.render!(context)
        end
      end

      def tag_includes_dirs(context)
        context.registers[:site].includes_load_paths.freeze
      end

      def locate_include_file(context, file, safe)
        includes_dirs = tag_includes_dirs(context)
        includes_dirs.each do |dir|
          path = File.join(dir.to_s, file.to_s)
          return path if valid_include_file?(path, dir.to_s, safe)
        end
        raise IOError, "Could not locate the included file '#{file}' in any of "\
          "#{includes_dirs}. Ensure it exists in one of those directories and, "\
          "if it is a symlink, does not point outside your site source."
      end

      def render(context)
        site = context.registers[:site]

        file = render_variable(context) || @file
        validate_file_name(file)

        path = locate_include_file(context, file, site.safe)
        return unless path

        add_include_to_dependency(site, path, context)

        partial = load_cached_partial(path, context)

        context.stack do
          context["include"] = parse_params(context) if @params
          begin
            partial.render!(context)
          rescue Liquid::Error => e
            e.template_name = path
            e.markup_context = "included " if e.markup_context.nil?
            raise e
          end
        end
      end

      def add_include_to_dependency(site, path, context)
        if context.registers[:page] && context.registers[:page].key?("path")
          site.regenerator.add_dependency(
            site.in_source_dir(context.registers[:page]["path"]),
            path
          )
        end
      end

      def load_cached_partial(path, context)
        context.registers[:cached_partials] ||= {}
        cached_partial = context.registers[:cached_partials]

        if cached_partial.key?(path)
          cached_partial[path]
        else
          unparsed_file = context.registers[:site]
            .liquid_renderer
            .file(path)
          begin
            cached_partial[path] = unparsed_file.parse(read_file(path, context))
          rescue Liquid::Error => e
            e.template_name = path
            e.markup_context = "included " if e.markup_context.nil?
            raise e
          end
        end
      end

      def valid_include_file?(path, dir, safe)
        !outside_site_source?(path, dir, safe) && File.file?(path)
      end

      def outside_site_source?(path, dir, safe)
        safe && !realpath_prefixed_with?(path, dir)
      end

      def realpath_prefixed_with?(path, dir)
        File.exist?(path) && File.realpath(path).start_with?(dir)
      rescue StandardError
        false
      end

      # This method allows to modify the file content by inheriting from the class.
      def read_file(file, context)
        File.read(file, file_read_opts(context))
      end
    end

    class IncludeRelativeTag < IncludeTag
      def tag_includes_dirs(context)
        Array(page_path(context)).freeze
      end

      def page_path(context)
        if context.registers[:page].nil?
          context.registers[:site].source
        else
          current_doc_dir = File.dirname(context.registers[:page]["path"])
          context.registers[:site].in_source_dir current_doc_dir
        end
      end
    end
  end
end

Liquid::Template.register_tag("include", Jekyll::Tags::IncludeTag)
Liquid::Template.register_tag("include_relative", Jekyll::Tags::IncludeRelativeTag)
