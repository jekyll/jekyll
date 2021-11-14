# frozen_string_literal: true

require "helper"

class TestWinTz < JekyllUnitTest
  [["America/New_York", "WTZ+05:00"], ["Europe/Paris", "WTZ-01:00"]].each do |tz, expected|
    should "use base offset in winter for #{tz}" do
      result = Jekyll::Utils::WinTZ.calculate(tz, Time.utc(2021, 1, 1))
      assert_equal expected, result
    end
  end

  [["America/New_York", "WTZ+04:00"], ["Europe/Paris", "WTZ-02:00"]].each do |tz, expected|
    should "apply DST in summer for #{tz}" do
      result = Jekyll::Utils::WinTZ.calculate(tz, Time.utc(2021, 7, 1))
      assert_equal expected, result
    end
  end

  [["Australia/Eucla", "WTZ-08:45"], ["Pacific/Marquesas", "WTZ+09:30"]].each do |tz, expected|
    should "handle non zero minutes for #{tz}" do
      result = Jekyll::Utils::WinTZ.calculate(tz, Time.utc(2021, 1, 1))
      assert_equal expected, result
    end
  end

  should "return zero for UTC" do
    result = Jekyll::Utils::WinTZ.calculate("UTC")
    assert_equal "WTZ+00:00", result
  end
end
