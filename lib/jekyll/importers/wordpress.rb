begin
  require 'sequel'
rescue LoadError
  puts 'Sequel gem is not installed. Please do `[sudo] gem install sequel`'
  exit(1)
end

module Jekyll
  module Importers
    class WordPress < Importer
      def self.help
        <<-EOS
        Jekyll WordPress Importer

        Basic Command Line Usage:

            jekyll import wordpress <options>

        Configuration options:

            --dbname [TEXT]              DB to import from
            --user [TEXT]                Username to use when importing
            --pass [TEXT]                Password to use when importing
            --host [HOST ADDRESS]        Host to import from
            --table-prefix [PREFIX]      Table prefix to use when importing
        EOS
      end

      def self.validate(options)
        errors = []
        errors << "--dbname is required"   if options[:dbname].nil?
        errors << "--user is required"     if options[:user].nil?
        errors << "--password is required" if options[:password].nil?
        errors << "--host is required"     if options[:host].nil?
        errors
      end

      def self.process(options)
        db = Sequel.mysql(options[:dbname],
                          :user     => options[:user],
                          :password => options[:password],
                          :host     => options[:host],
                          :encoding => 'utf8')

        px = options[:table_prefix] || 'wp_'

        posts_query = "SELECT posts.ID            AS `id`,
                              posts.guid          AS `guid`,
                              posts.post_type     AS `type`,
                              posts.post_status   AS `status`,
                              posts.post_title    AS `title`,
                              posts.post_name     AS `slug`,
                              posts.post_date     AS `date`,
                              posts.post_content  AS `content`,
                              posts.post_excerpt  AS `excerpt`,
                              posts.comment_count AS `comment_count`,
                              users.display_name  AS `author`,
                              users.user_login    AS `author_login`,
                              users.user_email    AS `author_email`,
                              users.user_url      AS `author_url`
                       FROM #{px}posts AS `posts`
                       LEFT JOIN #{px}users AS `users`
                       ON posts.post_author = users.ID"

        posts = []

        db[posts_query].each do |post|
          title   = post[:title]
          slug    = post[:slug] || title.gsub(/[^[:alnum:]]+/, '-').downcase
          date    = post[:date] || Time.now
          name    = "%02d-%02d-%02d-%s.md" % [date.year, date.month, date.day, slug]
          content = post[:content].to_s

          posts << {
            :name   => name,
            :body   => content,
            :header => {
              :layout => 'post',
              :title  => title
            }
          }
          
        end

        { :posts => posts }
      end
    end
  end
end
