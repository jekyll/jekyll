require 'rubygems'
require 'hpricot'
require 'fileutils'
require 'date'

# This importer takes a wordpress.xml file,
# which can be exported from your 
# wordpress.com blog (/wp-admin/export.php)

module Jekyll
  module WordpressDotCom
    def self.process(filename = "wordpress.xml")
      FileUtils.mkdir_p "_posts"
      posts = 0

			doc = Hpricot::XML(File.read(filename))
			
			(doc/:channel/:item).each do |item|
				title = item.at(:title).inner_text
				name = "#{Date.parse((doc/:channel/:item).first.at(:pubDate).inner_text).strftime("%Y-%m-%d")}-#{title.downcase.gsub('[^a-z0-9]', '-')}.html"
				
				File.open("_posts/#{name}", "w") do |f|
          f.puts <<-HEADER
---
layout: post
title: #{title}
---
 
HEADER
          f.puts item.at('content:encoded').inner_text
        end

				posts += 1
			end

			"Imported #{posts} posts"
    end
  end
end