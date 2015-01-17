require 'helper'

class TestCoffeeScript < Test::Unit::TestCase
  context "converting CoffeeScript" do
    setup do
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
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        num = list[_i];
        _results.push(math.cube(num));
      }
      return _results;
    })();
    if (typeof elvis !== \"undefined\" && elvis !== null) {
      return alert(\"I knew it!\");
    }
  });

}).call(this);
JS
    end

    should "write a JS file in place" do
      assert File.exist?(@test_coffeescript_file), "Can't find the converted CoffeeScript file in the dest_dir."
    end

    should "produce JS" do
      assert_equal @js_output, File.read(@test_coffeescript_file)
    end
  end
end
