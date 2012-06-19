module Jekyll
  module Importers
    class Marley < Importer
      def self.help
        <<-EOS
        Jekyll Marley Importer

        Basic Command Line Usage:

            jekyll import marley <options>

        Configuration options:

        EOS
      end

      def self.validate(options)
        errors = []
        errors << "--source is required"   if options[:source].nil?
        errors
      end

      def self.process(options)
        posts = []

        Dir["#{options[:source]}/**/*.txt"].each do |f|
          next unless File.exists?(f)

          file_content  = File.read(f)
          body          = file_content.sub( self.regexp[:title], '').sub( self.regexp[:perex], '').strip
     
          title = file_content.scan( self.regexp[:title] ).first.to_s.strip
          prerex = file_content.scan( self.regexp[:perex] ).first.to_s.strip
          published_on = DateTime.parse( post[:published_on] ) rescue File.mtime( File.dirname(f) )

          formatted_date = published_on.strftime('%Y-%m-%d')
          post_name =  File.dirname(f).split(%r{/}).last.gsub(/\A\d+-/, '')

          name = "#{formatted_date}-#{post_name}" 
          body += "\n#{prefex}\n\n" if prefex

          posts << {
            :name   => name,
            :body   => body, 
            :header => {
              :layout => 'post',
              :title  => title,
            }
          }
        end

        { :posts => posts }
      end

      def self.regexp
        {
          :id    => /^\d{0,4}-{0,1}(.*)$/,
          :title => /^#\s*(.*)\s+$/,
          :title_with_date => /^#\s*(.*)\s+\(([0-9\/]+)\)$/,
          :published_on => /.*\s+\(([0-9\/]+)\)$/,
          :perex => /^([^\#\n]+\n)$/,
          :meta  => /^\{\{\n(.*)\}\}\n$/mi # Multiline Regexp 
        }
      end
    end
  end
end
