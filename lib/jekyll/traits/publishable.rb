module Jekyll
  module Traits
    module Publishable

      def published?
        !(data.key?('published') && data['published'] == false)
      end

    end
  end
end
