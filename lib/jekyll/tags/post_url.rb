module Jekyll
  module Tags
    class PostComparer
      MATCHER = /^(.+\/)*(\d+-\d+-\d+)-(.*)$/

      attr_accessor :path, :date, :slug

      def initialize(name)
        all, @path, @date, @slug = *name.sub(/^\//, "").match(MATCHER)
        raise ArgumentError.new("'#{name}' does not contain valid date and/or title.") unless all
      end

      def ==(other)
        other.name.match(/^#{path}#{date}-#{slug}\.[^.]+/)
      end
    end

    class PostUrl < Liquid::Tag
      def initialize(tag_name, post, tokens)
        super
        @orig_post = post.strip
        begin
          @post = PostComparer.new(@orig_post)
        rescue
          raise ArgumentError.new <<-eos
Could not parse name of post "#{@orig_post}" in tag 'post_url'.

Make sure the post exists and the name is correct.
eos
        end
      end

      def render(context)
        site = context.registers[:site]

        site.posts.each do |p|
          if @post == p
            return p.url
          end
        end

        raise ArgumentError.new <<-eos
Could not find post "#{@orig_post}" in tag 'post_url'.

Make sure the post exists and the name is correct.
eos
      end
    end
  end
end

Liquid::Template.register_tag('post_url', Jekyll::Tags::PostUrl)
