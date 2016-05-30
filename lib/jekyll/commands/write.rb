module Jekyll
  module Commands
    class Write < Command
      def self.process(args, options = {})
        raise ArgumentError.new('You must specify either a path or a title.') if !options[:title] && !options[:path]

        case args[0]
        when "draft"
          path = generate_draft(options)
        when "post"
          path = generate_post(options)
        when "page"
          path = generate_page(options)
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

        if File.extname(path) === ""
          path = File.join(path, "index" + "." + options[:ext])
        end

        write_frontmatter(path, options[:title], false)

        return path
      end
    end
  end
end
