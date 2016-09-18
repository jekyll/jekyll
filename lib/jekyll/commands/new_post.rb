class Jekyll::Commands::NewPost < Jekyll::Command
  class << self
    def init_with_program(prog)
      prog.command(:"new-post") do |c|
        c.syntax "new-post TITLE"
        c.description "Creates a new Jekyll post scaffold in current dir"

        c.action do |args, opts|
          Jekyll::Commands::NewPost.process(args, opts)
        end
      end
    end

    def process(args, _opts)
      raise ArgumentError, "You must specifiy a post title." if args.empty?
      title = args.join(" ")

      filename = Jekyll::Commands::NewPost.process_filename(title)
      file_path = File.expand_path(filename, Dir.pwd)

      if File.exists?(file_path)
        Jekyll.logger.abort_with "Conflict:", "#{file_path} already exists."
      end

      contents = Jekyll::Commands::NewPost.prepare_template(title)
      File.open(File.expand_path(filename, Dir.pwd), "w") do |f|
        f.write(contents)
      end
    end

    def process_filename(title)
      "#{Time.now.strftime("%F")}-#{title.gsub(%r!\W+!, "_")}.markdown"
    end

    def prepare_template(title)
      <<-END
---
layout: post
title: "#{title}"
date: #{Time.now.strftime("%F %T %z")}
categories: update
---

Insert your text here
      END
    end
  end
end
