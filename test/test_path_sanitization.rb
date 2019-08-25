# frozen_string_literal: true

require "helper"

class TestPathSanitization < JekyllUnitTest
  context "on Windows with absolute source" do
    setup do
      @source = "C:/Users/xmr/Desktop/mpc-hc.org"
      @dest   = "./_site/"
      allow(Dir).to receive(:pwd).and_return("C:/Users/xmr/Desktop/mpc-hc.org")
    end
    should "strip drive name from path" do
      assert_equal "C:/Users/xmr/Desktop/mpc-hc.org/_site",
                   Jekyll.sanitized_path(@source, @dest)
    end

    should "strip just the initial drive name" do
      assert_equal "/tmp/foobar/jail/..c:/..c:/..c:/etc/passwd",
                   Jekyll.sanitized_path("/tmp/foobar/jail", "..c:/..c:/..c:/etc/passwd")
    end
  end

  should "escape tilde" do
    assert_equal source_dir("~hi.txt"), Jekyll.sanitized_path(source_dir, "~hi.txt")
    assert_equal source_dir("files", "~hi.txt"),
                 Jekyll.sanitized_path(source_dir, "files/../files/~hi.txt")
  end

  should "remove path traversals" do
    assert_equal source_dir("files", "hi.txt"),
                 Jekyll.sanitized_path(source_dir, "f./../../../../../../files/hi.txt")
  end

  should "strip extra slashes in questionable path" do
    subdir = "/files/"
    file_path = "/hi.txt"
    assert_equal source_dir("files", "hi.txt"),
                 Jekyll.sanitized_path(source_dir, "/#{subdir}/#{file_path}")
  end

  if Jekyll::Utils::Platforms.really_windows?
    context "on Windows with absolute path" do
      setup do
        @base_path = "D:/demo"
        @file_path = "D:/demo/_site"
        allow(Dir).to receive(:pwd).and_return("D:/")
      end

      should "strip just the clean path drive name" do
        assert_equal "D:/demo/_site",
                     Jekyll.sanitized_path(@base_path, @file_path)
      end
    end

    context "on Windows with file path has matching prefix" do
      setup do
        @base_path = "D:/site"
        @file_path = "D:/sitemap.xml"
        allow(Dir).to receive(:pwd).and_return("D:/")
      end

      should "not strip base path" do
        assert_equal "D:/site/sitemap.xml",
                     Jekyll.sanitized_path(@base_path, @file_path)
      end
    end
  end

  should "not strip base path if file path has matching prefix" do
    assert_equal "/site/sitemap.xml",
                 Jekyll.sanitized_path("/site", "sitemap.xml")
  end
end
