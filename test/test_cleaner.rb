require 'helper'

class TestCleaner < Test::Unit::TestCase
  context "directory in keep_files" do
    setup do
      clear_dest
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end

      FileUtils.mkdir_p(dest_dir('to_keep/child_dir'))
      FileUtils.touch(dest_dir('to_keep', 'index.html'))
      FileUtils.touch(dest_dir('to_keep', 'child_dir', 'index.html'))

      @site = Site.new(Jekyll.configuration)
      @site.keep_files = ['to_keep/child_dir']

      @cleaner = Site::Cleaner.new(@site)
      @cleaner.cleanup!
    end

    teardown do
      FileUtils.rm_rf(dest_dir('to_keep'))
    end

    should "keep the parent directory" do
      assert File.exist?(dest_dir('to_keep'))
    end

    should "keep the child directory" do
      assert File.exist?(dest_dir('to_keep', 'child_dir'))
    end

    should "keep the file in the directory in keep_files" do
      assert File.exist?(dest_dir('to_keep', 'child_dir', 'index.html'))
    end

    should "delete the file in the directory not in keep_files" do
      assert !File.exist?(dest_dir('to_keep', 'index.html'))
    end
  end

  context "directory containing no files and non-empty directories" do
    setup do
      clear_dest
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end

      FileUtils.mkdir_p(source_dir('no_files_inside', 'child_dir'))
      FileUtils.touch(source_dir('no_files_inside', 'child_dir', 'index.html'))

      @site = Site.new(Jekyll.configuration)
      @site.process

      @cleaner = Site::Cleaner.new(@site)
      @cleaner.cleanup!
    end

    teardown do
      FileUtils.rm_rf(source_dir('no_files_inside'))
      FileUtils.rm_rf(dest_dir('no_files_inside'))
    end

    should "keep the parent directory" do
      assert File.exist?(dest_dir('no_files_inside'))
    end

    should "keep the child directory" do
      assert File.exist?(dest_dir('no_files_inside', 'child_dir'))
    end

    should "keep the file" do
      assert File.exist?(dest_dir('no_files_inside', 'child_dir', 'index.html'))
    end
  end
end
