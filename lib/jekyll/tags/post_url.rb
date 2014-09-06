module Jekyll
  module Tags
    class PostUrl < Liquid::Tag
      MATCHER = /^(.+\/)*(\d+-\d+-\d+)-(.*)$/

      def initialize(tag_name, post, tokens)
        super
        @orig_post = post.strip
        begin
          @post = parse_input_filename(@orig_post)
        rescue
          raise ArgumentError.new <<-eos
Could not parse name of post "#{@orig_post}" in tag 'post_url'.

Make sure the post exists and the name is correct.
eos
        end
      end

      def parse_input_filename(post)
        all, path, date, slug = *name.sub(/^\//, "").match(MATCHER)
        raise ArgumentError.new("'#{name}' does not contain valid date and/or title.") unless all
        File.join(date.to_s, slug.to_s)
      end

      def render(context)
        site = context.registers[:site]

        site.posts.find { |p| @post.match(p.url) }.url

        raise ArgumentError.new <<-eos
Could not find post "#{@orig_post}" in tag 'post_url'.

Make sure the post exists and the name is correct.
eos
      end
    end
  end
end

Liquid::Template.register_tag('post_url', Jekyll::Tags::PostUrl)
