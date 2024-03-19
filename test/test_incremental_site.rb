# frozen_string_literal: true

require "helper"

class TestIncrementalSite < JekyllUnitTest
  context "incremental build" do
    setup do
      @site = Jekyll::IncrementalSite.new(
        site_configuration(
          "incremental" => true
        )
      )
      @site.read
    end

    should "build incrementally" do
      contacts_html = @site.pages.find { |p| p.name == "contacts.html" }
      @site.process

      source = @site.in_source_dir(contacts_html.path)
      dest = File.expand_path(contacts_html.destination(@site.dest))
      mtime1 = File.stat(dest).mtime.to_i # first run must generate dest file

      # need to sleep because filesystem timestamps have best resolution in seconds
      sleep 1
      @site.process
      mtime2 = File.stat(dest).mtime.to_i
      assert_equal mtime1, mtime2 # no modifications, so remain the same

      # simulate file modification by user
      FileUtils.touch source

      sleep 1
      @site.process
      mtime3 = File.stat(dest).mtime.to_i
      refute_equal mtime2, mtime3 # must be regenerated

      sleep 1
      @site.process
      mtime4 = File.stat(dest).mtime.to_i
      assert_equal mtime3, mtime4 # no modifications, so remain the same
    end

    should "regenerate files that have had their destination deleted" do
      contacts_html = @site.pages.find { |p| p.name == "contacts.html" }
      @site.process

      dest = File.expand_path(contacts_html.destination(@site.dest))
      mtime1 = File.stat(dest).mtime.to_i # first run must generate dest file

      # simulate file modification by user
      File.unlink dest
      refute File.file?(dest)

      sleep 1 # sleep for 1 second, since mtimes have 1s resolution
      @site.process
      assert File.file?(dest)
      mtime2 = File.stat(dest).mtime.to_i
      refute_equal mtime1, mtime2 # must be regenerated
    end
  end
end
