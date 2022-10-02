# frozen_string_literal: true

require "helper"

class TestThemeDrop < JekyllUnitTest
  should "be initialized only for gem-based themes" do
    assert_nil fixture_site.to_liquid.theme
  end

  context "a theme drop" do
    setup do
      @drop = fixture_site("theme" => "test-theme").to_liquid.theme
    end

    should "respond to `key?`" do
      assert_respond_to @drop, :key?
    end

    should "export relevant data to Liquid templates" do
      expected = {
        "authors"      => "Jekyll",
        "dependencies" => [],
        "description"  => "This is a theme used to test Jekyll",
        "metadata"     => {},
        "root"         => theme_dir,
        "version"      => "0.1.0",
      }
      expected.each_key do |key|
        assert @drop.key?(key)
        assert_equal expected[key], @drop[key]
      end
    end
  end
end
