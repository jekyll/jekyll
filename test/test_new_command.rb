require 'helper'
require 'jekyll/commands/new'

class TestNewCommand < Test::Unit::TestCase
  context 'when args contains a site name' do
    setup do
      @site_name = 'new-site'
      @args = [@site_name]
      @site_path = File.expand_path(@site_name, Dir.pwd)
    end

    teardown do
      FileUtils.rm_r @site_path
    end

    should 'create a new directory' do
      assert !Dir.exists?(@site_name)
      capture_stdout { Jekyll::Commands::New.process(@args) }
      assert Dir.exists?(@site_name)
    end

    should 'display a success message' do
      output = capture_stdout { Jekyll::Commands::New.process(@args) }
      success_message = "New jekyll site installed in #{@site_path}.\n"
      assert_equal success_message, output
    end
  end

  context 'when multiple args are given' do
    setup do
      @site_name_with_spaces = 'new site name/with/paths'
      @multiple_args = @site_name_with_spaces.split
    end

    teardown do
      FileUtils.rm_r File.expand_path(@site_name_with_spaces, Dir.pwd)
    end

    should 'create a new directory' do
      assert !Dir.exists?(@site_name_with_spaces)
      capture_stdout { Jekyll::Commands::New.process(@multiple_args) }
      assert Dir.exists?(@site_name_with_spaces)
    end
  end

  context 'when no args are given' do
    setup do
      @empty_args = []
    end

    should 'output an error message' do
      output = capture_stdout { Jekyll::Commands::New.process(@empty_args) }
      error_message = "You must provide a path.\n"
      assert_equal error_message, output
    end
  end
end
