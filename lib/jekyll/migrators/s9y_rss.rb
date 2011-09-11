# Migrator to import entries from an Serendipity (S9Y) blog
#
# Entries can be exported from http://blog.example.com/rss.php?version=2.0&all=1
# 
# Usage:
# ruby -r './s9y_rss.rb' -e 'Jekyll::S9Y.process("http://blog.example.com/rss.php?version=2.0&all=1")'

require 'open-uri'
require 'rss'
require 'fileutils'
require 'yaml'

module Jekyll
  module S9Y
    def self.process(file_name)
      FileUtils.mkdir_p("_posts")

      text = ''
      open(file_name, 'r') { |line| text = line.read }
      rss = RSS::Parser.parse(text)

      rss.items.each do |item|
        post_url = item.link.match('.*(/archives/.*)')[1]
        categories = item.categories.collect { |c| c.content }
        content = item.content_encoded.strip
        name = item.link.match('.*/archives/(.*)\.html')[1] + '.markdown'

        data = {
          'layout' => 'post',
          'title' => item.title,
          'categories' => categories,
          'url' => post_url,
          's9y_link' => item.link,
          'date' => item.date,
        }.delete_if { |k,v| v.nil? || v == '' }.to_yaml

        # Write out the data and content to file
        File.open("_posts/#{name}", "w") do |f|
          f.puts data
          f.puts "---"
          f.puts content
        end
      end
    end
  end
end
