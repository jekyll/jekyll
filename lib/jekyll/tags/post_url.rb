module Jekyll

  class PostComparer
    MATCHER = /^(.+\/)*(\d+-\d+-\d+)-(.*)$/

    attr_accessor :date, :slug

    def initialize(name)
      who, cares, date, slug = *name.match(MATCHER)
      @slug = slug
      @date = Time.parse(date)
    end
  end

  class PostUrl < Liquid::Tag
    def initialize(tag_name, post, tokens)
      super
      @orig_post = post.strip
      @post = PostComparer.new(@orig_post)
    end

    def render(context)
      site = context.registers[:site]
      
      site.posts.each do |p|
        if p == @post
          return p.url
        end
      end

      puts "ERROR: post_url: \"#{@orig_post}\" could not be found"

      return "#"
    end
  end
end

Liquid::Template.register_tag('post_url', Jekyll::PostUrl)
