require 'rubygems'
require 'jekyll'
require 'fileutils'
require 'net/https'
require 'open-uri'
require 'uri'
require "json"

# ruby -r './lib/jekyll/migrators/posterous.rb' -e 'Jekyll::Posterous.process(email, pass, api_token, blog, tags_key)'
# You can find your api token in posterous api page - http://posterous.com/api . Click on any of the 'view token' links to see your token.
# blog is optional, by default it is the primary one

module Jekyll
  module Posterous
    def self.fetch(uri_str, limit = 10)
      # You should choose better exception.
      raise ArgumentError, 'Stuck in a redirect loop. Please double check your email and password' if limit == 0

      response = nil

      puts uri_str
      puts '-------'
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

    def self.process(email, pass, api_token, blog = 'primary', tags_key = 'categories')
      @email, @pass , @api_token = email, pass, api_token
      FileUtils.mkdir_p "_posts"

      posts = JSON.parse(self.fetch("/api/2/sites/#{blog}/posts?api_token=#{@api_token}").body)
      page = 1

      while posts.any?
        posts.each do |post|
          title = post["title"]
          slug = title.gsub(/[^[:alnum:]]+/, '-').gsub(/^-+|-+$/, '').downcase
          posterous_slug = post["slug"]
          date = Date.parse(post["display_date"])
          content = post["body_html"]
          published = !post["is_private"]
          name = "%02d-%02d-%02d-%s.html" % [date.year, date.month, date.day, slug]
          tags = []
          post["tags"].each do |tag|
            tags.push(tag["name"])
          end

          # Get the relevant fields as a hash, delete empty fields and convert
          # to YAML for the header
          data = {
             'layout' => 'post',
             'title' => title.to_s,
             'published' => published,
             tags_key => tags,
             'posterous_url' => post["full_url"],
             'posterous_slug' => posterous_slug
           }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

          # Write out the data and content to file
          File.open("_posts/#{name}", "w") do |f|
            puts name
            f.puts data
            f.puts "---"
            f.puts content
          end
        end

        page += 1
        posts = JSON.parse(self.fetch("/api/2/sites/#{blog}/posts?api_token=#{@api_token}&page=#{page}").body)
      end
    end
  end
end
