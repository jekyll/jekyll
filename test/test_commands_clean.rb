# frozen_string_literal: true

require "mercenary"
require "helper"
require "tmpdir"

class TestCommandsClean < JekyllUnitTest
  context "cleaning destination" do
    setup do
      @merc = nil
      @cmd = Jekyll::Commands::Clean
      Mercenary.program(:jekyll) do |p|
        @merc = @cmd.init_with_program(
          p
        )
      end

      @temp_dir = Dir.mktmpdir("jekyll_clean_test")
      @destination = File.join(@temp_dir, "_site")
      Dir.mkdir(@destination) || flunk("Could not make directory #{@destination}")
      @standard_options = {
        "port"        => 4000,
        "host"        => "localhost",
        "baseurl"     => "",
        "detach"      => false,
        "source"      => @temp_dir,
        "destination" => @destination,
      }

      simple_page = <<-HTML.gsub(%r!^\s*!, "")
      <!DOCTYPE HTML>
      <html lang="en-US">
      <head>
        <meta charset="UTF-8">
        <title>Hello World</title>
      </head>
      <body>
        <p>Hello!  I am a simple web page.</p>
      </body>
      </html>
      HTML

      File.write(File.join(@destination, "hello.html"), simple_page)

      @site = instance_double(Jekyll::Site, :jekyll_site)
      allow(Jekyll::Site).to receive(:new).and_return(@site)
    end

    teardown do
      FileUtils.remove_entry_secure(@temp_dir, true)
    end

    should "call Site#cleanup" do
      expect(@site).to receive(:cleanup)
      @merc.execute(:clean, @standard_options)
    end

    context "with the keep_files option" do
      setup do
        @standard_options["keep_files"] = %w(keep)
        @keep_dir = File.join(@temp_dir, "_site/keep")

        keep_page = <<-HTML.gsub(%r!^\s*!, "")
        <!DOCTYPE HTML>
        <html lang="en-US">
        <head>
          <meta charset="UTF-8">
          <title>Page to Keep</title>
        </head>
        <body>
          <p>This page is to keep.</p>
        </body>
        </html>
        HTML

        Dir.mkdir(@keep_dir) || flunk("Could not make directory #{@keep_dir}")
        File.write(File.join(@keep_dir, "keep.html"), keep_page)

        allow(Jekyll::Site).to receive(:new).and_call_original
      end

      should "keep the specified files and directories" do
        @merc.execute(:clean, @standard_options)
        assert_path_exists(File.join(@keep_dir, "keep.html"))
      end
    end
  end
end
