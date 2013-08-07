module Jekyll
  module Commands
    class Write < Command
      def self.process(args, options = {})
        raise ArgumentError.new('You must specify either a path or a title.') if !options[:title] && !options[:path]

        path = if %w[draft page post].include?(args[0])
          send("generate_#{args[0]}", options)
        else
          Jekyll.logger.warn "Invalid Argument:", "Jekyll can only write posts, pages and drafts for you. Beyond that, you're on your own."
          raise ArgumentError.new("Invalid type for writing: '#{args[0]}'")
        end

        if STDOUT.tty?
          Jekyll::Stevenson.info("Wrote #{args[0]} template to #{path}", "")
        else
          puts path
        end
      end

      def self.pathify(title)
        title.gsub(" ", "-").gsub(/[^\w-]/, "").downcase
      end

      def self.write_frontmatter(path, title, date)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, "w") do |file|
          file.puts("---")
          file.puts("title: #{title}") if title
          file.puts("date: #{Time.now.strftime('%d %h %Y %H:%M:%S')}") if date
          file.puts("---")
        end
      end

      def self.generate_draft(options)
        path = if options[:path]
          options[:path]
        else
          "_drafts/#{pathify(options[:title])}.#{options[:ext]}"
        end

        write_frontmatter(path, options[:title], false)

        return path
      end

      def self.generate_post(options)
        path = if options[:path]
          options[:path]
        else
          "_posts/#{Time.now.strftime('%Y-%m-%d')}-#{pathify(options[:title])}.#{options[:ext]}"
        end

        write_frontmatter(path, options[:title], true)

        return path
      end

      def self.generate_page(options)
        path = if options[:path]
          options[:path]
        else
          "#{pathify(options[:title])}.html"
        end

        if File.extname(path).empty?
          path = File.join(path, "index.#{options[:ext]}")
        end

        write_frontmatter(path, options[:title], false)

        return path
      end
    end
  end
end
