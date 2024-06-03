# frozen_string_literal: true

require "helper"

class TestBetaManager < JekyllUnitTest
  context "Beta Manager" do
    setup do
      site = fixture_site
      @manager = BetaManager.new(site)
    end

    should "allow detecting valid but enabled beta feature" do
      refute @manager.enabled?("flagged_feature")
    end
  end
end
