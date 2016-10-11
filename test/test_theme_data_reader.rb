require "helper"

class TestThemeDataReader < JekyllUnitTest
  def setup
    @site = fixture_site(
      "theme"       => "test-theme"
    )
    assert @site.theme
    @theme_data = ThemeDataReader.new(@site).read("_data")
    @site.process
  end

  context "site without data files but with a valid theme" do
    should "read data files in theme gem" do
      assert_equal @site.data["navigation"]["topnav"],
                   @theme_data["navigation"]["topnav"]
    end

    should "use data from theme gem" do
      assert_equal File.read(@site.in_dest_dir("theme_data_test/nav.html")),
        File.read(File.join(source_dir, "theme_data_test", "output.html"))
    end
  end

  context "site with same data files as theme data files in theme gem" do
    should "override theme data" do
      file_content = SafeYAML.load_file(
        File.join(source_dir, "_data/navigation/", "sidenav.yml")
      )
      assert_equal @site.data["navigation"]["sidenav"], file_content
    end

    should "use data from theme gem" do
      assert_equal File.read(@site.in_dest_dir("theme_data_test/nav-override.html")),
        File.read(File.join(source_dir, "theme_data_test", "override_output.html"))
    end
  end
end
