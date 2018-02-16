# frozen_string_literal: true

require "helper"

class DropFixture < Jekyll::Drops::Drop
  mutable true

  def foo
    "bar"
  end

  def fallback_data
    @fallback_data ||= { "baz" => "buzz" }
  end
end

class TestDrop < JekyllUnitTest
  context "Drops" do
    setup do
      @site = fixture_site({
        "collections" => ["methods"],
      })
      @site.process
      @document = @site.collections["methods"].docs.detect do |d|
        d.relative_path == "_methods/configuration.md"
      end
      @document_drop = @document.to_liquid
      @drop = DropFixture.new({})
    end

    should "reject 'nil' key" do
      refute @drop.key?(nil)
    end

    should "return values for #[]" do
      assert_equal "bar", @drop["foo"]
    end

    should "return values for #invoke_drop" do
      assert_equal "bar", @drop.invoke_drop("foo")
    end

    context "mutations" do
      should "return mutations for #[]" do
        @drop["foo"] = "baz"
        assert_equal "baz", @drop["foo"]
      end

      should "return mutations for #invoke_drop" do
        @drop["foo"] = "baz"
        assert_equal "baz", @drop.invoke_drop("foo")
      end
    end

    context "a document drop" do
      context "fetch" do
        should "raise KeyError if key is not found and no default provided" do
          assert_raises KeyError do
            @document_drop.fetch("not_existing_key")
          end
        end

        should "fetch value without default" do
          assert_equal "Jekyll.configuration", @document_drop.fetch("title")
        end

        should "fetch default if key is not found" do
          assert_equal "default", @document_drop.fetch("not_existing_key", "default")
        end

        should "fetch default boolean value correctly" do
          assert_equal false, @document_drop.fetch("bar", false)
        end

        should "fetch default value from block if key is not found" do
          assert_equal "default bar", @document_drop.fetch("bar") { |el| "default #{el}" }
        end

        should "fetch default value from block first if both argument and block given" do
          assert_equal "baz", @document_drop.fetch("bar", "default") { "baz" }
        end

        should "not change mutability when fetching" do
          assert @drop.class.mutable?
          @drop["foo"] = "baz"
          assert_equal "baz", @drop.fetch("foo")
          assert @drop.class.mutable?
        end
      end
    end

    context "key?" do
      context "a mutable drop" do
        should "respond true for native methods" do
          assert @drop.key? "foo"
        end

        should "respond true for mutable keys" do
          @drop["bar"] = "baz"
          assert @drop.key? "bar"
        end

        should "return true for fallback data" do
          assert @drop.key? "baz"
        end
      end

      context "a document drop" do
        should "respond true for native methods" do
          assert @document_drop.key? "collection"
        end

        should "return true for fallback data" do
          assert @document_drop.key? "title"
        end
      end
    end
  end
end
