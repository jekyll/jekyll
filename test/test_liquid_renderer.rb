require 'helper'

class TestLiquidRenderer < JekyllUnitTest
  context "profiler" do
    setup do
      @site = Site.new(site_configuration)
      @renderer = @site.liquid_renderer
    end

    should "return a table with profiling results" do
      @site.process

      output = @renderer.stats_table

      expected = [
        /^Filename\s+|\s+Count\s+|\s+Bytes\s+|\s+Time$/,
        /^-+\++-+\++-+\++-+$/,
        /^_posts\/2010-01-09-date-override\.markdown\s+|\s+\d+\s+|\s+\d+\.\d{2}K\s+|\s+\d+\.\d{3}$/,
      ]

      expected.each do |regexp|
        assert_match regexp, output
      end
    end
  end
end
