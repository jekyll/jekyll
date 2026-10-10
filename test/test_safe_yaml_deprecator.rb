# frozen_string_literal: true

require "helper"

class TestSafeYAMLDeprecator < JekyllUnitTest
  context "A plugin calls SafeYAML" do
    should "Show a deprecation warning" do
      expect(Jekyll::Deprecator).to(
        receive(:deprecation_message).with(%r!SafeYAML!)
      )

      SafeYAML.load("---\ntest: true")
    end

    should "Show a deprecation warning when loading a file" do
      expect(Jekyll::Deprecator).to(
        receive(:deprecation_message).with(%r!SafeYAML!)
      )

      SafeYAML.load_file("test/source/_data/members.yaml")
    end
  end
end
