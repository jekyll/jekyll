require 'rubygems'
require 'open-uri'
require 'fileutils'
require 'nokogiri'
require 'date'
require 'json'
require 'uri'
require 'jekyll'

module Jekyll
  module Tumblr
    def self.process(url, format = "html", grab_images = false,
                     add_highlights = false, rewrite_urls = true)
      @grab_images = grab_images
      FileUtils.mkdir_p "_posts/tumblr"
      url += "/api/read/json/"
      per_page = 50
      posts = []
      # Two passes are required so that we can rewrite URLs.
      # First pass builds up an array of each post as a hash.
      begin
        current_page = (current_page || -1) + 1
        feed = open(url + "?num=#{per_page}&start=#{current_page * per_page}")
        json = feed.readlines.join("\n")[21...-2]  # Strip Tumblr's JSONP chars.
        blog = JSON.parse(json)
        puts "Page: #{current_page + 1} - Posts: #{blog["posts"].size}"
        posts += blog["posts"].map { |post| post_to_hash(post, format) }
      end until blog["posts"].size < per_page
      # Rewrite URLs and create redirects.
      posts = rewrite_urls_and_redirects posts if rewrite_urls
      # Second pass for writing post files.
      posts.each do |post|
        if format == "md"
          post[:content] = html_to_markdown post[:content]
          post[:content] = add_syntax_highlights post[:content] if add_highlights
        end
        File.open("_posts/tumblr/#{post[:name]}", "w") do |f|
          f.puts post[:header].to_yaml + "---\n" + post[:content]
        end
      end
    end

    private

    # Converts each type of Tumblr post to a hash with all required
    # data for Jekyll.
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
          "layout" => "post",
          "title" => title,
          "tags" => post["tags"],
        },
        :content => content,
        :url => post["url"],
        :slug => post["url-with-slug"],
      }
    end

    # Create a Hash of old urls => new urls, for rewriting and
    # redirects, and replace urls in each post. Instantiate Jekyll
    # site/posts to get the correct permalink format.
    def self.rewrite_urls_and_redirects(posts)
      site = Jekyll::Site.new(Jekyll.configuration({}))
      dir = File.join(File.dirname(__FILE__), "..")
      urls = Hash[posts.map { |post|
        # Create an initial empty file for the post so that
        # we can instantiate a post object.
        File.open("_posts/tumblr/#{post[:name]}", "w")
        tumblr_url = URI.parse(post[:slug]).path
        jekyll_url = Jekyll::Post.new(site, dir, "", "tumblr/" + post[:name]).url
        redirect_dir = tumblr_url.sub(/\//, "") + "/"
        FileUtils.mkdir_p redirect_dir
        File.open(redirect_dir + "index.html", "w") do |f|
          f.puts "<html><head><meta http-equiv='Refresh' content='0; " +
                 "url=#{jekyll_url}'></head><body></body></html>"
        end
        [tumblr_url, jekyll_url]
      }]
      posts.map { |post|
        urls.each do |tumblr_url, jekyll_url|
          post[:content].gsub!(/#{tumblr_url}/i, jekyll_url)
        end
        post
      }
    end

    # Uses Python's html2text to convert a post's content to
    # markdown. Preserve HTML tables as per the markdown docs.
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

    # Adds pygments highlight tags to code blocks in posts that use
    # markdown format. This doesn't guess the language of the code
    # block, so you should modify this to suit your own content.
    # For example, my code block only contain Python and JavaScript,
    # so I can assume the block is JavaScript if it contains a
    # semi-colon.
    def self.add_syntax_highlights(content)
      lines = content.split("\n")
      block, indent, lang, start = false, /^    /, nil, nil
      lines.each_with_index do |line, i|
        if !block && line =~ indent
          block = true
          lang = "python"
          start = i
        elsif block
          lang = "javascript" if line =~ /;$/
          block = line =~ indent && i < lines.size - 1 # Also handle EOF
          if !block
            lines[start] = "{% highlight #{lang} %}"
            lines[i - 1] = "{% endhighlight %}"
          end
          lines[i] = lines[i].sub(indent, "")
        end
      end
      lines.join("\n")
    end

    def self.save_file(url, ext)
      if @grab_images
        path = "tumblr_files/#{url.split('/').last}"
        path += ext unless path =~ /#{ext}$/
        FileUtils.mkdir_p "tumblr_files"
        File.open(path, "w") { |f| f.write(open(url).read) }
        url = "/" + path
      end
      url
    end
  end
end
