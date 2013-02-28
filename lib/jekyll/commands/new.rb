require 'erb'

module Jekyll
  module Commands
    class New < Command
    
      def self.process(args)
        path = File.expand_path(args.join(" "), Dir.pwd)
        template_site = File.expand_path("../../site_template", File.dirname(__FILE__))
        FileUtils.mkdir_p path
        sample_files = Dir["#{template_site}/**/*"].reject {|f| File.extname(f) == ".erb"}
        FileUtils.cp_r sample_files, path
        File.open(File.expand_path(self.initialized_post_name, path), "w") do |f|
          f.write(self.scaffold_post_content(template_site))
        end
        puts "New jekyll site installed in #{path}."
      end

      def self.scaffold_post_content(template_site)
        ERB.new(File.read(File.expand_path("_posts/0000-00-00-sample_post.markdown.erb", template_site))).result
      end

      # Internal: Gets the filename of the sample post to be created
      #
      # Returns the filename of the sample post, as a String
      def self.initialized_post_name
        "_posts/#{Time.now.strftime('%Y-%m-%d')}-welcome-to-jekyll.markdown"
      end
    end
  end
end
