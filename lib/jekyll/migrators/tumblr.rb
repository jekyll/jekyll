require 'rubygems'
require 'open-uri'
require 'fileutils'
require 'date'
require 'json'

module Jekyll
  module Tumblr
    def self.process(url, grab_images = false, format = "html")
      current_page = 0

      while true

        f = open(url + "/api/read/json/?num=50&start=#{current_page * 50}")
        # [21...-2] strips Tumblr's Javascript/JSONP start/end chars
        json = f.readlines.join("\n")[21...-2]
        blog = JSON.parse(json)
        puts "Page: #{current_page + 1} - Posts: #{blog["posts"].size}"
        FileUtils.mkdir_p "_posts/tumblr"

        blog["posts"].each do |post|

          case post['type']
            when "regular"
              title = post["regular-title"]
              content = post["regular-body"]
            when "link"
              title = post["link-text"] || post["link-url"]
              content = "<a href=\"#{post["link-url"]}\">#{title}</a>"
              content << "<br/>" + post["link-description"] unless post["link-description"].nil?
            when "photo"
              title = post["photo-caption"]
              content = "<img src=\"#{save_file(post["photo-url"], grab_images)}\"/>"
              content = "<a href=\"#{post["photo-link-url"]}\">#{content}</a>" unless post["photo-link-url"].nil?
            when "audio"
              if !post["id3-title"].nil?
                title = post["id3-title"]
                content = post.at["audio-player"] + "<br/>" + post["audio-caption"]
              else
                title = post["audio-caption"]
                content = post.at["audio-player"]
              end
            when "quote"
              title = post["quote-text"]
              content = "<blockquote>#{post["quote-text"]}</blockquote>"
              content << "&#8212;" + post["quote-source"] unless post["quote-source"].nil?
            when "conversation"
              title = post["conversation-title"]
              content = "<section><dialog>"
              post["conversation"]["line"].each do |line|
                content << "<dt>#{line['label']}</dt><dd>#{line}</dd>"
              end
              content << "</section></dialog>"
            when "video"
              title = post["video-title"]
              content = post["video-player"]
              content << "<br/>" + post["video-caption"] unless post["video-caption"].nil?
          end # End post types

          name = "#{Date.parse(post['date']).to_s}-#{title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')}.#{format}"

          File.open("_posts/tumblr/#{name}", "w") do |f|
            if format == "md"
                preserve = ["table", "tr", "th", "td"]
                preserve.each { |tag| content = content.gsub(/<#{tag}/i, "$$" + tag).gsub(/<\/#{tag}/i, "||" + tag) }
                content = %x[echo '#{content.gsub("'", "''")}' | html2text]
                preserve.each { |tag| content = content.gsub("$$" + tag, "<" + tag).gsub("||" + tag, "</" + tag) }
            end
            header = {"layout" => "post", "title" => title, "tags" => post["tags"]}
            f.puts header.to_yaml + "---\n" + content
          end # End file

        end # End post XML

        if blog["posts"].size < 50
          break
        end
        current_page += 1

      end # End while loop
    end # End method

    private

    def self.save_file(url, grab_image = false)
      unless grab_image == false
        FileUtils.mkdir_p "tumblr_files"

        File.open("tumblr_files/#{url.split('/').last}", "w") do |f|
          f.write(open(url).read)
        end

        return "/tumblr_files/#{url.split('/').last}"
      else
        return url
      end
    end
  end
end
