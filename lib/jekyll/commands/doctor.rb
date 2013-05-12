module Jekyll
  module Commands
    class Doctor < Command
      class << self
        def process(options)
          site = Jekyll::Site.new(options)
          site.read

          unless deprecated_relative_permalinks(site)
            Jekyll::Logger.info "Your test results", "are in. Everything looks fine."
          end
        end

        def deprecated_relative_permalinks(site)
          contains_deprecated_pages = false
          site.pages.each do |page|
            if page.uses_relative_permalinks
              Jekyll::Logger.warn "Deprecation:", "'#{page.path}' uses relative" +
                                  " permalinks which will be deprecated in" +
                                  " Jekyll v1.1 and beyond."
              contains_deprecated_pages = true
            end
          end
          contains_deprecated_pages
        end
      end
    end
  end
end
