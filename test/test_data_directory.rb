# frozen_string_literal: true

require "helper"

class TestDataDirectory < JekyllUnitTest
  context "Data directory" do
    setup do
      @site = fixture_site
      @site.read
    end

    should "only mimic a Hash instance" do
      directory = @site.site_data
      assert_equal Jekyll::DataDirectory, directory.class
      refute directory.is_a?(Hash)

      copy = directory.dup
      assert copy["greetings"]["foo"]
      assert_includes copy.dig("greetings", "foo"), "Hello!"

      copy["greetings"] = "Hola!"
      assert_equal "Hola!", copy["greetings"]
      refute copy["greetings"]["foo"]

      frozen_dir = Jekyll::DataDirectory.new.freeze
      assert_raises(FrozenError) { frozen_dir["lorem"] = "ipsum" }
    end

    should "be mergable" do
      alpha = Jekyll::DataDirectory.new
      beta  = Jekyll::DataDirectory.new

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
