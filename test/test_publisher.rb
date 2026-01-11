# frozen_string_literal: true

require "helper"

class TestPublisher < JekyllUnitTest
  context "when a thing's collection is configured to show future posts" do
    setup do
      site = fixture_site
      collection = Jekyll::Collection.new(site, "methods")
      collection.metadata["future"] = true
      @thing = Jekyll::Document.new(
        source_dir("methods/method.md"),
        :site       => site,
        :collection => collection
      )
      @thing.data["date"] = (Time.now + (60 * 60 * 24)).to_i # tomorrow
      @publisher = Jekyll::Publisher.new(site)
    end

    should "not be hidden in the future" do
      refute @publisher.hidden_in_the_future?(@thing)
    end
  end
end
