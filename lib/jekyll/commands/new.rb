require 'yaml'
require 'erb'

module Jekyll
  module Commands
    class New < Command
      def self.process(args)
        arg_string = args.join(" ")
        raise ArgumentError, "You must specify a path." if arg_string.empty?
        install_path = File.expand_path(arg_string, Dir.pwd)

        template_site = File.expand_path("../../site_template", File.dirname(__FILE__))
        FileUtils.cp_r template_site, install_path

        File.open(File.expand_path(initialized_post_name, install_path), "w") do |f|
          f.write(scaffold_post_content(template_site))
        end
        File.unlink(File.expand_path(sample_post_path, install_path))

        puts "New jekyll site installed in #{install_path}."
      end

      # Internal: Processes the sample post template
      #
      # Returns the processed ERB post template file content as a String
      def self.scaffold_post_content(template_site)
        ERB.new(File.read(File.expand_path(sample_post_path, template_site))).result
      end

      # Internal: Filename of the sample post to be created
      #
      # Returns the filename of the sample post as a String
      def self.initialized_post_name
        "_posts/#{Time.now.strftime('%Y-%m-%d')}-welcome-to-jekyll.markdown"
      end

      # Internal: Path of the file containing the sample post template
      #
      # Returns the filename of the sample post template as a String
      def self.sample_post_path
        "_posts/0000-00-00-sample_post.markdown.erb"
      end
    end
  end
end
