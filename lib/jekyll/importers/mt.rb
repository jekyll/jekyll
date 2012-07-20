begin
  require 'sequel'
rescue LoadError
  puts 'Sequel gem is not installed. Please do `[sudo] gem install sequel`'
  exit(1)
end

module Jekyll
  module Importers
    class MT < Importer
      QUERY = "SELECT entry_id, \
                      entry_basename, \
                      entry_text, \
                      entry_text_more, \
                      entry_authored_on, \
                      entry_title, \
                      entry_convert_breaks \
               FROM mt_entry"

      def self.help
        <<-EOS
        Jekyll MT Importer

        Basic Command Line Usage:

            jekyll import mt <options>

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
          title = post[:entry_title]
          slug = post[:entry_basename].gsub(/_/, '-')
          date = post[:entry_authored_on]
          content = post[:entry_text]
          more_content = post[:entry_text_more]
          entry_convert_breaks = post[:entry_convert_breaks]

          content = content + " \n" + more_content unless more_content.nil?

          name = [date.year, date.month, date.day, slug].join('-') + '.' + self.suffix(entry_convert_breaks)

          posts << {
            :name   => name,
            :body   => content,
            :header => {
              :layout => 'post',
              :title  => title,
              :mt_id  => post[:entry_id],
              :date   => date
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
