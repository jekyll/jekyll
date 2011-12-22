require 'helper'

class TestDefaultStructure < Test::Unit::TestCase
  context "generating default directory structure" do
    setup do
      clear_dest
      FileUtils.mkdir(dest_dir)
      stub(Jekyll).configuration do
        Jekyll::DEFAULTS.merge({'source'      => dest_dir,
                                'destination' => dest_dir("_site"),
                                'init'     => true})
      end

      @site = Site.new(Jekyll.configuration)
      @site.process
      @index = File.read(dest_dir("_site", 'index.html'))
    end

    should "have helpful message in index.html" do
      assert @index.include?("Welcome to Jekyll!")
    end

    should "have _config.yml" do
      assert File.exist?(dest_dir("_config.yml"))
    end

    should "have .gitignore" do
      assert File.exist?(dest_dir(".gitignore"))
    end

    should "have _includes directory" do
      assert File.directory?(dest_dir("_includes"))
    end

    should "have _layouts directory" do
      assert File.directory?(dest_dir("_layouts"))
    end

    should "have _plugins directory" do
      assert File.directory?(dest_dir("_plugins"))
    end

    should "have _posts directory" do
      assert File.directory?(dest_dir("_posts"))
    end
  end
end
