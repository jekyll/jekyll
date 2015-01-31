module Jekyll
  module Hooks
    class Site < Jekyll::Plugin
      # Called before after Jekyll reads in items
      # Returns nothing
      #
      def pre_read(site)
      end

      # Called right after Jekyll reads in all items, but before generators
      # Returns nothing
      #
      def post_read(site)
      end

      # Called before Jekyll renders posts and pages
      # Returns nothing
      #
      def pre_render(site)
      end

      # Merges hash into site_payload
      # Returns hash to be merged
      #
      def merge_payload(payload, site)
        payload
      end

      # Called after Jekyll writes site files
      # Returns nothing
      #
      def post_write(site)
      end
    end

    class Page < Jekyll::Plugin
      # Called after Page is initialized
      # allows you to modify a # page object before it is
      # added to the Jekyll pages array
      #
      def post_init(page)
      end

      # Called before post is sent to the converter. Allows
      # you to modify the post object before the converter
      # does it's thing
      #
      def pre_render(page)
      end

      # Called right after pre_render hook. Allows you to
      # act on the page's payload data.
      #
      # Return: hash to be deep_merged into payload
      #
      def merge_payload(payload, page)
        payload
      end

      # Called after the post is rendered with the converter.
      # Use the post object to modify it's contents before the
      # post is inserted into the template.
      #
      def post_render(page)
      end

      # Called after the post is written to the disk.
      # Use the post object to read it's contents to do something
      # after the post is safely written.
      #
      def post_write(page)
      end
    end

    class Post < Jekyll::Plugin
      def post_init(post); end
      def merge_payload(payload, post); payload; end
      def pre_render(post); end
      def post_render(post); end
      def post_write(post); end
    end

    class Document < Jekyll::Plugin
      def post_init(doc); end
      def merge_payload(payload, doc); payload; end
      def pre_render(doc); end
      def post_render(doc); end
      def post_write(doc); end
    end

    class All < Jekyll::Plugin
      def post_init(item); end
      def merge_payload(payload, item); payload; end
      def pre_render(item); end
      def post_render(item); end
      def post_write(item); end
    end

  end
end
