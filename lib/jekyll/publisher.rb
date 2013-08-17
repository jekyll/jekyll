module Jekyll
  class Publisher
    def self.publishing?(thing)
      thing.data.fetch('published', true)
    end
  end
end