begin
  require 'sequel'
rescue LoadError
  puts 'Sequel gem is not installed. Please do `[sudo] gem install sequel`'
  exit(1)
end

module Jekyll
  module Importers
    class Drupal < Importer
      QUERY = "SELECT n.nid, \
                      n.title, \
                      nr.body, \
                      n.created, \
                      n.status \
               FROM node AS n, \
                    node_revisions AS nr \
               WHERE (n.type = 'blog' OR n.type = 'story') \
               AND n.vid = nr.vid"


      def self.help
        <<-EOS
        Jekyll drupal Importer

        Basic Command Line Usage:

            jekyll import drupal <options>

        Configuration options:

            --dbname [TEXT]              DB to import from
            --user [TEXT]                Username to use when importing
            --pass [TEXT]                Password to use when importing
            --host [HOST ADDRESS]        Host to import from
            --table-prefix [PREFIX]      Table prefix to use when importing
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

        if prefix != ''
          QUERY[" node "] = " " + prefix + "node "
          QUERY[" node_revisions "] = " " + prefix + "node_revisions "
        end

        posts  = []
        drafts = []

        db[QUERY].each do |post|
          title = post[:title]
          content = post[:body]
          created = post[:created]
          time = Time.at(created)
          is_published = post[:status] == 1
          slug = title.strip.downcase.gsub(/(&|&amp;)/, ' and ').gsub(/[\s\.\/\\]/, '-').gsub(/[^\w-]/, '').gsub(/[-_]{2,}/, '-').gsub(/^[-_]/, '').gsub(/[-_]$/, '')
          name = time.strftime("%Y-%m-%d-") + slug + '.md'

          post_hash = {
            :name   => name,
            :body   => content, 
            :header => {
              :layout  => 'post',
              :title   => title.to_s,
              :created => created
            }
          }

          if is_publised
            posts << post_hash
          else
            drafts << post_hash
        end

        { :posts => posts, :drafts => drafts }
      end
    end
  end
end
