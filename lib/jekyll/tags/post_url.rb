# frozen_string_literal: true

module Jekyll
  module Tags
    class PostComparer
      # Deprecated (soft; No interpreter warnings).
      # To be removed in v5.0.
      # Use private constant `POST_PATH_MATCHER` instead.
      MATCHER = %r!^(.+/)*(\d+-\d+-\d+)-(.*)$!.freeze

      POST_PATH_MATCHER = %r!\A(.+/)*?(\d{2,4}-\d{1,2}-\d{1,2})-([^/]*)\z!.freeze
      private_constant :POST_PATH_MATCHER

      attr_reader :path, :date, :slug, :name

      def initialize(name)
        @name = name

        all, @path, @date, @slug = *name.delete_prefix("/").match(POST_PATH_MATCHER)
        unless all
          raise Jekyll::Errors::InvalidPostNameError,
                "'#{name}' does not contain valid date and/or title."
        end

        basename_pattern = "#{date}-#{Regexp.escape(slug)}\\.[^.]+"
        @name_regex = %r!\A_posts/#{path}#{basename_pattern}|\A#{path}_posts/?#{basename_pattern}!
      end

      def post_date
        @post_date ||= Utils.parse_date(date, "Path '#{name}' does not contain valid date.")
      end

      # Returns `MatchData` or `nil`.
      def ==(other)
        other.relative_path.match(@name_regex)
      end

      # Deprecated. To be removed in v5.0.
      def deprecated_equality(other)
        slug == post_slug(other) &&
          post_date.year  == other.date.year &&
          post_date.month == other.date.month &&
          post_date.day   == other.date.day
      end

      private

      # Construct the directory-aware post slug for a Jekyll::Document object.
      #
      # other - the Jekyll::Document object.
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

      def initialize(tag_name, markup, tokens)
        super
        @markup = markup.strip
        @template = Liquid::Template.parse(@markup) if @markup.include?("{{")

        # Deprecated instance_variables.
        # To be removed in Jekyll v5.0.
        @orig_post = @markup
        @post = nil
      end

      def render(context)
        @context = context
        @resolved_markup = @template&.render(@context) || @markup
        site = context.registers[:site]

        begin
          @post_comparer = PostComparer.new(@resolved_markup)
        rescue StandardError
          raise_markup_parse_error
        end
        # For backwards compatibility only; deprecated instance_variable.
        # To be removed in Jekyll v5.0.
        @post = @post_comparer

        # First pass-through.
        site.posts.docs.each do |post|
          return relative_url(post) if @post_comparer == post
        end

        # First pass-through did not yield the requested post. Search again using legacy matching
        # method. Log deprecation warning if a post is detected via this round.
        site.posts.docs.each do |post|
          next unless @post_comparer.deprecated_equality(post)

          log_legacy_usage_deprecation
          return relative_url(post)
        end

        raise_post_not_found_error
      end

      private

      def raise_markup_parse_error
        raise Jekyll::Errors::PostURLError, <<~MSG
          Could not parse name of post #{@resolved_markup.inspect} in tag 'post_url'.
          Make sure the correct name is given to the tag.
        MSG
      end

      def raise_post_not_found_error
        raise Jekyll::Errors::PostURLError, <<~MSG
          Could not find post #{@resolved_markup.inspect} in tag 'post_url'.
          Make sure the post exists and the correct name is given to the tag.
        MSG
      end

      def log_legacy_usage_deprecation
        Jekyll::Deprecator.deprecation_message(
          "A call to '{% post_url #{@resolved_markup} %}' did not match a post using the new " \
          "matching method of checking name (path-date-slug) equality. Please make sure that " \
          "you change this tag to match the post's name exactly."
        )
      end
    end
  end
end

Liquid::Template.register_tag("post_url", Jekyll::Tags::PostUrl)
