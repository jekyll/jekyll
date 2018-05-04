# frozen_string_literal: true

require "helper"

class TestLiveReloadTemplate < JekyllUnitTest
  context "rendering livereload script with different options" do
    context "with port only" do
      subject { LiveReloadTemplate.new("livereload_port" => 35_729) }

      should "return correct script" do
        assert_equal subject.template, <<-TEMPLATE
<script>
  document.write(
    '<script src=\"http://' +
    (location.host || 'localhost').split(':')[0] +
    ':35729/livereload.js?snipver=1&amp;port=35729\"' +
    '></' +
    'script>');
</script>
        TEMPLATE
      end
    end

    context "with all possible options" do
      subject do
        LiveReloadTemplate.new(
          "livereload_port"      => "35729",
          "livereload_min_delay" => "500",
          "livereload_max_delay" => "1000"
        )
      end

      should "return correct script" do
        assert_equal subject.template, <<-TEMPLATE
<script>
  document.write(
    '<script src=\"http://' +
    (location.host || 'localhost').split(':')[0] +
    ':35729/livereload.js?snipver=1&amp;mindelay=500&amp;maxdelay=1000&amp;port=35729\"' +
    '></' +
    'script>');
</script>
        TEMPLATE
      end
    end
  end
end
