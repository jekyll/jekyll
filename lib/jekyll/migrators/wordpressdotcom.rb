# coding: utf-8

require 'rubygems'
require 'hpricot'
require 'fileutils'
require 'yaml'
require 'time'

module Jekyll
  # This importer takes a wordpress.xml file, which can be exported from your
  # wordpress.com blog (/wp-admin/export.php).
  module WordpressDotCom
    def self.process(filename = "wordpress.xml")
      import_count = Hash.new(0)
      doc = Hpricot::XML(File.read(filename))

      (doc/:channel/:item).each do |item|
        title = item.at(:title).inner_text.strip
        permalink_title = item.at('wp:post_name').inner_text
        # Fallback to "prettified" title if post_name is empty (can happen)
        if permalink_title == ""
          permalink_title = title.downcase.split.join('-')
        end

        date = Time.parse(item.at('wp:post_date').inner_text)
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
          key = meta.at('wp:meta_key').inner_text
          value = meta.at('wp:meta_value').inner_text
          metas[key] = value;
        end

        name = "#{date.strftime('%Y-%m-%d')}-#{permalink_title}.html"
        header = {
          'layout' => type,
          'title'  => title,
          'tags'   => tags,
          'status'   => status,
          'type'   => type,
          'published' => published,
          'meta'   => metas
        }

        FileUtils.mkdir_p "_#{type}s"
        File.open("_#{type}s/#{name}", "w") do |f|
          f.puts header.to_yaml
          f.puts '---'
          f.puts item.at('content:encoded').inner_text
        end

        import_count[type] += 1
      end

      import_count.each do |key, value|
        puts "Imported #{value} #{key}s"
      end
    end
  end
end
