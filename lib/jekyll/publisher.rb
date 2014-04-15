module Jekyll
  class Publisher
    def initialize(site)
      @site = site
    end

    def publish?(thing)
      can_be_published?(thing) && !hidden_in_the_future?(thing)
    end

    private

    def can_be_published?(thing)
      thing.data.fetch('published', true) || @site.unpublished
    end

    def hidden_in_the_future?(thing)
      thing.is_a?(Post) && !@site.future && thing.date > @site.time
    end
  end
end