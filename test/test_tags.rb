require File.dirname(__FILE__) + '/helper'

class TestTags < Test::Unit::TestCase

  def create_post(content, override = {}, converter_class = Jekyll::MarkdownConverter)
    stub(Jekyll).configuration do
      Jekyll::DEFAULTS.merge({'pygments' => true}).merge(override)
    end
    site = Site.new(Jekyll.configuration)
    info = { :filters => [Jekyll::Filters], :registers => { :site => site } }
    @converter = site.converters.find { |c| c.class == converter_class }
    payload = { "pygments_prefix" => @converter.pygments_prefix,
                "pygments_suffix" => @converter.pygments_suffix }

    @result = Liquid::Template.parse(content).render(payload, info)
    @result = @converter.convert(@result)
  end

  def fill_post(code, override = {})
    content = <<CONTENT
---
title: This is a test
---

This document results in a markdown error with maruku

{% highlight text %}#{code}{% endhighlight %}
CONTENT
    create_post(content, override)
  end

  context "post content has highlight tag" do
    setup do
      fill_post("test")
    end

    should "not cause a markdown error" do
      assert_no_match /markdown\-html\-error/, @result
    end

    should "render markdown with pygments line handling" do
      assert_match %{<pre><code class='text'>test\n</code></pre>}, @result
    end
  end

  context "post content has highlight with file reference" do
    setup do
      fill_post("./jekyll.gemspec")
    end

    should "not embed the file" do
      assert_match %{<pre><code class='text'>./jekyll.gemspec\n</code></pre>}, @result
    end
  end

  context "post content has highlight tag with UTF character" do
    setup do
      fill_post("Æ")
    end

    should "render markdown with pygments line handling" do
      assert_match %{<pre><code class='text'>Æ\n</code></pre>}, @result
    end
  end

  context "simple post with markdown and pre tags" do
    setup do
      @content = <<CONTENT
---
title: Maruku vs. RDiscount
---

_FIGHT!_

{% highlight ruby %}
puts "3..2..1.."
{% endhighlight %}

*FINISH HIM*
CONTENT
    end

    context "using Textile" do
      setup do
        create_post(@content, {}, Jekyll::TextileConverter)
      end

      # Broken in RedCloth 4.1.9
      should "not textilize highlight block" do
        assert_no_match %r{3\.\.2\.\.1\.\.&quot;</span><br />}, @result
      end
    end

    context "using Maruku" do
      setup do
        create_post(@content)
      end

      should "parse correctly" do
        assert_match %r{<em>FIGHT!</em>}, @result
        assert_match %r{<em>FINISH HIM</em>}, @result
      end
    end

    context "using RDiscount" do
      setup do
        create_post(@content, 'markdown' => 'rdiscount')
      end

      should "parse correctly" do
        assert_match %r{<em>FIGHT!</em>}, @result
        assert_match %r{<em>FINISH HIM</em>}, @result
      end
    end

    context "using Kramdown" do
      setup do
        create_post(@content, 'markdown' => 'kramdown')
      end

      should "parse correctly" do
        assert_match %r{<em>FIGHT!</em>}, @result
        assert_match %r{<em>FINISH HIM</em>}, @result
      end
    end
  end

  context "simple post with gallery" do
    setup do
      Dir.chdir dest_dir
      FileUtils.mkdir_p 'gallery/img'
      FileUtils.touch ['alpha-beta', 'delta-gamma'].collect {|img| "gallery/img/20110401-#{img}.jpg"}
      FileUtils.touch "gallery/img/1984-01-01-wrong-format.gif"
      @content = <<CONTENT
---
title: Super simple image gallery
---

My awesome photo gallery, jpgs only:
{% gallery name:gallery %}
<img title="{{ file.title }}, taken on {{ file.date | date: "%F" }}" src="{{ file.path }}" />
{% endgallery %}

Oh, I have a gif, too:
{% gallery name:gallery format:gif %}
<img title="This ugly gif is from {{ file.date | date: "%Y" }}" src="{{ file.path }}" />
{% endgallery %}
CONTENT
    end

    should "parse correctly" do
      create_post(@content)
      assert_match %r{title='Alpha Beta, taken on 2011-04-01'}, @result
      assert_match %r{title='Delta Gamma, taken on 2011-04-01'}, @result
      assert_match %r{src='img/20110401-alpha-beta.jpg'}, @result
      assert_match %r{src='img/20110401-delta-gamma.jpg'}, @result
      assert_match %r{title='This ugly gif is from 1984'}, @result
      assert_no_match /I have a gif.*jpg/m, @result
      assert_no_match /gif.*I have a gif/m, @result
    end
  end
end
