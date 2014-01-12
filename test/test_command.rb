require 'helper'

class TestCommand < Test::Unit::TestCase
  context "when calling .globs" do
    context "when non-default dest & source dirs" do
      setup do
        @source = source_dir
        @dest   = dest_dir
        directory_with_contents(@dest)
        @globs  = Command.globs(@source, @dest)
      end
      should "return an array without the destination dir" do
        assert @globs.is_a?(Array)
        assert !@globs.include?(@dest)
      end
      teardown do
        clear_dest
      end
    end
    context "when using default dest dir" do
      setup do
        @source = test_dir
        @dest   = test_dir('_site')
        directory_with_contents(@dest)
        @globs  = Command.globs(@source, @dest)
      end
      should "return an array without the destination dir" do
        assert @globs.is_a?(Array)
        assert !@globs.include?(@dest)
        @globs.each do |glob|
           assert !glob.include?(File.basename(@dest))
        end
      end
      teardown do
        FileUtils.rm_r(@dest)
      end
    end
  end
  context "when calling serve with --clean" do
    should "clean up generated content" do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end
      site = Site.new(Jekyll.configuration)

      clear_dest
      StaticFile.reset_cache

      site.process
      capture_stdout { Jekyll::Commands::Serve.cleanup site.dest }

      assert !File.exist?(site.dest)
    end
  end
end
