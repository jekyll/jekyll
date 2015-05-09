module Jekyll
  module Traits
    module Relatable

      # Calculate related posts.
      #
      # Returns an Array of related Posts.
      def related_posts(posts)
        Jekyll::RelatedPosts.new(self).build
      end

    end
  end
end
