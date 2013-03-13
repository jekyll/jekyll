require 'erb'

module Jekyll
  module Commands
    class New < Command
      def self.process(args)
        raise ArgumentError.new('You must specify a path.') if args.empty?

        new_blog_path = File.expand_path(args.join(" "), Dir.pwd)
        FileUtils.mkdir_p new_blog_path

        create_sample_files! new_blog_path

        File.open(File.expand_path(self.initialized_post_name, new_blog_path), "w") do |f|
          f.write(self.scaffold_post_content(template_site))
        end
        puts "New jekyll site installed in #{new_blog_path}."
      end

      def self.scaffold_post_content(template_site)
        ERB.new(File.read(File.expand_path(scaffold_path, template_site))).result
      end

      # Internal: Gets the filename of the sample post to be created
      #
      # Returns the filename of the sample post, as a String
      def self.initialized_post_name
        "_posts/#{Time.now.strftime('%Y-%m-%d')}-welcome-to-jekyll.markdown"
      end

      private
      def self.create_sample_files!(path)
        FileUtils.cp_r sample_files, path
        FileUtils.rm File.expand_path(scaffold_path, path)
      end

      def self.sample_files
        Dir.glob("#{template_site}/**/*")
      end

      def self.template_site
        File.expand_path("../../site_template", File.dirname(__FILE__))
      end

      def self.scaffold_path
        "_posts/0000-00-00-welcome-to-jekyll.markdown.erb"
      end
    end
  end
end
