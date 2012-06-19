begin
  require 'sequel'
rescue LoadError
  puts 'Sequel gem is not installed. Please do `[sudo] gem install sequel`'
  exit(1)
end

module Jekyll
  module Importers
    class Posterous < Importer
      def self.help
        <<-EOS
        Jekyll Posterous Importer

        Basic Command Line Usage:

            jekyll import Posterous <options>

        Configuration options:

            --user [TEXT]                Username to use when importing
            --pass [TEXT]                Password to use when importing
            --api-token [API TOKEN]      API Token to use when importing
            --blog [BLOG]                Blog to use when importing
        EOS
      end

      def self.validate(options)
        errors = []
        errors << "--user is required"      if options[:user].nil?
        errors << "--password is required"  if options[:password].nil?
        errors << "--api-token is required" if options[:api_token].nil?
        errors
      end

      def self.process(options)
        posts = []
        page  = 1
        posts_local = JSON.parse(
          self.fetch("/api/v2/users/me/sites/#{options[:blog]}/posts?api_token=#{options[:api_token]}").body
        )

        while posts_local.any?
          posts.each do |post|
            title = post["title"]
            slug = title.gsub(/[^[:alnum:]]+/, '-').downcase
            date = Date.parse(post["display_date"])
            content = post["body_html"]
            published = !post["is_private"]
            name = "%02d-%02d-%02d-%s.html" % [date.year, date.month, date.day, slug]

            posts << {
              :name   => name,
              :body   => content, 
              :header => {
                :layout    => 'post',
                :title     => title,
                :published => published
              }
            }

            page += 1
            posts_local = JSON.parse(
              self.fetch("/api/v2/users/me/sites/#{options[:blog]}/posts?api_token=#{optionsp[:api_token]}&page=#{page}").body
            )
          end
        end

        { :posts => posts }
      end

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
    end
  end
end
