# frozen_string_literal: true

module Jekyll
  class Publisher

    @@default_value = nil

    def initialize(site)
      @site = site
    end

    def publish?(thing)
      can_publish = can_be_published?(thing)
      if can_publish == @@default_value
        !hidden_in_the_future?(thing)
      else
        can_publish
      end
    end

    def hidden_in_the_future?(thing)
      thing.respond_to?(:date) && !@site.future && thing.date.to_i > @site.time.to_i
    end

    private

    def can_be_published?(thing)
      published = thing.data.fetch("published", @@default_value)
      if published == @@default_value || @site.unpublished
        nil
      else
        published
      end
    end
  end
end
