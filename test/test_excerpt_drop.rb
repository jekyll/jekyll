# frozen_string_literal: true

require "helper"

class TestExcerptDrop < JekyllUnitTest
  context "an excerpt drop" do
    setup do
      @site = fixture_site
      @site.read
      @doc = @site.docs_to_write.find { |d| !d.data["layout"].nil? }
      @doc_drop = @doc.to_liquid
      @excerpt = @doc.data["excerpt"]
      @excerpt_drop = @excerpt.to_liquid
    end

    should "have the right thing" do
      assert @doc.is_a? Jekyll::Document
      assert @doc_drop.is_a? Jekyll::Drops::DocumentDrop
      assert @excerpt.is_a? Jekyll::Excerpt
      assert @excerpt_drop.is_a? Jekyll::Drops::ExcerptDrop
    end

    should "not have an excerpt" do
      assert_nil @excerpt.data["excerpt"]
      assert @excerpt_drop.class.invokable? "excerpt"
      assert_nil @excerpt_drop["excerpt"]
    end

    should "inherit the layout for the drop but not the excerpt" do
      assert_nil @excerpt.data["layout"]
      assert_equal @doc_drop["layout"], @excerpt_drop["layout"]
    end

    should "be inspectable" do
      refute_empty @excerpt_drop.inspect
    end

    should "inherit values from the document" do
      assert_equal @doc_drop.keys.sort, @excerpt_drop.keys.sort
    end
  end
end
