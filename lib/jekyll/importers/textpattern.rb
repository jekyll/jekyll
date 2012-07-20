begin
  require 'sequel'
rescue LoadError
  puts 'Sequel gem is not installed. Please do `[sudo] gem install sequel`'
  exit(1)
end

module Jekyll
  module Importers
    class TextPattern < Importer
      QUERY = "SELECT Title, \
                      url_title, \
                      Posted, \
                      Body, \
                      Keywords \
               FROM textpattern \
               WHERE Status = '4' OR \
                     Status = '5'"

      def self.help
        <<-EOS
        Jekyll TextPattern Importer

        Basic Command Line Usage:

            jekyll import textpattern <options>

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
          title = post[:Title]
          slug = post[:url_title]
          date = post[:Posted]
          content = post[:Body]

          name = [date.strftime("%Y-%m-%d"), slug].join('-') + ".textile"

          posts << {
            :name   => name,
            :body   => content, 
            :header => {
              :layout => 'post',
              :title  => title,
              :tags   => post[:Keywords].split(',')
            }
          }
        end

        { :posts => posts }
      end
    end
  end
end
