require 'yaml'
require 'fileutils'

module Jekyll
  module Marley
    def self.regexp
      { :id    => /^\d{0,4}-{0,1}(.*)$/,
        :title => /^#\s*(.*)\s+$/,
        :title_with_date => /^#\s*(.*)\s+\(([0-9\/]+)\)$/,
        :published_on => /.*\s+\(([0-9\/]+)\)$/,
        :perex => /^([^\#\n]+\n)$/,
        :meta  => /^\{\{\n(.*)\}\}\n$/mi # Multiline Regexp 
      }
    end

    def self.process(marley_data_dir)
      raise ArgumentError, "marley dir #{marley_data_dir} not found" unless File.directory?(marley_data_dir)

      FileUtils.mkdir_p "_posts"

      posts = 0
      Dir["#{marley_data_dir}/**/*.txt"].each do |f|
        next unless File.exists?(f)

        #copied over from marley's app/lib/post.rb
        file_content  = File.read(f)
        meta_content  = file_content.slice!( self.regexp[:meta] )
        body          = file_content.sub( self.regexp[:title], '').sub( self.regexp[:perex], '').strip
   
        title = file_content.scan( self.regexp[:title] ).first.to_s.strip
        prerex = file_content.scan( self.regexp[:perex] ).first.to_s.strip
        published_on = DateTime.parse( post[:published_on] ) rescue File.mtime( File.dirname(f) )
        meta          = ( meta_content ) ? YAML::load( meta_content.scan( self.regexp[:meta]).to_s ) : {}
        meta['title'] = title
        meta['layout'] = 'post'

        formatted_date = published_on.strftime('%Y-%m-%d')
        post_name =  File.dirname(f).split(%r{/}).last.gsub(/\A\d+-/, '')

        name = "#{formatted_date}-#{post_name}" 
        File.open("_posts/#{name}.markdown", "w") do |f|
          f.puts meta.to_yaml
          f.puts "---\n"
          f.puts "\n#{prerex}\n\n" if prerex
          f.puts body
        end
        posts += 1
      end
      "Created #{posts} posts!"
    end
  end
end
