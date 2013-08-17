module Jekyll
  module Commands
    class Doctor < Command
      class << self
        def process(options)
          @site = Jekyll::Site.new(options)
          @site.read

          unless deprecated_relative_permalinks || check_permalink_conflict
            Jekyll.logger.info "Your test results", "are in. Everything looks fine."
          end
        end

        def deprecated_relative_permalinks
          contains_deprecated_pages = false
          @site.pages.each do |page|
            if page.uses_relative_permalinks
              Jekyll.logger.warn "Deprecation:", "'#{page.path}' uses relative" +
                                  " permalinks which will be deprecated in" +
                                  " Jekyll v1.1 and beyond."
              contains_deprecated_pages = true
            end
          end
          contains_deprecated_pages
        end

        def check_permalink_conflict
          has_conflict = false
          pages = Hash.new
          @site.pages.each do |page|
            if pages.has_key?(page.url)
              has_conflict = true
              Jekyll.logger.warn "Conflict:", "The pages '#{pages[page.url].path}' and '#{page.path}'" +
                                  " both have their URL set to '#{page.url}'."
            else
              pages[page.url] = page
            end
          end
          has_conflict
        end
      end
    end
  end
end
