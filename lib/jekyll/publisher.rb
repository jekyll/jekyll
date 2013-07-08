module Jekyll
  class Publisher
    def self.published?(thing)
      thing.data.fetch('published', true)
    end
  end
end