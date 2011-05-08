module Jekyll
  module CSV
    # Reads a csv with title, permalink, body, published_at, and filter.
    # It creates a post file for each row in the csv
    def self.process(file = "posts.csv")
      FileUtils.mkdir_p "_posts"
      posts = 0
      FasterCSV.foreach(file) do |row|
        next if row[0] == "title"
        posts += 1
        name = row[3].split(" ")[0]+"-"+row[1]+(row[4] =~ /markdown/ ? ".markdown" : ".textile")
        File.open("_posts/#{name}", "w") do |f|
          f.puts <<-HEADER
---
layout: post
title: #{row[0]}
---

          HEADER
          f.puts row[2]
        end
      end
      "Created #{posts} posts!"
    end
  end
end
