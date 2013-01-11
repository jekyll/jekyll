# Quickly hacked together my Michael Ivey
# Based on mt.rb by Nick Gerakines, open source and publically
# available under the MIT license. Use this module at your own risk.

require 'rubygems'
require 'sequel'
require 'fastercsv'
require 'fileutils'
require File.join(File.dirname(__FILE__),"csv.rb")

# NOTE: This converter requires Sequel and the MySQL gems.
# The MySQL gem can be difficult to install on OS X. Once you have MySQL
# installed, running the following commands should work:
# $ sudo gem install sequel
# $ sudo gem install mysql -- --with-mysql-config=/usr/local/mysql/bin/mysql_config

module Jekyll
  module Mephisto
    #Accepts a hash with database config variables, exports mephisto posts into a csv
    #export PGPASSWORD if you must
    def self.postgres(c)
      sql = <<-SQL
      BEGIN;
      CREATE TEMP TABLE jekyll AS
        SELECT title, permalink, body, published_at, filter FROM contents
        WHERE user_id = 1 AND type = 'Article' ORDER BY published_at;
      COPY jekyll TO STDOUT WITH CSV HEADER;
      ROLLBACK;
      SQL
      command = %Q(psql -h #{c[:host] || "localhost"} -c "#{sql.strip}" #{c[:database]} #{c[:username]} -o #{c[:filename] || "posts.csv"})
      puts command
      `#{command}`
      CSV.process
    end

    # This query will pull blog posts from all entries across all blogs. If
    # you've got unpublished, deleted or otherwise hidden posts please sift
    # through the created posts to make sure nothing is accidently published.
    QUERY = "SELECT id, \
                    permalink, \
                    body, \
                    published_at, \
                    title \
             FROM contents \
             WHERE user_id = 1 AND \
                   type = 'Article' AND \
                   published_at IS NOT NULL \
             ORDER BY published_at"

    def self.process(dbname, user, pass, host = 'localhost')
      db = Sequel.mysql(dbname, :user => user,
                                :password => pass,
                                :host => host,
                                :encoding => 'utf8')

      FileUtils.mkdir_p "_posts"

      db[QUERY].each do |post|
        title = post[:title]
        slug = post[:permalink]
        date = post[:published_at]
        content = post[:body]

        # Ideally, this script would determine the post format (markdown,
        # html, etc) and create files with proper extensions. At this point
        # it just assumes that markdown will be acceptable.
        name = [date.year, date.month, date.day, slug].join('-') + ".markdown"

        data = {
           'layout' => 'post',
           'title' => title.to_s,
           'mt_id' => post[:entry_id],
         }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

        File.open("_posts/#{name}", "w") do |f|
          f.puts data
          f.puts "---"
          f.puts content
        end
      end

    end
  end
end
