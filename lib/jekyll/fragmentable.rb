module Jekyll
  # Requires #content
  module Fragmentable
    def fragments
      @fragments ||= Array.new
    end

    def inject_fragments!
      self.fragments.each do |f|
        f.transform
        self.content.sub!(f.placeholder, f.content)
      end
    end
  end
end