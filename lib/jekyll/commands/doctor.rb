module Jekyll
  module Commands
    class Doctor < Command
      def self.process(options)
        site = Jekyll::Site.new(options)
        site.read

        if healthy?(site)
          Jekyll.logger.info "Your test results", "are in. Everything looks fine."
        else
          abort
        end
      end

      def self.healthy?(site)
        [
          !deprecated_relative_permalinks(site),
          !conflicting_urls(site)
        ].all?
      end

      def self.deprecated_relative_permalinks(site)
        contains_deprecated_pages = false
        site.pages.each do |page|
          if page.uses_relative_permalinks
            Jekyll.logger.warn "Deprecation:", "'#{page.path}' uses relative" +
                                " permalinks which will be deprecated in" +
                                " Jekyll v1.2 and beyond."
            contains_deprecated_pages = true
          end
        end
        contains_deprecated_pages
      end

      def self.conflicting_urls(site)
        conflicting_urls = false
        urls = {}
        urls = collect_urls(urls, site.pages, site.dest)
        urls = collect_urls(urls, site.posts, site.dest)
        urls.each do |url, paths|
          if paths.size > 1
            conflicting_urls = true
            Jekyll.logger.warn "Conflict:", "The URL '#{url}' is the destination" +
              " for the following pages: #{paths.join(", ")}"
          end
        end
        conflicting_urls
      end

      private

      def self.collect_urls(urls, things, destination)
        things.each do |thing|
          dest = thing.destination(destination)
          if urls[dest]
            urls[dest] << thing.path
          else
            urls[dest] = [thing.path]
          end
        end
        urls
      end
    end
  end
end
