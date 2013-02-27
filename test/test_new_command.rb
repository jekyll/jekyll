require 'helper'
require 'jekyll/commands/new'

class TestNewCommand < Test::Unit::TestCase
  def dir_contents(path)
    Dir["#{path}/**/*"].each do |file|
      file.gsub! path, ''
    end
  end

  context 'when args contains a path' do
    setup do
      @path = 'new-site'
      @args = [@path]
      @full_path = File.expand_path(@path, Dir.pwd)
    end

    teardown do
      FileUtils.rm_r @full_path
    end

    should 'create a new directory' do
      assert !File.exists?(@full_path)
      capture_stdout { Jekyll::Commands::New.process(@args) }
      assert File.exists?(@full_path)
    end

    should 'display a success message' do
      output = capture_stdout { Jekyll::Commands::New.process(@args) }
      success_message = "New jekyll site installed in #{@full_path}.\n"
      assert_equal success_message, output
    end

    should 'copy the site template to the new directory' do
      stubbed_date = "2013-01-01"
      stub.instance_of(Time).strftime { stubbed_date }

      site_template = File.expand_path("../lib/site_template", File.dirname(__FILE__))
      site_template_files = dir_contents(site_template).reject do |f|
        File.extname(f) == ".erb"
      end
      site_template_files << "/_posts/#{stubbed_date}-welcome-to-jekyll.markdown"

      capture_stdout { Jekyll::Commands::New.process(@args) }

      new_site_files = dir_contents(@full_path)

      assert_same_elements site_template_files, new_site_files
    end
  end

  context 'when multiple args are given' do
    setup do
      @site_name_with_spaces = 'new site name'
      @multiple_args = @site_name_with_spaces.split
    end

    teardown do
      FileUtils.rm_r File.expand_path(@site_name_with_spaces, Dir.pwd)
    end

    should 'create a new directory' do
      assert !File.exists?(@site_name_with_spaces)
      capture_stdout { Jekyll::Commands::New.process(@multiple_args) }
      assert File.exists?(@site_name_with_spaces)
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
