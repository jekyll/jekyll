module Jekyll
  module Tags
    class PostComparer
      MATCHER = /^(.+\/)*(\d+-\d+-\d+)-(.*)$/

      attr_reader :path, :date, :slug, :name

      def initialize(name)
        @name = name
        all, @path, @date, @slug = *name.sub(/^\//, "").match(MATCHER)
        raise ArgumentError.new("'#{name}' does not contain valid date and/or title.") unless all

        @name_regex = /^#{path}#{date}-#{slug}\.[^.]+/
      end

      def ==(other)
        other.basename.match(@name_regex)
      end

      def deprecated_equality(other)
        date = Utils.parse_date(name, "'#{name}' does not contain valid date and/or title.")
        slug == post_slug(other) &&
          date.year  == other.date.year &&
          date.month == other.date.month &&
          date.day   == other.date.day
      end

      private
      # Construct the directory-aware post slug for a Jekyll::Post
      #
      # other - the Jekyll::Post
      #
      # Returns the post slug with the subdirectory (relative to _posts)
      def post_slug(other)
        path = other.basename.split("/")[0...-1].join("/")
        if path.nil? || path == ""
          other.data['slug']
        else
          path + '/' + other.data['slug']
        end
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

        site.posts.docs.each do |p|
          return p.url if @post == p
        end

        # New matching method did not match, fall back to old method
        # with deprecation warning if this matches

        site.posts.docs.each do |p|
          next unless @post.deprecated_equality p
          Jekyll::Deprecator.deprecation_message "A call to '{{ post_url #{@post.name} }}' did not match " \
            "a post using the new matching method of checking name " \
            "(path-date-slug) equality. Please make sure that you " \
            "change this tag to match the post's name exactly."
          return p.url
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
