# frozen_string_literal: true

require "helper"

class TestPathManager < JekyllUnitTest
  context "results are always frozen" do
    setup do
      @source = Dir.pwd
    end

    should "freeze the base directory" do
      assert Jekyll::PathManager.sanitized_path(@source, @source).frozen?
    end

    should "freeze a path inside the base directory" do
      assert Jekyll::PathManager.sanitized_path(@source, File.join(@source, "_config.yml")).frozen?
    end

    should "freeze a relative path" do
      assert Jekyll::PathManager.sanitized_path(@source, "_config.yml").frozen?
    end
  end
end
