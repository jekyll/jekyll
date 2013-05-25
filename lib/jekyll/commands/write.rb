module Jekyll
  module Commands
    class Write < Command
      def self.process(args, options = {})
        raise ArgumentError.new('You must specify either a path or a title.') if !options[:title] && !options[:path]

        case args[0]
        when "draft"
          generate_draft(options)
        when "post"
          generate_post(options)
        when "page"
          generate_page(options)
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
      end

      def self.generate_post(options)
        path = if options[:path]
          options[:path]
        else
          "_posts/#{Time.now.strftime('%Y-%m-%d')}-#{pathify(options[:title])}.#{options[:ext]}"
        end

        write_frontmatter(path, options[:title], true)
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
      end
    end
  end
end
