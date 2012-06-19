begin
  require 'sequel'
rescue LoadError
  puts 'Sequel gem is not installed. Please do `[sudo] gem install sequel`'
  exit(1)
end

module Jekyll
  module Importers
    class Mephisto < Importer
      QUERY = "SELECT id, \
                      permalink, \
                      body, \
                      published_at, \
                      title \
               FROM contents \
               WHERE user_id = 1 AND \
                     type = 'Article' AND \
                     published_at IS NOT NULL \
               ORDER BY published_at"

      def self.help
        <<-EOS
        Jekyll Mephisto Importer

        Basic Command Line Usage:

            jekyll import mephisto <options>

        Configuration options:

            --dbname [TEXT]              DB to import from
            --user [TEXT]                Username to use when importing
            --pass [TEXT]                Password to use when importing
            --host [HOST ADDRESS]        Host to import from
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

        posts = []

        db[QUERY].each do |post|
          title = post[:title]
          slug = post[:permalink]
          date = post[:published_at]
          content = post[:body]

          # Ideally, this script would determine the post format (markdown,
          # html, etc) and create files with proper extensions. At this point
          # it just assumes that markdown will be acceptable.
          name = [date.year, date.month, date.day, slug].join('-') + ".md"

          posts << {
            :name   => name,
            :body   => content, 
            :header => {
              :layout => 'post',
              :title  => title,
            }
          }
        end

        { :posts => posts }
      end
    end
  end
end
