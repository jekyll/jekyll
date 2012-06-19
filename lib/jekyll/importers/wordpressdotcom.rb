begin
  require 'hpricot'
rescue LoadError
  puts 'Hpricot gem is not installed. Please do `[sudo] gem install hpricot`'
  exit(1)
end

module Jekyll
  module Importers
    class WordPressDotCom < Importer
      def self.help
        <<-EOS
        Jekyll WordPress.com Importer

        Basic Command Line Usage:

            jekyll import wordpressdotcom <options>

        Configuration options:

            --file [PATH]              Path to the exported wordpress.xml file
        EOS
      end

      def self.validate(options)
        errors = []
        errors << "--file is required"   if options[:file].nil?
        errors
      end

      def self.process(options)
        files = {}

        (doc/:channel/:item).each do |item|
          title           = item.at(:title).inner_text.strip
          permalink_title = item.at('wp:post_name').inner_text

          if permalink_title == ""
            permalink_title = title.gsub(/[^[:alnum:]]+/, '-').downcase
          end

          date   = Time.parse(item.at('wp:post_date').inner_text)
          status = item.at('wp:status').inner_text

          if status == "publish" 
            published = true
          else
            published = false
          end

          type = item.at('wp:post_type').inner_text
          tags = (item/:category).map{|c| c.inner_text}.reject{|c| c == 'Uncategorized'}.uniq

          metas = Hash.new
          item.search("wp:postmeta").each do |meta|
            key        = meta.at('wp:meta_key').inner_text
            value      = meta.at('wp:meta_value').inner_text
            metas[key] = value;
          end

          name = "#{date.strftime('%Y-%m-%d')}-#{permalink_title}.html"

          header = {
            'layout'    => type,
            'title'     => title,
            'tags'      => tags,
            'status'    => status,
            'type'      => type,
            'published' => published,
            'meta'      => metas
          }

          FileUtils.mkdir_p "_#{type}s"
          File.open("_#{type}s/#{name}", "w") do |f|
            f.puts header.to_yaml
            f.puts '---'
            f.puts item.at('content:encoded').inner_text
          end

          hash = {
            :name   => name,
            :body   => item.at('content:encoded').inner_text,
            :header => {
              :layout    => type,
              :title     => title,
              :tags      => tags,
              :status    => status,
              :type      => type,
              :published => published,
              :meta      => metas
            }
          }

          files[type.to_sym] ||= []
          files[type.to_sym] << hash
        end

        files
      end
    end
  end
end
