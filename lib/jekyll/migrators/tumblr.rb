require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'cgi'
require 'iconv'
require 'date'

module Jekyll
  module Tumblr
    def self.process(url, grab_images = false, format = "html")
      current_page = 0

      while true
        f = open(url + "/api/read?num=50&start=#{current_page * 50}")
        doc = Nokogiri::HTML(Iconv.conv("utf-8", f.charset, f.readlines.join("\n")))

        puts "Page: #{current_page + 1} - Posts: #{(doc/:tumblr/:posts/:post).size}"

        FileUtils.mkdir_p "_posts/tumblr"

        (doc/:tumblr/:posts/:post).each do |post|
          title = ""
          content = nil
          name = nil

          if post['type'] == "regular"
            title_element = post.at("regular-title")
            title = title_element.inner_text unless title_element == nil
            content = CGI::unescapeHTML post.at("regular-body").inner_html unless post.at("regular-body") == nil
          elsif post['type'] == "link"
            title = post.at("link-text").inner_html unless post.at("link-text") == nil

            if post.at("link-text") != nil
              content = "<a href=\"#{post.at("link-url").inner_html}\">#{post.at("link-text").inner_html}</a>"
            else
              content = "<a href=\"#{post.at("link-url").inner_html}\">#{post.at("link-url").inner_html}</a>"
            end

            content << "<br/>" + CGI::unescapeHTML(post.at("link-description").inner_html) unless post.at("link-description") == nil
          elsif post['type'] == "photo"
            content = ""

            if post.at("photo-link-url") != nil
              content = "<a href=\"#{post.at("photo-link-url").inner_html}\"><img src=\"#{save_file((post/"photo-url")[1].inner_html, grab_images)}\"/></a>"
            else
              content = "<img src=\"#{save_file((post/"photo-url")[1].inner_html, grab_images)}\"/>"
            end

            if post.at("photo-caption") != nil
              content << "<br/>" unless content == nil
              content << CGI::unescapeHTML(post.at("photo-caption").inner_html)
            end
          elsif post['type'] == "audio"
            content = CGI::unescapeHTML(post.at("audio-player").inner_html)
            content << CGI::unescapeHTML(post.at("audio-caption").inner_html) unless post.at("audio-caption") == nil
          elsif post['type'] == "quote"
            content = "<blockquote>" + CGI::unescapeHTML(post.at("quote-text").inner_html) + "</blockquote>"
            content << "&#8212;" + CGI::unescapeHTML(post.at("quote-source").inner_html) unless post.at("quote-source") == nil
          elsif post['type'] == "conversation"
            title = post.at("conversation-title").inner_html unless post.at("conversation-title") == nil
            content = "<section><dialog>"

            (post/:conversation/:line).each do |line|
              content << "<dt>" + line['label'] + "</dt><dd>" + line.inner_html + "</dd>" unless line['label'] == nil || line == nil
            end

            content << "</section></dialog>"
          elsif post['type'] == "video"
            title = post.at("video-title").inner_html unless post.at("video-title") == nil
            content = CGI::unescapeHTML(post.at("video-player").inner_html)
            content << CGI::unescapeHTML(post.at("video-caption").inner_html) unless post.at("video-caption") == nil
          end # End post types

          name = "#{Date.parse(post['date']).to_s}-#{title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')}.#{format}"

          if title != nil || content != nil && name != nil
            content = %x[echo '#{content.gsub("'", "''")}' | html2text] if format == "md"
            File.open("_posts/tumblr/#{name}", "w") do |f|

              f.puts <<-HEADER
---
layout: post
title: "#{title.gsub('"', '\"')}"
---

HEADER

              f.puts content
            end # End file
          end

        end # End post XML

        if (doc/:tumblr/:posts/:post).size < 50
          break
        else
          current_page = current_page + 1
        end

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
