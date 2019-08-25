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

  context "Theme with data files in a site" do
    setup do
      @site = fixture_site(
        "theme" => "test-theme"
      )
      assert @site.theme.data_path
      @theme_data = DataReader.new(@site, :mode => :theme).read("_data")
      @site.process
    end

    context "without data files at source" do
      should "read data files in theme gem" do
        assert_equal @theme_data["navigation"]["topnav"], @site.data["navigation"]["topnav"]
      end

      should "use data from theme gem" do
        assert_equal(
          File.read(source_dir("theme_data_test", "output.html")),
          File.read(@site.in_dest_dir("theme_data_test/nav.html"))
        )
      end
    end

    context "with same data filenames at source" do
      should "override theme data" do
        file_content = SafeYAML.load_file(source_dir("_data/navigation/", "sidenav.yml"))
        assert_equal file_content, @site.data["navigation"]["sidenav"]
      end

      should "also use data from theme gem" do
        assert_equal(
          File.read(source_dir("theme_data_test", "override_output.html")),
          File.read(@site.in_dest_dir("theme_data_test/nav-override.html"))
        )
      end
    end
  end
end
