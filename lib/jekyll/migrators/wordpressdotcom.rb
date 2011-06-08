# coding: utf-8

require 'rubygems'
require 'hpricot'
require 'fileutils'
require 'time'
require 'yaml'

module Jekyll
  # This importer takes a wordpress.xml file, which can be exported from your
  # wordpress.com blog (/wp-admin/export.php).
  module WordpressDotCom
    def self.process(filename = "wordpress.xml")
      FileUtils.mkdir_p "_posts"
      posts = 0

      doc = Hpricot::XML(File.read(filename))

      (doc/:channel/:item).each do |item|
        title = item.at(:title).inner_text.strip
        permalink_title = item.at('wp:post_name').inner_text
        date = Time.parse(item.at(:pubDate).inner_text)
        tags = (item/:category).map{|c| c.inner_text}.reject{|c| c == 'Uncategorized'}.uniq
        name = "#{date.strftime('%Y-%m-%d')}-#{permalink_title}.html"
        header = {
          'layout' => 'post',
          'title'  => title,
          'tags'   => tags
        }

        File.open("_posts/#{name}", "w") do |f|
          f.puts header.to_yaml
          f.puts '---'
          f.puts item.at('content:encoded').inner_text
        end

        posts += 1
      end

      puts "Imported #{posts} posts"
    end
  end
end
