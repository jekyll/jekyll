require 'rubygems'
require 'fastercsv'
require 'fileutils'
require File.join(File.dirname(__FILE__),"csv.rb")
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
  end
end