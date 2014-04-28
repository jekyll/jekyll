module Jekyll
  module Commands
    class Publish < Command
      def self.init_with_program(prog)
        prog.command(:publish) do |c|
          c.syntax 'publish NAME'
          c.description 'Moves a draft into the _posts directory and sets the date'

          c.option 'date', '-d DATE', '--date DATE', 'Specify the post date'

          c.action do |args, options|
            Jekyll::Commands::Publish.process(args, options)
          end
        end
      end

      def self.process(args, options = {})
        raise ArgumentError.new('You must specify a name.') if args.empty?
        
        date = options["date"].nil? ? Date.today : Date.parse(options["date"])
        file = args.shift

        post_path = post_name(date, file)
        FileUtils.mv(draft_name(file), post_path)

        puts "Draft #{file} was published to ./#{post_path}"
      end 

      # Internal: Gets the filename of the post to be created
      #
      # Returns the filename of the post, as a String
      def self.post_name(date, name)
        "_posts/#{date.strftime('%Y-%m-%d')}-#{name}"
      end

      def self.draft_name(name)
        "_drafts/#{name}"
      end

    end
  end
end
