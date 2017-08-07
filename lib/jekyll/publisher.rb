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

    private

    def can_be_published?(thing)
      thing.data.fetch("published", true) || @site.unpublished
    end
  end
end
