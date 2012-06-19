require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

module Jekyll
  module Importers
    class Rss < Importer
      # Public: Get the importer usage and command line options.
      #
      # Returns a String of the help message.
      def self.help
        <<-EOS
        Jekyll RSS Importer

        Basic Command Line Usage:

            jekyll import rss <options>

        Configuration options:

            --source [PATH]                Source to import from can be a URL or file path
        EOS
      end

      # Public: Validate a Hash of command line options for the importer.
      #
      # options - A Hash of options passed in from the command line.
      #
      # Returns an Array of Strings representing validation errors.
      def self.validate(options)
        errors = []
        errors << "--source is required" if options[:source].nil?
        errors
      end

      # Public: Perform the import process.
      #
      # options - A Hash of options passed in from the command line.
      #
      # Examples
      #
      #   # File Hash
      #   posts = []
      #   posts << {
      #     :title  => 'the title',
      #     :name   => 'the-file-name.md',
      #     :body   => 'the body content',
      #     :header => {
      #       :layout => 'posts',
      #       :title  => 'the title'
      #     }
      #   }
      #
      #   # Files Hash
      #   {
      #     :posts => posts
      #     # ...
      #   }
      #
      # Returns a Hash which maps types to an Array of Hashes for each file to write.
      def self.process(options)
        contents = ""
        open(options[:source]) { |s| s.read }
        rss = RSS::Parser.parse(content, false)

        raise "There doesn't appear to be any RSS items at the source (#{source}) provided." unless rss

        posts = []

        rss.items.each do |item|
          formatted_date = item.date.strftime('%Y-%m-%d')
          post_name = item.title.split(%r{ |!|/|:|&|-|$|,}).map { |i| i.downcase if i != '' }.compact.join('-')
          name = "#{formatted_date}-#{post_name}" 

          posts << {
            :name   => "#{name}.html",
            :body   => item.description,
            :header => { :layout => 'post', :title => item.title }
          }
        end

        { :posts => posts }
      end
    end
  end
end
