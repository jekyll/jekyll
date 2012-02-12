# Author: Toby DiPasquale <toby@cbcg.net>
require 'fileutils'
require 'rubygems'
require 'sequel'
require 'yaml'

module Jekyll
  module Typo
    # This SQL *should* work for both MySQL and PostgreSQL, but I haven't
    # tested PostgreSQL yet (as of 2008-12-16).
    SQL = <<-EOS
    SELECT c.id id,
           c.title title,
           c.permalink slug,
           c.body body,
           c.published_at date,
           c.state state,
           COALESCE(tf.name, 'html') filter
      FROM contents c
           LEFT OUTER JOIN text_filters tf
                        ON c.text_filter_id = tf.id
    EOS

    def self.process dbname, user, pass, host='localhost'
      FileUtils.mkdir_p '_posts'
      db = Sequel.mysql(dbname, :user => user, :password => pass, :host => host, :encoding => 'utf8')
      db[SQL].each do |post|
        next unless post[:state] =~ /published/

        name = [ sprintf("%.04d", post[:date].year),
                 sprintf("%.02d", post[:date].month),
                 sprintf("%.02d", post[:date].day),
                 post[:slug].strip ].join('-')

        # Can have more than one text filter in this field, but we just want
        # the first one for this.
        name += '.' + post[:filter].split(' ')[0]

        File.open("_posts/#{name}", 'w') do |f|
          f.puts({ 'layout'   => 'post',
                   'title'    => post[:title].to_s,
                   'typo_id'  => post[:id]
                 }.delete_if { |k, v| v.nil? || v == '' }.to_yaml)
          f.puts '---'
          f.puts post[:body].delete("\r")
        end
      end
    end

  end
end
