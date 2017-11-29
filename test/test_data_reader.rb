# frozen_string_literal: true

require "helper"

class TestDataReader < JekyllUnitTest
  context "#sanitize_filename" do
    setup do
      @reader = DataReader.new(fixture_site)
    end

    should "remove evil characters" do
      assert_equal "helpwhathaveIdone", @reader.sanitize_filename(
        "help/what^&$^#*(!^%*!#haveId&&&&&&&&&one"
      )
    end
  end
end
