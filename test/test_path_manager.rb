# frozen_string_literal: true

require "helper"

class TestPathManager < JekyllUnitTest
  context "PathManager" do
    setup do
      @source = Dir.pwd
    end

    should "return frozen copy of base if questionable path is nil" do
      assert_equal @source, Jekyll::PathManager.sanitized_path(@source, nil)
      assert Jekyll::PathManager.sanitized_path(@source, nil).frozen?
    end

    should "return a frozen copy of base if questionable path expands into the base" do
      assert_equal @source, Jekyll::PathManager.sanitized_path(@source, File.join(@source, "/"))
      assert Jekyll::PathManager.sanitized_path(@source, File.join(@source, "/")).frozen?
    end

    should "return a frozen string result" do
      if Jekyll::Utils::Platforms.really_windows?
        assert_equal(
          "#{@source}/_config.yml",
          Jekyll::PathManager.sanitized_path(@source, "E:\\_config.yml")
        )
      end
      assert_equal(
        "#{@source}/_config.yml",
        Jekyll::PathManager.sanitized_path(@source, "//_config.yml")
      )
      assert Jekyll::PathManager.sanitized_path(@source, "//_config.yml").frozen?
    end
  end
end
