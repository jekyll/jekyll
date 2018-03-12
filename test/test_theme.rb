# frozen_string_literal: true

require "helper"

class TestTheme < JekyllUnitTest
  def setup
    @theme = Theme.new("test-theme")
  end

  context "initializing" do
    should "normalize the theme name" do
      theme = Theme.new(" Test-Theme ")
      assert_equal "test-theme", theme.name
    end

    should "know the theme root" do
      assert_equal theme_dir, @theme.root
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
        expected = theme_dir(folder.to_s)
        assert_equal expected, @theme.public_send("#{folder.to_s.tr("_", "")}_path")
      end
    end

    should "generate folder paths" do
      expected = theme_dir("_sass")
      assert_equal expected, @theme.send(:path_for, :_sass)
    end

    should "not allow paths outside of the theme root" do
      assert_nil @theme.send(:path_for, "../../source")
    end

    should "return nil for paths that don't exist" do
      assert_nil @theme.send(:path_for, "foo")
    end

    should "return the resolved path when a symlink & resolved path exists" do
      # no support for symlinks on Windows
      skip_if_windows "Jekyll does not currently support symlinks on Windows."

      expected = theme_dir("_layouts")
      assert_equal expected, @theme.send(:path_for, :_symlink)
    end
  end

  context "invalid theme" do
    context "initializing" do
      setup do
        stub_gemspec = Object.new

        # the directory for this theme should not exist
        allow(stub_gemspec).to receive(:full_gem_path)
          .and_return(File.expand_path("test/fixtures/test-non-existent-theme", __dir__))

        allow(Gem::Specification).to receive(:find_by_name)
          .with("test-non-existent-theme")
          .and_return(stub_gemspec)
      end

      should "raise when getting theme root" do
        error = assert_raises(RuntimeError) { Theme.new("test-non-existent-theme") }
        assert_match(%r!fixtures\/test-non-existent-theme does not exist!, error.message)
      end
    end
  end

  should "retrieve the gemspec" do
    assert_equal "test-theme-0.1.0", @theme.send(:gemspec).full_name
  end
end
