# frozen_string_literal: true

module Jekyll
  class Publisher
    def initialize(site)
      @site = site
    end

    def publish?(thing)
      can_be_published?(thing) && !hidden_in_the_future?(thing)
    end

    def hidden_in_the_future?(thing)
      thing.respond_to?(:date) && !@site.future && thing.date.to_i > @site.time.to_i
    end

    # In contast to a future-dated file returning true to `hidden_in_the_future?`
    # method based on site configuration, a Document or Page with front matter
    # `published: false` will be read, but thereafter always ignored.
    def hidden_forever?(thing)
      thing.data["published"] == false
    end

    private

    def can_be_published?(thing)
      thing.data.fetch("published", true) || @site.unpublished
    end
  end
end
