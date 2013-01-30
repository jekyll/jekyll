require 'rubygems'
require 'jekyll'
require 'fileutils'
require 'net/http'
require 'uri'
require "json"

# ruby -r './lib/jekyll/migrators/posterous.rb' -e 'Jekyll::Posterous.process(email, pass, api_key, blog)'

module Jekyll
  module Posterous
    def self.fetch(uri_str, limit = 10)
      # You should choose better exception.
      raise ArgumentError, 'Stuck in a redirect loop. Please double check your email and password' if limit == 0

      response = nil
      Net::HTTP.start('posterous.com') do |http|
        req = Net::HTTP::Get.new(uri_str)
        req.basic_auth @email, @pass
        response = http.request(req)
      end

      case response
        when Net::HTTPSuccess     then response
        when Net::HTTPRedirection then fetch(response['location'], limit - 1)
        else response.error!
      end
    end

    def self.fetch_images(directory, imgs)
      def self.fetch_one(url, limit = 10)
        raise ArgumentError, 'HTTP redirect too deep' if limit == 0
        response = Net::HTTP.get_response(URI.parse(url))
        case response
        when Net::HTTPSuccess     then response.body
        when Net::HTTPRedirection then self.fetch_one(response['location'], limit - 1)
        else
          response.error!
        end
      end

      FileUtils.mkdir_p directory
      urls = Array.new
      imgs.each do |img|
        fullurl = img["full"]["url"]
        uri = URI.parse(fullurl)
        imgname = uri.path.split("/")[-1]
        imgdata = self.fetch_one(fullurl)
        open(directory + "/" + imgname, "wb") do |file|
          file.write imgdata
        end
        urls.push(directory + "/" + imgname)
      end

      return urls
    end

    def self.process(email, pass, api_token, blog = 'primary', base_path = '/')
      @email, @pass, @api_token = email, pass, api_token
      FileUtils.mkdir_p "_posts"

      posts = JSON.parse(self.fetch("/api/v2/users/me/sites/#{blog}/posts?api_token=#{@api_token}").body)
      page = 1

      while posts.any?
        posts.each do |post|
          title = post["title"]
          slug = title.gsub(/[^[:alnum:]]+/, '-').downcase
          date = Date.parse(post["display_date"])
          content = post["body_html"]
          published = !post["is_private"]
          basename = "%02d-%02d-%02d-%s" % [date.year, date.month, date.day, slug]
          name = basename + '.html'

          # Images:
          post_imgs = post["media"]["images"]
          if post_imgs.any?
            img_dir = "imgs/%s" % basename
            img_urls = self.fetch_images(img_dir, post_imgs)

            img_urls.map! do |url|
              '<li><img src="' + base_path + url + '"></li>'
            end
            imgcontent = "<ol>\n" + img_urls.join("\n") + "</ol>\n"

            # filter out "posterous-content", replacing with imgs:
            content = content.sub(/\<p\>\[\[posterous-content:[^\]]+\]\]\<\/\p\>/, imgcontent)
          end

          # Get the relevant fields as a hash, delete empty fields and convert
          # to YAML for the header
          data = {
             'layout' => 'post',
             'title' => title.to_s,
             'published' => published
           }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

          # Write out the data and content to file
          File.open("_posts/#{name}", "w") do |f|
            f.puts data
            f.puts "---"
            f.puts content
          end
        end

        page += 1
        posts = JSON.parse(self.fetch("/api/v2/users/me/sites/#{blog}/posts?api_token=#{@api_token}&page=#{page}").body)
      end
    end
  end
end
