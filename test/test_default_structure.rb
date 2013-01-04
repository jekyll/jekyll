require 'helper'

class TestDefaultStructure < Test::Unit::TestCase
  context "generating default directory structure" do
    setup do
      clear_dest
      clear_empty
      FileUtils.mkdir(empty_dir)
      stub(Jekyll).configuration do
        Jekyll::DEFAULTS.merge({'source' => empty_dir, 'destination' => dest_dir})
      end
      Jekyll.init(empty_dir)
      @index = File.read(empty_dir("index.html"))
    end

    should "have helpful message in index.html" do
      assert @index.include?("Welcome to Jekyll!")
    end

    should "have _config.yml" do
      assert File.exist?(empty_dir("_config.yml"))
    end

    should "have _includes directory" do
      assert File.directory?(empty_dir("_includes"))
    end

    should "have _layouts directory" do
      assert File.directory?(empty_dir("_layouts"))
    end

    should "have _plugins directory" do
      assert File.directory?(empty_dir("_plugins"))
    end

    should "have _posts directory" do
      assert File.directory?(empty_dir("_posts"))
    end
  end
end
