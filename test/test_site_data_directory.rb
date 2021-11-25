# frozen_string_literal: true

require "helper"

class TestSiteDataDirectory < JekyllUnitTest
  context "Data directory" do
    setup do
      @site = fixture_site
      @site.read
    end

    should "only mimic a Hash instance" do
      directory = @site.site_data
      assert_equal Jekyll::SiteData::Directory, directory.class
      refute directory.is_a?(Hash)

      copy = directory.dup
      assert copy["greetings"]["foo"]
      assert_includes copy.dig("greetings", "foo"), "Hello!"

      copy["greetings"] = "Hola!"
      assert_equal "Hola!", copy["greetings"]
      refute copy["greetings"]["foo"]

      frozen_dir = Jekyll::SiteData::Directory.new.freeze
      assert_raises(FrozenError) { frozen_dir["lorem"] = "ipsum" }
    end

    should "be mergable" do
      alpha = Jekyll::SiteData::Directory.new
      beta  = Jekyll::SiteData::Directory.new

      assert_equal "{}", alpha.inspect
      sample_data = { "foo" => "bar" }

      assert_equal sample_data["foo"], alpha.merge(sample_data)["foo"]
      assert_equal alpha.class, alpha.merge(sample_data).class
      assert_empty alpha

      beta.merge!(sample_data)
      assert_equal sample_data["foo"], alpha.merge(beta)["foo"]
      assert_equal alpha.class, alpha.merge(beta).class
      assert_empty alpha

      beta.merge!(@site.site_data)
      assert_equal alpha.class, beta.class
      assert_includes beta.dig("greetings", "foo"), "Hello!"

      assert_empty alpha
      assert_equal sample_data["foo"], Jekyll::Utils.deep_merge_hashes(alpha, sample_data)["foo"]
      assert_includes(
        Jekyll::Utils.deep_merge_hashes(alpha, beta).dig("greetings", "foo"),
        "Hello!"
      )
    end
  end
end
