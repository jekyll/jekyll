require 'helper'

class TestCommand < Test::Unit::TestCase
  context "when calling .globs" do
    context "when non-default dest & source dirs" do
      setup do
        @source = source_dir
        @dest   = dest_dir
        @globs  = Command.globs(@source, @dest)
      end
      should "return an array without the destination dir" do
        assert @globs.is_a?(Array)
        assert !@globs.include?(@dest)
      end
    end
    context "when using default dest dir" do
      setup do
        @source = test_dir
        @dest   = test_dir('_site')
        FileUtils.mkdir(@dest)
        File.open("#{@dest}/index.html", "w"){ |f| f.write("I was previously generated.") }
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
end
