module Jekyll
  class RelatedPosts
    class << self
      attr_accessor :lsi
    end

    attr_reader :post, :site

    def initialize(post)
      @post = post
      @site = post.site
      Jekyll::External.require_with_graceful_fail("classifier-reborn") if site.lsi
    end

    def build
      return [] unless site.posts.docs.size > 1

      if site.lsi
        build_index
        lsi_related_posts
      else
        most_recent_posts
      end
    end

    def build_index
      self.class.lsi ||= begin
        lsi = ClassifierReborn::LSI.new(:auto_rebuild => false)
        display("Populating LSI...")

        site.posts.docs.each do |x|
          lsi.add_item(x)
        end

        display("Rebuilding index...")
        lsi.build_index
        display("")
        lsi
      end
    end

    def lsi_related_posts
      self.class.lsi.find_related(post, 11)
    end

    def most_recent_posts
      @most_recent_posts ||= (site.posts.docs.reverse - [post]).first(10)
    end

    def display(output)
      $stdout.print("\n")
      $stdout.print(Jekyll.logger.formatted_topic(output))
      $stdout.flush
    end
  end
end
