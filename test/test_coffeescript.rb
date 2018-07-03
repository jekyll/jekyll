# frozen_string_literal: true

require "helper"

class TestCoffeeScript < JekyllUnitTest
  context "converting CoffeeScript" do
    setup do
      External.require_with_graceful_fail("jekyll-coffeescript")
      @site = fixture_site
      @site.process
      @test_coffeescript_file = dest_dir("js/coffeescript.js")
      @js_output = <<-JS
(function() {
  $(function() {
    var cube, cubes, list, num, square;
    list = [1, 2, 3, 4, 5];
    square = function(x) {
      return x * x;
    };
    cube = function(x) {
      return square(x) * x;
    };
    cubes = (function() {
      var i, len, results;
      results = [];
      for (i = 0, len = list.length; i < len; i++) {
        num = list[i];
        results.push(math.cube(num));
      }
      return results;
    })();
    if (typeof elvis !== "undefined" && elvis !== null) {
      return alert("I knew it!");
    }
  });

}).call(this);
JS
    end

    should "write a JS file in place" do
      assert_exist @test_coffeescript_file
    end

    should "produce JS" do
      assert_equal @js_output, File.read(@test_coffeescript_file)
    end
  end
end
