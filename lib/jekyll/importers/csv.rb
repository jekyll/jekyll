begin
  require 'fastercsv' unless RUBY_VERSION > '1.9'
  require 'csv'       if     RUBY_VERSION > '1.9'
rescue LoadError
  puts 'FasterCSV gem is not installed. Please do `[sudo] gem install fastercsv`'
  exit(1)
end

# Some-what hacky solution to get around the CSV/FasterCSV 1.9 problem.
begin
  class Csv < FasterCSV; end
rescue
  class Csv < CSV; end
end

module Jekyll
  module Importers
    class CSV < Importer
      # Public: Get the importer usage and command line options.
      #
      # Returns a String of the help message.
      def self.help
        <<-EOS
        Jekyll CSV Importer

        CSV Formatting:

            title, slug, body, date, format

          Example:

            'Hello World','hello-world','Hello World from Jekyll','2012-06-12','markdown'

        Basic Command Line Usage:

            jekyll import csv <options>

        Configuration options:

            --file [PATH]                File to import from
        EOS
      end
      
      # Public: Validate a Hash of command line options for the importer.
      #
      # options - A Hash of options passed in from the command line.
      #
      # Returns an Array of Strings representing validation errors.
      def self.validate(options)
        errors = []
        errors << "--file is required" if options[:file].nil?
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
        posts = []

        Csv.foreach(options[:file]) do |row|
          next if row[0] == "title"
          name = row[3].split(" ")[0] + "-" + row[1] + (row[4] =~ /markdown/ ? ".md" : ".textile")
          posts << {
            :title  => row[0],
            :name   => name,
            :body   => row[2],
            :header => { :layout => 'posts', :title => row[0] }
          }
        end

        { :posts => posts }
      end
    end
  end
end
