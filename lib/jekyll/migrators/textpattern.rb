require 'rubygems'
require 'sequel'
require 'fileutils'
require 'yaml'

# NOTE: This converter requires Sequel and the MySQL gems.
# The MySQL gem can be difficult to install on OS X. Once you have MySQL
# installed, running the following commands should work:
# $ sudo gem install sequel
# $ sudo gem install mysql -- --with-mysql-config=/usr/local/mysql/bin/mysql_config

module Jekyll
  module TextPattern
    # Reads a MySQL database via Sequel and creates a post file for each post.
    # The only posts selected are those with a status of 4 or 5, which means
    # "live" and "sticky" respectively.
    # Other statuses are 1 => draft, 2 => hidden and 3 => pending.
    QUERY = "SELECT Title, \
                    url_title, \
                    Posted, \
                    Body, \
                    Keywords \
             FROM textpattern \
             WHERE Status = '4' OR \
                   Status = '5'"

    def self.process(dbname, user, pass, host = 'localhost')
      db = Sequel.mysql(dbname, :user => user, :password => pass, :host => host, :encoding => 'utf8')

      FileUtils.mkdir_p "_posts"

      db[QUERY].each do |post|
        # Get required fields and construct Jekyll compatible name.
        title = post[:Title]
        slug = post[:url_title]
        date = post[:Posted]
        content = post[:Body]

        name = [date.strftime("%Y-%m-%d"), slug].join('-') + ".textile"

        # Get the relevant fields as a hash, delete empty fields and convert
        # to YAML for the header.
        data = {
           'layout' => 'post',
           'title' => title.to_s,
           'tags' => post[:Keywords].split(',')
         }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

        # Write out the data and content to file.
        File.open("_posts/#{name}", "w") do |f|
          f.puts data
          f.puts "---"
          f.puts content
        end
      end
    end
  end
end
