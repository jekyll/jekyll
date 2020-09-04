# frozen_string_literal: true

require "webrick"
require "helper"
require "net/http"

class TestCommandsServeServlet < JekyllUnitTest
  def get(path)
    TestWEBrick.mount_server do |_server, addr, port|
      http = Net::HTTP.new(addr, port)
      req = Net::HTTP::Get.new(path)

      http.request(req) { |response| yield(response) }
    end
  end

  context "with a directory and file with the same name" do
    should "find that file" do
      get("/bar/") do |response|
        assert_equal("200", response.code)
        assert_equal("Content of bar.html", response.body.strip)
      end
    end

    should "find file in directory" do
      get("/bar/baz") do |response|
        assert_equal("200", response.code)
        assert_equal("Content of baz.html", response.body.strip)
      end
    end

    should "return 404 for non-existing files" do
      get("/bar/missing") do |response|
        assert_equal("404", response.code)
      end
    end

    should "find xhtml file" do
      get("/bar/foo") do |response|
        assert_equal("200", response.code)
        assert_equal(
          '<html xmlns="http://www.w3.org/1999/xhtml">Content of foo.xhtml</html>',
          response.body.strip
        )
      end
    end
  end
end
