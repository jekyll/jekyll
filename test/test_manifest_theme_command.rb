# frozen_string_literal: true

require "helper"
require "jekyll/commands/manifest_theme"

class TestManifestThemeCommand < JekyllUnitTest
  def create_manifest(overrides = {})
    capture_output { Jekyll::Commands::ManifestTheme.process(overrides) }
  end

  def manifest_file
    File.expand_path(".jtheme", source_dir)
  end

  def config
    {
      "theme" => "test-theme",
    }
  end

  context "Running the command 'manifest-theme'" do
    setup do
      @overrides = site_configuration(config)
    end

    teardown { FileUtils.rm_r manifest_file if File.exist?(manifest_file) }

    should "create a new manifest file from the theme-gem" do
      refute_exist manifest_file
      create_manifest @overrides
      assert_exist manifest_file
    end

    should "output a success message" do
      create_manifest @overrides
      output = Jekyll.logger.messages.last.strip
      assert_equal(
        output, "The manifest has been created at #{manifest_file.cyan}"
      )
    end
  end

  context "The generated manifest file" do
    teardown { FileUtils.rm_r manifest_file if File.exist?(manifest_file) }

    should "contain theme metadata" do
      create_manifest site_configuration(config)
      content = File.read(manifest_file)

      assert_includes content, <<-META.gsub(%r!^ {8}!, "")
        THEME NAME:
          test-theme

        THEME VERSION:
          0.1.0

      META
    end

    should "contain theme-gem contents" do
      create_manifest site_configuration(config)
      content = File.read(manifest_file)

      assert_includes content, <<-CONTENTS.gsub(%r!^ {8}!, "")


        GEM CONTENTS:

          ASSETS:
            * application.coffee
            * img/another-logo.png
            * img/logo.png
            * style.scss

          INCLUDES:
            * include.html

          LAYOUTS:
            * default.html

          SASS:
            * test-theme-black.scss
            * test-theme-red.scss

          FILES AT ROOT:
            * test-theme.gemspec
            * _symlink
      CONTENTS
    end
  end
end
