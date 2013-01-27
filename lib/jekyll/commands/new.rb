require 'yaml'

module Jekyll
  module Commands
    class New < Command
    
      def self.process(args)
        path = File.expand_path(args.join(" "), Dir.pwd)
        template_site = File.expand_path("../../site_template", File.dirname(__FILE__))
        FileUtils.mkdir_p path
        FileUtils.cp_r Dir["#{template_site}/*"], path
        File.open(File.expand_path(self.initialized_post_name, path), "w") do |f|
          content = [
            { "layout" => "post", "title" => "Welcome to Jekyll!", "date" => Time.now.strftime('%Y-%m-%d %H:%M:%S'), "categories" => %w(jekyll update) }.to_yaml + "---",
            "You'll find this post in your `_posts` directory - edit this post and re-build (or run with the `-w` switch) to see your changes!",
            "To add new posts, simply add a file in the `_posts` directory that follows the convention: YYYY-MM-DD-name-of-post.ext.",
            "Check out the [Jeyll docs][jekyll] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll's GitHub repo][jekyll-gh].",
            "[jekyll-gh]: https://github.com/mojombo/github\n[jekyll]:    http://jekyllrb.com"
          ]
          f.write(content.join("#{$/*2}"))
        end
        puts "New jekyll site installed in #{path}."
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
