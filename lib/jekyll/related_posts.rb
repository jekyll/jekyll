module Jekyll
  class RelatedPosts

    class << self
      attr_accessor :lsi
    end

    attr_reader :post, :site

    def initialize(post)
      @post = post
      @site = post.site
      require 'classifier' if site.lsi
    end

    def build
      return [] unless self.site.posts.size > 1

      if self.site.lsi
        build_index
        lsi_related_posts
      else
        most_recent_posts
      end
    end

    def build_index
      self.class.lsi ||= begin
        puts "Starting the classifier..."
        lsi = Classifier::LSI.new(:auto_rebuild => false)
        display("  Populating LSI... ")

        self.site.posts.each do |x|
          display(".")
          lsi.add_item(x)
        end

        display("\n  Rebuilding LSI index... ")
        lsi.build_index
        puts ""
        lsi
      end
    end

    def lsi_related_posts
      lsi.find_related(post.content, 11) - [self.post]
    end

    def most_recent_posts
      (self.site.posts - [self.post])[0..9]
    end

    def display(output)
      $stdout.print(output)
      $stdout.flush
    end

  end
end
