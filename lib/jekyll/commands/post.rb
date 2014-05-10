module Jekyll
  module Commands
    class Post < Command
      def self.init_with_program(prog)
        prog.command(:post) do |c|
          c.syntax 'post NAME'
          c.description 'Creates a new post with the given NAME'

          c.option 'type', '-t TYPE', '--type TYPE', 'Specify the content type'
          c.option 'layout', '-t LAYOUT', '--layout LAYOUT', 'Specify the post layout'
          c.option 'date', '-d DATE', '--date DATE', 'Specify the post date'
          c.option 'force', '-f', '--force', 'Overwrite a post if it already exists'

          c.action do |args, options|
            Jekyll::Commands::Post.process(args, options)
          end
        end
      end

      def self.process(args, options = {})
        raise ArgumentError.new('You must specify a name.') if args.empty?
        
        type = options["type"].nil? ? "markdown" : options["type"]
        layout = options["layout"].nil? ? "post" : options["layout"]

        date = options["date"].nil? ? Time.now : DateTime.parse(options["date"])

        title = args.shift
        name = title.gsub(' ', '-').downcase

        post_path = file_name(name, type, date)

        raise ArgumentError.new("A post already exists at ./#{post_path}") if File.exist?(post_path) and !options["force"]

        File.open(post_path, "w") do |f|
          f.puts(front_matter(layout, title))
        end

        puts "New post created at ./#{post_path}.\n"
      end 
      # Internal: Gets the filename of the draft to be created
      #
      # Returns the filename of the draft, as a String
      def self.file_name(name, ext, date)
        "_posts/#{date.strftime('%Y-%m-%d')}-#{name}.#{ext}"
      end

      def self.front_matter(layout, title)
        "---
layout: #{layout}
title: #{title}
---"
      end
    end
  end
end
