# frozen_string_literal: true

module Jekyll
  module Tags
    class PostComparer
      MATCHER = %r!^(.+/)*(\d+-\d+-\d+)-(.*)$!.freeze

      attr_reader :path, :date, :slug, :name

      def initialize(name)
        @name = name

        all, @path, @date, @slug = *name.sub(%r!^/!, "").match(MATCHER)
        unless all
          raise Jekyll::Errors::InvalidPostNameError,
                "'#{name}' does not contain valid date and/or title."
        end

        basename_pattern = "#{date}-#{Regexp.escape(slug)}\\.[^.]+"
        @name_regex = %r!^_posts/#{path}#{basename_pattern}|^#{path}_posts/?#{basename_pattern}!
      end

      def post_date
        @post_date ||= Utils.parse_date(
          date,
          "'#{date}' does not contain valid date and/or title."
        )
      end

      def ==(other)
        other.relative_path.match(@name_regex)
      end

      def deprecated_equality(other)
        slug == post_slug(other) &&
          post_date.year  == other.date.year &&
          post_date.month == other.date.month &&
          post_date.day   == other.date.day
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
          other.data["slug"]
        else
          "#{path}/#{other.data["slug"]}"
        end
      end
    end

    class PostUrl < Liquid::Tag
      include Jekyll::Filters::URLFilters

      def initialize(tag_name, post, tokens)
        super
        @orig_post = post.strip
        begin
          @post = PostComparer.new(@orig_post)
        rescue StandardError => e
          raise Jekyll::Errors::PostURLError, <<~MSG
            Could not parse name of post "#{@orig_post}" in tag 'post_url'.
             Make sure the post exists and the name is correct.
             #{e.class}: #{e.message}
          MSG
        end
      end

      def render(context)
        @context = context
        site = context.registers[:site]

        site.posts.docs.each do |document|
          return relative_url(document) if @post == document
        end

        # New matching method did not match, fall back to old method
        # with deprecation warning if this matches

        site.posts.docs.each do |document|
          next unless @post.deprecated_equality document

          Jekyll::Deprecator.deprecation_message "A call to "\
            "'{% post_url #{@post.name} %}' did not match " \
            "a post using the new matching method of checking name " \
            "(path-date-slug) equality. Please make sure that you " \
            "change this tag to match the post's name exactly."
          return relative_url(document)
        end

        raise Jekyll::Errors::PostURLError, <<~MSG
          Could not find post "#{@orig_post}" in tag 'post_url'.
          Make sure the post exists and the name is correct.
        MSG
      end
    end
  end
end

Liquid::Template.register_tag("post_url", Jekyll::Tags::PostUrl)
