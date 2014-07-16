require 'helper'

class TestReader < Test::Unit::TestCase
  setup do
    @site = Site.new(Jekyll::Configuration::DEFAULTS.merge({
      'source' => source_dir,
      'destination' => dest_dir
    }))
    @reader = Reader.new(@site)
  end

  should "read pages with yaml front matter" do
    abs_path = File.expand_path("about.html", @site.source)
    assert_equal true, @reader.has_yaml_header?(abs_path)
  end

  should "enforce a strict 3-dash limit on the start of the YAML front-matter" do
    abs_path = File.expand_path("pgp.key", @site.source)
    assert_equal false, @reader.has_yaml_header?(abs_path)
  end

  should "read posts" do
    @reader.read_posts('')
    posts = Dir[source_dir('_posts', '**', '*')]
    posts.delete_if { |post| File.directory?(post) && !Post.valid?(post) }
    assert_equal posts.size - @num_invalid_posts, @site.posts.size
  end
end
