begin
  require 'sequel'
rescue LoadError
  puts 'Sequel gem is not installed. Please do `[sudo] gem install sequel`'
  exit(1)
end

module Jekyll
  module Importers
    class Joomla < Importer
      def self.help
        <<-EOS
        Jekyll Joomla Importer

        Basic Command Line Usage:

            jekyll import joomla <options>

        Configuration options:

            --dbname [TEXT]              DB to import from
            --user [TEXT]                Username to use when importing
            --pass [TEXT]                Password to use when importing
            --host [HOST ADDRESS]        Host to import from
            --table-prefix [PREFIX]      Table prefix to use when importing
            --section [SECTION]          Section to use when importing
        EOS
      end

      def self.validate(options)
        errors = []
        errors << "--dbname is required"       if options[:dbname].nil?
        errors << "--user is required"         if options[:user].nil?
        errors << "--password is required"     if options[:password].nil?
        errors << "--host is required"         if options[:host].nil?
        errors << "--table-prefix is required" if options[:table_prefix].nil?
        errors << "--section is required"      if options[:section].nil?
        errors
      end

      def self.process(options)
        query = "SELECT `title`,
                        `alias`,
                        CONCAT(`introtext`,`fulltext`) as content,
                        `created`,
                        `id`
                 FROM #{options[:table_prefix]}content
                 WHERE state = '0'
                 OR state = '1' AND sectionid = '#{options[:section]}'"

        db = Sequel.mysql(options[:dbname],
                             :user     => options[:user],
                             :password => options[:password],
                             :host     => options[:host],
                             :encoding => 'utf8')

        posts = []

        db[QUERY].each do |post|
          title = post[:title]
          slug = post[:alias]
          date = post[:created]
          content = post[:content]
          name = "%02d-%02d-%02d-%s.markdown" % [date.year, date.month, date.day, slug]

          posts << {
            :name   => name,
            :body   => content, 
            :header => {
              :layout     => 'post',
              :title      => title,
              :joomla_id  => post[:id],
              :joomla_url => post[:alias]
            }
          }
        end

        { :posts => posts }
      end
    end
  end
end
