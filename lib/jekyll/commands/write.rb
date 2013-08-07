module Jekyll
  module Commands
    class Write < Command
      def self.process(args, options = {})
        raise ArgumentError.new('You must specify either a path or a title.') if !options[:title] && !options[:path]

        type = args[0].downcase

        template = if %w[draft page post].include?(type)
          Jekyll::Template.new(type, options)
        else
          Jekyll.logger.warn "Invalid Argument:", "Jekyll can only write posts, pages and drafts for you. Beyond that, you're on your own."
          raise ArgumentError.new("Invalid type for writing: '#{type}'")
        end

        template.write

        if STDOUT.tty?
          Jekyll::Stevenson.info("Wrote #{type} template to #{template.path}")
        else
          template.puts path
        end
      end
    end
  end
end
