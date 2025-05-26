# frozen_string_literal: true

module Jekyll
  module Tags
    class PostComparer
      MATCHER = %r!\A(.+/)*?(\d{2,4}-\d{1,2}-\d{1,2})-([^/]*)\z!.freeze

      attr_reader :path, :date, :slug, :name

      def initialize(name)
        @name = name

        all, @path, @date, @slug = *name.delete_prefix("/").match(MATCHER)
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

      # Returns `true` or `false`.
      def acceptable?(post)
        @name_regex.match?(post.relative_path)
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

        begin
          @post_comparer = PostComparer.new(@markup)
        rescue StandardError
          raise_markup_parse_error
        end

        # Deprecated instance_variables.
        # To be removed in Jekyll v5.0.
        @orig_post = @markup
        @post = @post_comparer
      end

      def render(context)
        @context = context
        site = context.registers[:site]

        # First pass-through.
        site.posts.docs.each do |post|
          return relative_url(post) if @post_comparer.acceptable?(post)
        end

        # First pass-through did not yield the requested post. Search again using legacy matching
        # method. Log deprecation warning if a post is detected via this round.
        site.posts.docs.each do |post|
          next unless @post_comparer.deprecated_equality(post)

          log_legacy_usage_deprecation(
            :rel_path         => post.relative_path,
            :cleaned_rel_path => post.cleaned_relative_path.squeeze("/")
          )
          return relative_url(post)
        end

        raise_post_not_found_error
      end

      private

      def raise_markup_parse_error
        raise Jekyll::Errors::PostURLError, <<~MSG
          Could not parse name of post #{@markup.inspect} in tag 'post_url'.
          Make sure the correct name is given to the tag.
        MSG
      end

      def raise_post_not_found_error
        raise Jekyll::Errors::PostURLError, <<~MSG
          Could not find post #{@markup.inspect} in tag 'post_url'.
          Make sure the post exists and the correct name is given to the tag.
        MSG
      end

      def log_legacy_usage_deprecation(rel_path:, cleaned_rel_path:)
        Jekyll::Deprecator.deprecation_message(
          "A call to '{% post_url #{@markup} %}' matched with post #{rel_path.inspect}. " \
          "This ambiguous usage to link nested posts is no longer supported and will be " \
          "removed in v5.0. Prefer using {% post_url #{cleaned_rel_path} %} instead."
        )
      end
    end
  end
end

Liquid::Template.register_tag("post_url", Jekyll::Tags::PostUrl)
