require 'helper'

class TestSass < Test::Unit::TestCase
  context "converting sass" do
    setup do
      @content = <<-SASS
$font-stack: Helvetica, sans-serif
body
  font-family: $font-stack
  font-color: fuschia
SASS
      @output = <<-CSS
body {\n  font-family: Helvetica, sans-serif;\n  font-color: fuschia; }
CSS
    end
    should "produce CSS" do
      assert_equal @output, Jekyll::Sass.new.convert(@content)
    end
  end

  context "converting SCSS" do
    setup do
      @content = <<-SCSS
$font-stack: Helvetica, sans-serif;
body {
  font-family: $font-stack;
  font-color: fuschia;
}
SCSS
      @output = <<-CSS
body {\n  font-family: Helvetica, sans-serif;\n  font-color: fuschia; }
CSS
    end
    should "produce CSS" do
      assert_equal @output, Jekyll::Sass.new.convert(@content)
    end
  end
end
