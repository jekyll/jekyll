require "helper"

class TestTheme < JekyllUnitTest
  def setup
    @theme = Theme.new("test-theme")
    @expected_root = File.expand_path "./fixtures/test-theme", File.dirname(__FILE__)
  end

  context "initializing" do
    should "normalize the theme name" do
      theme = Theme.new(" Test-Theme ")
      assert_equal "test-theme", theme.name
    end

    should "know the theme root" do
      assert_equal @expected_root, @theme.root
    end

    should "know the theme version" do
      assert_equal Gem::Version.new("0.1.0"), @theme.version
    end

    should "raise an error for invalid themes" do
      assert_raises Jekyll::Errors::MissingDependencyException do
        Theme.new("foo").version
      end
    end

    should "add itself to sass's load path" do
      @theme.configure_sass
      message = "Sass load paths should include the theme sass dir"
      assert Sass.load_paths.include?(@theme.sass_path), message
    end
  end

  context "path generation" do
    [:assets, :_layouts, :_includes, :_sass].each do |folder|
      should "know the #{folder} path" do
        expected = File.expand_path(folder.to_s, @expected_root)
        assert_equal expected, @theme.public_send("#{folder.to_s.tr("_", "")}_path")
      end
    end

    should "generate folder paths" do
      expected = File.expand_path("./_sass", @expected_root)
      assert_equal expected, @theme.send(:path_for, :_sass)
    end

    should "not allow paths outside of the theme root" do
      assert_equal nil, @theme.send(:path_for, "../../source")
    end

    should "return nil for paths that don't exist" do
      assert_equal nil, @theme.send(:path_for, "foo")
    end

    should "return the resolved path when a symlink & resolved path exists" do
      expected = File.expand_path("./_layouts", @expected_root)
      assert_equal expected, @theme.send(:path_for, :_symlink)
    end
  end

  should "retrieve the gemspec" do
    assert_equal "test-theme-0.1.0", @theme.send(:gemspec).full_name
  end
end
