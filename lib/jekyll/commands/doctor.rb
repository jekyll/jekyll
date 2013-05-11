module Jekyll
  module Commands
    class Doctor < Command
      class << self
        def process(options)
          site = Jekyll::Site.new(options)
          site.read

          deprecate_relative_permalinks(site)
        end

        def deprecate_relative_permalinks(site)
          site.pages.each do |page|
            if page.uses_relative_permalinks
              Jekyll::Logger.warn "Deprecation:", "'#{page.path}' uses relative" +
                                  " permalinks which will be automatically" +
                                  " deprecated in Jekyll v1.1."
            end
          end
        end
      end
    end
  end
end
