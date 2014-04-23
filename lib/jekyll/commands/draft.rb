module Jekyll
  module Commands
    class Draft < Command
      def self.init_with_program(prog)
        prog.command(:draft) do |c|
          c.syntax 'draft NAME'
          c.description 'Creates a new draft post with the given NAME'

          c.option 'type', '-t TYPE', '--type TYPE', 'Specify the content type'
          c.option 'layout', '-l LAYOUT', '--layout LAYOUT', 'Specify the post layout'
          c.option 'force', '-f', '--force', 'Overwrite a draft if it already exists'

          c.action do |args, options|
            Jekyll::Commands::Draft.process(args, options)
          end
        end
      end

      def self.process(args, options = {})
        raise ArgumentError.new('You must specify a name.') if args.empty?
        
        type = options["type"].nil? ? "markdown" : options["type"]
        layout = options["layout"].nil? ? "post" : options["layout"]

        title = args.shift
        name = title.gsub(' ', '-').downcase

        draft_path = draft_name(name, type)

        raise ArgumentError.new("A draft already exists at ./#{draft_path}") if File.exist?(draft_path) and !options["force"]

        File.open(draft_path, "w") do |f|
          f.puts(front_matter(layout, title))
        end

        puts "New draft created at ./#{draft_path}.\n"
      end 
      # Internal: Gets the filename of the draft to be created
      #
      # Returns the filename of the draft, as a String
      def self.draft_name(name, ext='markdown')
        "_drafts/#{name}.#{ext}"
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
