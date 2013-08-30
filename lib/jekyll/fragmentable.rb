module Jekyll
  # Requires #content
  module Fragmentable
    def fragments
      @fragments ||= Array.new
    end

    def inject_fragments
      self.fragments.each do |f|
        f.transform
        self.content.gsub!(/[^\/]\Q#{f.placeholder}\E/, f.content)
      end
    end
  end
end