begin
  require 'sequel'
rescue LoadError
  puts 'Sequel gem is not installed. Please do `[sudo] gem install sequel`'
  exit(1)
end

module Jekyll
  module Importers
    class Typo < Importer
      QUERY = "SELECT c.id id,
                      c.title title,
                      c.permalink slug,
                      c.body body,
                      c.published_at date,
                      c.state state,
                      COALESCE(tf.name, 'html') filter
               FROM contents c
               LEFT OUTER JOIN text_filters tf ON c.text_filter_id = tf.id"

      def self.help
        <<-EOS
        Jekyll Typo Importer

        Basic Command Line Usage:

            jekyll import typo <options>

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
          next unless post[:state] =~ /published/

          name = [ sprintf("%.04d", post[:date].year),
                   sprintf("%.02d", post[:date].month),
                   sprintf("%.02d", post[:date].day),
                   post[:slug].strip
          ].join('-')

          name += '.' + post[:filter].split(' ')[0]

          posts << {
            :name   => name,
            :body   => post[:body].delete("\r"),
            :header => {
              :layout  => 'post',
              :title   => post[:title].to_s,
              :typo_id => post[:id],
            }
          }
        end

        { :posts => posts }
      end
    end
  end
end
