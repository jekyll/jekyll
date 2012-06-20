begin
  require 'open-uri'
  require 'nokogiri'
  require 'json'
  require 'uri'
rescue LoadError
  puts 'Nokogiri gem is not installed. Please do `[sudo] gem install nokogiri`'
  exit(1)
end

module Jekyll
  module Importers
    class Tumblr < Importer
      def self.help
        <<-EOS
        Jekyll Tumblr Importer

        Basic Command Line Usage:

            jekyll import tumblr <options>

        Configuration options:

            --source [PATH]                Source to import from can be a URL or file path
        EOS
      end

      def self.validate(options)
        errors = []
        errors << "--source is required" if options[:source].nil?
        errors
      end

      def self.process(options)
        url      = options[:source] + '/api/read/json'
        per_page = 50
        posts    = []

        posts       = []
        posts_local = []

        begin
          current_page = (current_page || -1) + 1
          feed = open(url + "?num=#{per_page}&start=#{current_page * per_page}")
          json = feed.readlines.join("\n")[21...-2]  # Strip Tumblr's JSONP chars.
          blog = JSON.parse(json)
          posts += blog["posts"].map { |post| post_to_hash(post, 'html') }
        end until blog["posts"].size < per_page

        { :posts => posts }
      end

      def self.post_to_hash(post, format)
        case post['type']
        when "regular"
          title = post["regular-title"]
          content = post["regular-body"]
        when "link"
          title = post["link-text"] || post["link-url"]
          content = "<a href=\"#{post["link-url"]}\">#{title}</a>"
          unless post["link-description"].nil?
            content << "<br/>" + post["link-description"]
          end
        when "photo"
          title = post["photo-caption"]
          max_size = post.keys.map{ |k| k.gsub("photo-url-", "").to_i }.max
          url = post["photo-url"] || post["photo-url-#{max_size}"]
          ext = "." + post[post.keys.select { |k|
            k =~ /^photo-url-/ && post[k].split("/").last =~ /\./
          }.first].split(".").last
          content = "<img src=\"#{save_file(url, ext)}\"/>"
          unless post["photo-link-url"].nil?
            content = "<a href=\"#{post["photo-link-url"]}\">#{content}</a>"
          end
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
          unless post["quote-source"].nil?
            content << "&#8212;" + post["quote-source"]
          end
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
          unless post["video-caption"].nil?
            content << "<br/>" + post["video-caption"]
          end
        end
        date = Date.parse(post['date']).to_s
        title = Nokogiri::HTML(title).text
        slug = title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

        {
          :name => "#{date}-#{slug}.#{format}",
          :header => {
            :layout => "post",
            :title  => title,
            :tags   => post["tags"],
          },
          :body => content
        }
      end

      def self.html_to_markdown(content)
        preserve = ["table", "tr", "th", "td"]
        preserve.each do |tag|
          content.gsub!(/<#{tag}/i, "$$" + tag)
          content.gsub!(/<\/#{tag}/i, "||" + tag)
        end
        content = %x[echo '#{content.gsub("'", "''")}' | html2text]
        preserve.each do |tag|
          content.gsub!("$$" + tag, "<" + tag)
          content.gsub!("||" + tag, "</" + tag)
        end
        content
      end
    end
  end
end
