require 'yaml'
require 'erb'

module Jekyll
  module Commands
    class New < Command
      def self.process(args)
        args_joined = args.join(" ")

        if args_joined.empty?
          puts "You must provide a path."
        else
          path = File.expand_path(args_joined, Dir.pwd)

          template_site = File.expand_path("../../site_template", File.dirname(__FILE__))
          FileUtils.cp_r template_site, path

          File.open(File.expand_path(initialized_post_name, path), "w") do |f|
            f.write(scaffold_post_content(template_site))
          end
          File.unlink(File.expand_path(sample_post_path, path))

          puts "New jekyll site installed in #{path}."
        end
      end

      # Internal: Processes the sample post template
      #
      # Returns the processed ERB post template file content as a String
      def self.scaffold_post_content(template_site)
        ERB.new(File.read(File.expand_path(sample_post_path, template_site))).result
      end

      # Internal: Gets the filename of the sample post to be created
      #
      # Returns the filename of the sample post as a String
      def self.initialized_post_name
        "_posts/#{Time.now.strftime('%Y-%m-%d')}-welcome-to-jekyll.markdown"
      end

      # Internal: Gets the path of the file containing the sample post template
      #
      # Returns the filename of the sample post template as a String
      def self.sample_post_path
        "_posts/0000-00-00-sample_post.markdown.erb"
      end
    end
  end
end
