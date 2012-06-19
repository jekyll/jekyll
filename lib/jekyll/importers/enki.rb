begin
  require 'sequel'
rescue LoadError
  puts 'Sequel gem is not installed. Please do `[sudo] gem install sequel`'
  exit(1)
end

module Jekyll
  module Importers
    class Enki < Importer
      QUERY = "SELECT p.id,
                      p.title,
                      p.slug,
                      p.body,
                      p.published_at as date,
                      p.cached_tag_list as tags
               FROM posts p"

      def self.help
        <<-EOS
        Jekyll Enki Importer

        Basic Command Line Usage:

            jekyll import enki <options>

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
        db = Sequel.postgres(:database => options[:dbname],
                             :user     => options[:user],
                             :password => options[:password],
                             :host     => options[:host],
                             :encoding => 'utf8')

        posts = []

        db[QUERY].each do |post|
          name = [ sprintf("%.04d", post[:date].year),
                   sprintf("%.02d", post[:date].month),
                   sprintf("%.02d", post[:date].day),
                   post[:slug].strip
          ].join('-')

          name += '.textile'

          posts << {
            :name   => name,
            :body   => post[:body].delete("\r"),
            :header => {
              :layout     => 'post',
              :title      => post[:title].to_s,
              :mt_id      => post[:entry_id],
              :enki_id    => post[:id],
              :categories => post[:tags]
            }
          }
        end

        { :posts => posts }
      end

      def self.suffix(entry_type)
        if entry_type.nil? || entry_type.include?("markdown")
          # The markdown plugin I have saves this as
          # "markdown_with_smarty_pants", so I just look for "markdown".
          "markdown"
        elsif entry_type.include?("textile")
          # This is saved as "textile_2" on my installation of MT 5.1.
          "textile"
        elsif entry_type == "0" || entry_type.include?("richtext")
          # Richtext looks to me like it's saved as HTML, so I include it here.
          "html"
        else
          # Other values might need custom work.
          entry_type
        end
      end
    end
  end
end
