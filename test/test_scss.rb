require 'helper'

class TestSass < Test::Unit::TestCase
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
      assert_equal @output, Jekyll::Scss.new.convert(@content)
    end
  end
end
