# frozen_string_literal: true

require "helper"

class TestTags < JekyllUnitTest
  def setup
    FileUtils.mkdir_p("tmp")
  end

  # rubocop:disable Metrics/AbcSize
  def create_post(content, override = {}, converter_class = Jekyll::Converters::Markdown)
    site = fixture_site({ "highlighter" => "rouge" }.merge(override))

    site.posts.docs.concat(PostReader.new(site).read_posts("")) if override["read_posts"]
    CollectionReader.new(site).read if override["read_collections"]
    site.read if override["read_all"]

    info = { :filters => [Jekyll::Filters], :registers => { :site => site } }
    @converter = site.converters.find { |c| c.class == converter_class }
    payload = { "highlighter_prefix" => @converter.highlighter_prefix,
                "highlighter_suffix" => @converter.highlighter_suffix, }

    @result = Liquid::Template.parse(content).render!(payload, info)
    @result = @converter.convert(@result)
  end
  # rubocop:enable Metrics/AbcSize

  def fill_post(code, override = {})
    content = <<CONTENT
---
title: This is a test
---

This document has some highlighted code in it.

{% highlight text %}
#{code}
{% endhighlight %}
{% highlight text linenos %}
#{code}
{% endhighlight %}
CONTENT
    create_post(content, override)
  end

  def highlight_block_with_opts(options_string)
    Jekyll::Tags::HighlightBlock.parse(
      "highlight",
      options_string,
      Liquid::Tokenizer.new("test{% endhighlight %}\n"),
      Liquid::ParseContext.new
    )
  end

  context "language name" do
    should "match only the required set of chars" do
      r = Jekyll::Tags::HighlightBlock::SYNTAX
      assert_match r, "ruby"
      assert_match r, "c#"
      assert_match r, "xml+cheetah"
      assert_match r, "x.y"
      assert_match r, "coffee-script"
      assert_match r, "shell_session"

      refute_match r, "blah^"

      assert_match r, "ruby key=val"
      assert_match r, "ruby a=b c=d"
    end
  end

  context "highlight tag in unsafe mode" do
    should "set the no options with just a language name" do
      tag = highlight_block_with_opts("ruby ")
      assert_equal({}, tag.instance_variable_get(:@highlight_options))
    end

    should "set the linenos option as 'inline' if no linenos value" do
      tag = highlight_block_with_opts("ruby linenos ")
      assert_equal(
        { :linenos => "inline" },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "set the linenos option to 'table' " \
           "if the linenos key is given the table value" do
      tag = highlight_block_with_opts("ruby linenos=table ")
      assert_equal(
        { :linenos => "table" },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "recognize nowrap option with linenos set" do
      tag = highlight_block_with_opts("ruby linenos=table nowrap ")
      assert_equal(
        { :linenos => "table", :nowrap => true },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "recognize the cssclass option" do
      tag = highlight_block_with_opts("ruby linenos=table cssclass=hl ")
      assert_equal(
        { :cssclass => "hl", :linenos => "table" },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "recognize the hl_linenos option and its value" do
      tag = highlight_block_with_opts("ruby linenos=table cssclass=hl hl_linenos=3 ")
      assert_equal(
        { :cssclass => "hl", :linenos => "table", :hl_linenos => "3" },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "recognize multiple values of hl_linenos" do
      tag = highlight_block_with_opts 'ruby linenos=table cssclass=hl hl_linenos="3 5 6" '
      assert_equal(
        { :cssclass => "hl", :linenos => "table", :hl_linenos => %w(3 5 6) },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "treat language name as case insensitive" do
      tag = highlight_block_with_opts("Ruby ")
      assert_equal(
        "ruby",
        tag.instance_variable_get(:@lang),
        "lexers should be case insensitive"
      )
    end
  end

  context "in safe mode" do
    setup do
      @tag = highlight_block_with_opts("text ")
    end

    should "allow linenos" do
      sanitized = @tag.sanitized_opts({ :linenos => true }, true)
      assert_equal true, sanitized[:linenos]
    end

    should "allow hl_lines" do
      sanitized = @tag.sanitized_opts({ :hl_lines => %w(1 2 3 4) }, true)
      assert_equal %w(1 2 3 4), sanitized[:hl_lines]
    end

    should "allow cssclass" do
      sanitized = @tag.sanitized_opts({ :cssclass => "ahoy" }, true)
      assert_equal "ahoy", sanitized[:cssclass]
    end

    should "allow startinline" do
      sanitized = @tag.sanitized_opts({ :startinline => true }, true)
      assert_equal true, sanitized[:startinline]
    end

    should "strip unknown options" do
      sanitized = @tag.sanitized_opts({ :light => true }, true)
      assert_nil sanitized[:light]
    end
  end

  context "with the pygments highlighter" do
    setup do
      if jruby?
        then skip(
          "JRuby does not support Pygments."
        )
      end
    end

    context "post content has highlight tag" do
      setup do
        fill_post("test", { "highlighter" => "pygments" })
      end

      should "not cause a markdown error" do
        refute_match(%r!markdown\-html\-error!, @result)
      end

      should "render markdown with pygments" do
        assert_match(
          %(<pre><code class="language-text" data-lang="text">) +
          %(<span></span>test</code></pre>),
          @result
        )
      end

      should "render markdown with pygments with line numbers" do
        assert_match(
          %(<pre><code class="language-text" data-lang="text">) +
          %(<span></span><span class="lineno">1 </span>test</code></pre>),
          @result
        )
      end
    end

    context "post content has highlight with file reference" do
      setup do
        fill_post("./jekyll.gemspec", { "highlighter" => "pygments" })
      end

      should "not embed the file" do
        assert_match(
          %(<pre><code class="language-text" data-lang="text"><span></span>) +
          %(./jekyll.gemspec</code></pre>),
          @result
        )
      end
    end

    context "post content has highlight tag with UTF character" do
      setup do
        fill_post("Æ", { "highlighter" => "pygments" })
      end

      should "render markdown with pygments line handling" do
        assert_match(
          %(<pre><code class="language-text" data-lang="text">) +
          %(<span></span>Æ</code></pre>),
          @result
        )
      end
    end

    context "post content has highlight tag with preceding spaces & lines" do
      setup do
        code = <<-EOS


     [,1] [,2]
[1,] FALSE TRUE
[2,] FALSE TRUE
EOS
        fill_post(code, { "highlighter" => "pygments" })
      end

      should "only strip the preceding newlines" do
        assert_match(
          %(<pre><code class=\"language-text\" data-lang=\"text\">) +
          %(<span></span>     [,1] [,2]),
          @result
        )
      end
    end

    context "post content has highlight tag " \
            "with preceding spaces & lines in several places" do
      setup do
        code = <<-EOS


     [,1] [,2]


[1,] FALSE TRUE
[2,] FALSE TRUE


EOS
        fill_post(code, { "highlighter" => "pygments" })
      end

      should "only strip the newlines which precede and succeed the entire block" do
        assert_match(
          %(<pre><code class=\"language-text\" data-lang=\"text\"><span></span>) +
          %(     [,1] [,2]\n\n\n[1,] FALSE TRUE\n[2,] FALSE TRUE</code></pre>),
          @result
        )
      end
    end

    context "post content has highlight tag with " \
            "preceding spaces & Windows-style newlines" do
      setup do
        fill_post "\r\n\r\n\r\n     [,1] [,2]", { "highlighter" => "pygments" }
      end

      should "only strip the preceding newlines" do
        assert_match(
          %(<pre><code class="language-text" data-lang="text"><span></span>) +
          %(     [,1] [,2]),
          @result
        )
      end
    end

    context "post content has highlight tag with only preceding spaces" do
      setup do
        code = <<-EOS
     [,1] [,2]
[1,] FALSE TRUE
[2,] FALSE TRUE
EOS
        fill_post(code, { "highlighter" => "pygments" })
      end

      should "only strip the preceding newlines" do
        assert_match(
          %(<pre><code class=\"language-text\" data-lang=\"text\"><span></span>) +
          %(     [,1] [,2]),
          @result
        )
      end
    end
  end

  context "with the rouge highlighter" do
    context "post content has highlight tag" do
      setup do
        fill_post("test")
      end

      should "render markdown with rouge" do
        assert_match(
          %(<pre><code class="language-text" data-lang="text">test</code></pre>),
          @result
        )
      end

      should "render markdown with rouge 2 with line numbers" do
        skip "Skipped because using an older version of Rouge" if Utils::Rouge.old_api?
        assert_match(
          %(<table class="rouge-table"><tbody>) +
            %(<tr><td class="gutter gl">) +
            %(<pre class="lineno">1\n</pre></td>) +
            %(<td class="code"><pre>test</pre></td></tr>) +
            %(</tbody></table>),
          @result
        )
      end

      should "render markdown with rouge 1 with line numbers" do
        skip "Skipped because using a newer version of Rouge" unless Utils::Rouge.old_api?
        assert_match(
          %(<table style="border-spacing: 0"><tbody>) +
            %(<tr><td class="gutter gl" style="text-align: right">) +
            %(<pre class="lineno">1</pre></td>) +
            %(<td class="code"><pre>test<span class="w">\n</span></pre></td></tr>) +
            %(</tbody></table>),
          @result
        )
      end
    end

    context "post content has raw tag" do
      setup do
        content = <<-CONTENT
---
title: This is a test
---

```liquid
{% raw %}
{{ site.baseurl }}{% link _collection/name-of-document.md %}
{% endraw %}
```
CONTENT
        create_post(content)
      end

      should "render markdown with rouge 1" do
        skip "Skipped because using a newer version of Rouge" unless Utils::Rouge.old_api?

        assert_match(
          %(<div class="language-liquid highlighter-rouge"><pre class="highlight"><code>),
          @result
        )
      end

      should "render markdown with rouge 2" do
        skip "Skipped because using an older version of Rouge" if Utils::Rouge.old_api?

        assert_match(
          %(<div class="language-liquid highlighter-rouge">) +
            %(<div class="highlight"><pre class="highlight"><code>),
          @result
        )
      end
    end

    context "post content has highlight with file reference" do
      setup do
        fill_post("./jekyll.gemspec")
      end

      should "not embed the file" do
        assert_match(
          '<pre><code class="language-text" data-lang="text">' \
          "./jekyll.gemspec</code></pre>",
          @result
        )
      end
    end

    context "post content has highlight tag with UTF character" do
      setup do
        fill_post("Æ")
      end

      should "render markdown with pygments line handling" do
        assert_match(
          '<pre><code class="language-text" data-lang="text">Æ</code></pre>',
          @result
        )
      end
    end

    context "post content has highlight tag with preceding spaces & lines" do
      setup do
        fill_post <<-EOS


     [,1] [,2]
[1,] FALSE TRUE
[2,] FALSE TRUE
EOS
      end

      should "only strip the preceding newlines" do
        assert_match(
          '<pre><code class="language-text" data-lang="text">     [,1] [,2]',
          @result
        )
      end
    end

    context "post content has highlight tag with " \
            "preceding spaces & lines in several places" do
      setup do
        fill_post <<-EOS


     [,1] [,2]


[1,] FALSE TRUE
[2,] FALSE TRUE


EOS
      end

      should "only strip the newlines which precede and succeed the entire block" do
        assert_match(
          "<pre><code class=\"language-text\" data-lang=\"text\">     [,1] [,2]\n\n\n" \
          "[1,] FALSE TRUE\n[2,] FALSE TRUE</code></pre>",
          @result
        )
      end
    end

    context "post content has highlight tag with linenumbers" do
      setup do
        create_post <<-EOS
---
title: This is a test
---

This is not yet highlighted
{% highlight php linenos %}
test
{% endhighlight %}

This should not be highlighted, right?
EOS
      end

      should "should stop highlighting at boundary with rouge 2" do
        skip "Skipped because using an older version of Rouge" if Utils::Rouge.old_api?
        expected = <<-EOS
<p>This is not yet highlighted</p>\n
<figure class="highlight"><pre><code class="language-php" data-lang="php"><table class="rouge-table"><tbody><tr><td class="gutter gl"><pre class="lineno">1
</pre></td><td class="code"><pre><span class="nx">test</span></pre></td></tr></tbody></table></code></pre></figure>\n
<p>This should not be highlighted, right?</p>
EOS
        assert_match(expected, @result)
      end

      should "should stop highlighting at boundary with rouge 1" do
        skip "Skipped because using a newer version of Rouge" unless Utils::Rouge.old_api?
        expected = <<-EOS
<p>This is not yet highlighted</p>\n
<figure class="highlight"><pre><code class="language-php" data-lang="php"><table style="border-spacing: 0"><tbody><tr><td class="gutter gl" style="text-align: right"><pre class="lineno">1</pre></td><td class="code"><pre>test<span class="w">
</span></pre></td></tr></tbody></table></code></pre></figure>\n
<p>This should not be highlighted, right?</p>
EOS
        assert_match(expected, @result)
      end
    end

    context "post content has highlight tag with " \
            "preceding spaces & Windows-style newlines" do
      setup do
        fill_post "\r\n\r\n\r\n     [,1] [,2]"
      end

      should "only strip the preceding newlines" do
        assert_match(
          '<pre><code class="language-text" data-lang="text">     [,1] [,2]',
          @result
        )
      end
    end

    context "post content has highlight tag with only preceding spaces" do
      setup do
        fill_post <<-EOS
     [,1] [,2]
[1,] FALSE TRUE
[2,] FALSE TRUE
EOS
      end

      should "only strip the preceding newlines" do
        assert_match(
          '<pre><code class="language-text" data-lang="text">     [,1] [,2]',
          @result
        )
      end
    end
  end

  context "simple post with markdown and pre tags" do
    setup do
      @content = <<CONTENT
---
title: Kramdown vs. RDiscount vs. Redcarpet
---

_FIGHT!_

{% highlight ruby %}
puts "3..2..1.."
{% endhighlight %}

*FINISH HIM*
CONTENT
    end

    context "using RDiscount" do
      setup do
        if jruby?
          then skip(
            "JRuby does not perform well with CExt, test disabled."
          )
        end

        create_post(@content, {
          "markdown" => "rdiscount",
        })
      end

      should "parse correctly" do
        assert_match %r{<em>FIGHT!</em>}, @result
        assert_match %r!<em>FINISH HIM</em>!, @result
      end
    end

    context "using Kramdown" do
      setup do
        create_post(@content, "markdown" => "kramdown")
      end

      should "parse correctly" do
        assert_match %r{<em>FIGHT!</em>}, @result
        assert_match %r!<em>FINISH HIM</em>!, @result
      end
    end

    context "using Redcarpet" do
      setup do
        if jruby?
          skip(
            "JRuby does not perform well with CExt, test disabled."
          )
        end

        create_post(@content, {
          "markdown" => "redcarpet",
        })
      end

      should "parse correctly" do
        assert_match %r{<em>FIGHT!</em>}, @result
        assert_match %r!<em>FINISH HIM</em>!, @result
      end
    end
  end

  context "simple page with post linking" do
    setup do
      content = <<CONTENT
---
title: Post linking
---

{% post_url 2008-11-21-complex %}
CONTENT
      create_post(content, {
        "permalink"   => "pretty",
        "source"      => source_dir,
        "destination" => dest_dir,
        "read_posts"  => true,
      })
    end

    should "not cause an error" do
      refute_match(%r!markdown\-html\-error!, @result)
    end

    should "have the URL to the 'complex' post from 2008-11-21" do
      assert_match %r!/2008/11/21/complex/!, @result
    end
  end

  context "simple page with post linking containing special characters" do
    setup do
      content = <<CONTENT
---
title: Post linking
---

{% post_url 2016-11-26-special-chars-(+) %}
CONTENT
      create_post(content, {
        "permalink"   => "pretty",
        "source"      => source_dir,
        "destination" => dest_dir,
        "read_posts"  => true,
      })
    end

    should "not cause an error" do
      refute_match(%r!markdown\-html\-error!, @result)
    end

    should "have the URL to the 'special-chars' post from 2016-11-26" do
      assert_match %r!/2016/11/26/special-chars-\(\+\)/!, @result
    end
  end

  context "simple page with nested post linking" do
    setup do
      content = <<CONTENT
---
title: Post linking
---

- 1 {% post_url 2008-11-21-complex %}
- 2 {% post_url /2008-11-21-complex %}
- 3 {% post_url es/2008-11-21-nested %}
- 4 {% post_url /es/2008-11-21-nested %}
CONTENT
      create_post(content, {
        "permalink"   => "pretty",
        "source"      => source_dir,
        "destination" => dest_dir,
        "read_posts"  => true,
      })
    end

    should "not cause an error" do
      refute_match(%r!markdown\-html\-error!, @result)
    end

    should "have the URL to the 'complex' post from 2008-11-21" do
      assert_match %r!1\s/2008/11/21/complex/!, @result
      assert_match %r!2\s/2008/11/21/complex/!, @result
    end

    should "have the URL to the 'nested' post from 2008-11-21" do
      assert_match %r!3\s/2008/11/21/nested/!, @result
      assert_match %r!4\s/2008/11/21/nested/!, @result
    end
  end

  context "simple page with nested post linking and path not used in `post_url`" do
    setup do
      content = <<CONTENT
---
title: Deprecated Post linking
---

- 1 {% post_url 2008-11-21-nested %}
CONTENT
      create_post(content, {
        "permalink"   => "pretty",
        "source"      => source_dir,
        "destination" => dest_dir,
        "read_posts"  => true,
      })
    end

    should "not cause an error" do
      refute_match(%r!markdown\-html\-error!, @result)
    end

    should "have the url to the 'nested' post from 2008-11-21" do
      assert_match %r!1\s/2008/11/21/nested/!, @result
    end

    should "throw a deprecation warning" do
      deprecation_warning = "       Deprecation: A call to "\
        "'{% post_url 2008-11-21-nested %}' did not match a post using the new matching "\
        "method of checking name (path-date-slug) equality. Please make sure that you "\
        "change this tag to match the post's name exactly."
      assert_includes Jekyll.logger.messages, deprecation_warning
    end
  end

  context "simple page with invalid post name linking" do
    should "cause an error" do
      content = <<CONTENT
---
title: Invalid post name linking
---

{% post_url abc2008-11-21-complex %}
CONTENT

      assert_raises Jekyll::Errors::PostURLError do
        create_post(content, {
          "permalink"   => "pretty",
          "source"      => source_dir,
          "destination" => dest_dir,
          "read_posts"  => true,
        })
      end
    end

    should "cause an error with a bad date" do
      content = <<CONTENT
---
title: Invalid post name linking
---

{% post_url 2008-42-21-complex %}
CONTENT

      assert_raises Jekyll::Errors::InvalidDateError do
        create_post(content, {
          "permalink"   => "pretty",
          "source"      => source_dir,
          "destination" => dest_dir,
          "read_posts"  => true,
        })
      end
    end
  end

  context "simple page with linking to a page" do
    setup do
      content = <<CONTENT
---
title: linking
---

{% link contacts.html %}
{% link info.md %}
{% link /css/screen.css %}
CONTENT
      create_post(content, {
        "source"      => source_dir,
        "destination" => dest_dir,
        "read_all"    => true,
      })
    end

    should "not cause an error" do
      refute_match(%r!markdown\-html\-error!, @result)
    end

    should "have the URL to the 'contacts' item" do
      assert_match(%r!/contacts\.html!, @result)
    end

    should "have the URL to the 'info' item" do
      assert_match(%r!/info\.html!, @result)
    end

    should "have the URL to the 'screen.css' item" do
      assert_match(%r!/css/screen\.css!, @result)
    end
  end

  context "simple page with linking" do
    setup do
      content = <<CONTENT
---
title: linking
---

{% link _methods/yaml_with_dots.md %}
CONTENT
      create_post(content, {
        "source"           => source_dir,
        "destination"      => dest_dir,
        "collections"      => { "methods" => { "output" => true } },
        "read_collections" => true,
      })
    end

    should "not cause an error" do
      refute_match(%r!markdown\-html\-error!, @result)
    end

    should "have the URL to the 'yaml_with_dots' item" do
      assert_match(%r!/methods/yaml_with_dots\.html!, @result)
    end
  end

  context "simple page with nested linking" do
    setup do
      content = <<CONTENT
---
title: linking
---

- 1 {% link _methods/sanitized_path.md %}
- 2 {% link _methods/site/generate.md %}
CONTENT
      create_post(content, {
        "source"           => source_dir,
        "destination"      => dest_dir,
        "collections"      => { "methods" => { "output" => true } },
        "read_collections" => true,
      })
    end

    should "not cause an error" do
      refute_match(%r!markdown\-html\-error!, @result)
    end

    should "have the URL to the 'sanitized_path' item" do
      assert_match %r!1\s/methods/sanitized_path\.html!, @result
    end

    should "have the URL to the 'site/generate' item" do
      assert_match %r!2\s/methods/site/generate\.html!, @result
    end
  end

  context "simple page with invalid linking" do
    should "cause an error" do
      content = <<CONTENT
---
title: Invalid linking
---

{% link non-existent-collection-item %}
CONTENT

      assert_raises ArgumentError do
        create_post(content, {
          "source"           => source_dir,
          "destination"      => dest_dir,
          "collections"      => { "methods" => { "output" => true } },
          "read_collections" => true,
        })
      end
    end
  end

  context "include tag with parameters" do
    context "with symlink'd include" do
      should "not allow symlink includes" do
        File.open("tmp/pages-test", "w") { |file| file.write("SYMLINK TEST") }
        assert_raises IOError do
          content = <<CONTENT
---
title: Include symlink
---

{% include tmp/pages-test %}

CONTENT
          create_post(content, {
            "permalink"   => "pretty",
            "source"      => source_dir,
            "destination" => dest_dir,
            "read_posts"  => true,
            "safe"        => true,
          })
        end
        @result ||= ""
        refute_match(%r!SYMLINK TEST!, @result)
      end

      should "not expose the existence of symlinked files" do
        ex = assert_raises IOError do
          content = <<CONTENT
---
title: Include symlink
---

{% include tmp/pages-test-does-not-exist %}

CONTENT
          create_post(content, {
            "permalink"   => "pretty",
            "source"      => source_dir,
            "destination" => dest_dir,
            "read_posts"  => true,
            "safe"        => true,
          })
        end
        assert_match(
          "Could not locate the included file 'tmp/pages-test-does-not-exist' " \
          "in any of [\"#{source_dir}/_includes\"]. Ensure it exists in one of " \
          "those directories and is not a symlink as those are not allowed in " \
          "safe mode.",
          ex.message
        )
      end
    end

    context "with one parameter" do
      setup do
        content = <<CONTENT
---
title: Include tag parameters
---

{% include sig.markdown myparam="test" %}

{% include params.html param="value" %}
CONTENT
        create_post(content, {
          "permalink"   => "pretty",
          "source"      => source_dir,
          "destination" => dest_dir,
          "read_posts"  => true,
        })
      end

      should "correctly output include variable" do
        assert_match "<span id=\"include-param\">value</span>", @result.strip
      end

      should "ignore parameters if unused" do
        assert_match "<hr />\n<p>Tom Preston-Werner\ngithub.com/mojombo</p>\n", @result
      end
    end

    context "with invalid parameter syntax" do
      should "throw a ArgumentError" do
        content = <<CONTENT
---
title: Invalid parameter syntax
---

{% include params.html param s="value" %}
CONTENT
        assert_raises ArgumentError, "Did not raise exception on invalid " \
                                     '"include" syntax' do
          create_post(content, {
            "permalink"   => "pretty",
            "source"      => source_dir,
            "destination" => dest_dir,
            "read_posts"  => true,
          })
        end

        content = <<CONTENT
---
title: Invalid parameter syntax
---

{% include params.html params="value %}
CONTENT
        assert_raises ArgumentError, "Did not raise exception on invalid " \
                                     '"include" syntax' do
          create_post(content, {
            "permalink"   => "pretty",
            "source"      => source_dir,
            "destination" => dest_dir,
            "read_posts"  => true,
          })
        end
      end
    end

    context "with several parameters" do
      setup do
        content = <<CONTENT
---
title: multiple include parameters
---

{% include params.html param1="new_value" param2="another" %}
CONTENT
        create_post(content, {
          "permalink"   => "pretty",
          "source"      => source_dir,
          "destination" => dest_dir,
          "read_posts"  => true,
        })
      end

      should "list all parameters" do
        assert_match "<li>param1 = new_value</li>", @result
        assert_match "<li>param2 = another</li>", @result
      end

      should "not include previously used parameters" do
        assert_match "<span id=\"include-param\"></span>", @result
      end
    end

    context "without parameters" do
      setup do
        content = <<CONTENT
---
title: without parameters
---

{% include params.html %}
CONTENT
        create_post(content, {
          "permalink"   => "pretty",
          "source"      => source_dir,
          "destination" => dest_dir,
          "read_posts"  => true,
        })
      end

      should "include file with empty parameters" do
        assert_match "<span id=\"include-param\"></span>", @result
      end
    end

    context "with custom includes directory" do
      setup do
        content = <<CONTENT
---
title: custom includes directory
---

{% include custom.html %}
CONTENT
        create_post(content, {
          "includes_dir" => "_includes_custom",
          "permalink"    => "pretty",
          "source"       => source_dir,
          "destination"  => dest_dir,
          "read_posts"   => true,
        })
      end

      should "include file from custom directory" do
        assert_match "custom_included", @result
      end
    end

    context "without parameters within if statement" do
      setup do
        content = <<CONTENT
---
title: without parameters within if statement
---

{% if true %}{% include params.html %}{% endif %}
CONTENT
        create_post(content, {
          "permalink"   => "pretty",
          "source"      => source_dir,
          "destination" => dest_dir,
          "read_posts"  => true,
        })
      end

      should "include file with empty parameters within if statement" do
        assert_match "<span id=\"include-param\"></span>", @result
      end
    end

    context "include missing file" do
      setup do
        @content = <<CONTENT
---
title: missing file
---

{% include missing.html %}
CONTENT
      end

      should "raise error relative to source directory" do
        exception = assert_raises IOError do
          create_post(@content, {
            "permalink"   => "pretty",
            "source"      => source_dir,
            "destination" => dest_dir,
            "read_posts"  => true,
          })
        end
        assert_match(
          "Could not locate the included file 'missing.html' in any of " \
          "[\"#{source_dir}/_includes\"].",
          exception.message
        )
      end
    end

    context "include tag with variable and liquid filters" do
      setup do
        site = fixture_site({ "pygments" => true }).tap(&:read).tap(&:render)
        post = site.posts.docs.find do |p|
          p.basename.eql? "2013-12-17-include-variable-filters.markdown"
        end
        @content = post.output
      end

      should "include file as variable with liquid filters" do
        assert_match(%r!1 included!, @content)
        assert_match(%r!2 included!, @content)
        assert_match(%r!3 included!, @content)
      end

      should "include file as variable and liquid filters with arbitrary whitespace" do
        assert_match(%r!4 included!, @content)
        assert_match(%r!5 included!, @content)
        assert_match(%r!6 included!, @content)
      end

      should "include file as variable and filters with additional parameters" do
        assert_match("<li>var1 = foo</li>", @content)
        assert_match("<li>var2 = bar</li>", @content)
      end

      should "include file as partial variable" do
        assert_match(%r!8 included!, @content)
      end
    end
  end

  context "relative include tag with variable and liquid filters" do
    setup do
      site = fixture_site({ "pygments" => true }).tap(&:read).tap(&:render)
      post = site.posts.docs.find do |p|
        p.basename.eql? "2014-09-02-relative-includes.markdown"
      end
      @content = post.output
    end

    should "include file as variable with liquid filters" do
      assert_match(%r!1 relative_include!, @content)
      assert_match(%r!2 relative_include!, @content)
      assert_match(%r!3 relative_include!, @content)
    end

    should "include file as variable and liquid filters with arbitrary whitespace" do
      assert_match(%r!4 relative_include!, @content)
      assert_match(%r!5 relative_include!, @content)
      assert_match(%r!6 relative_include!, @content)
    end

    should "include file as variable and filters with additional parameters" do
      assert_match("<li>var1 = foo</li>", @content)
      assert_match("<li>var2 = bar</li>", @content)
    end

    should "include file as partial variable" do
      assert_match(%r!8 relative_include!, @content)
    end

    should "include files relative to self" do
      assert_match(%r!9 —\ntitle: Test Post Where YAML!, @content)
    end

    context "trying to do bad stuff" do
      context "include missing file" do
        setup do
          @content = <<CONTENT
---
title: missing file
---

{% include_relative missing.html %}
CONTENT
        end

        should "raise error relative to source directory" do
          exception = assert_raises IOError do
            create_post(@content, {
              "permalink"   => "pretty",
              "source"      => source_dir,
              "destination" => dest_dir,
              "read_posts"  => true,
            })
          end
          assert_match "Could not locate the included file 'missing.html' in any of " \
                       "[\"#{source_dir}\"].", exception.message
        end
      end

      context "include existing file above you" do
        setup do
          @content = <<CONTENT
---
title: higher file
---

{% include_relative ../README.markdown %}
CONTENT
        end

        should "raise error relative to source directory" do
          exception = assert_raises ArgumentError do
            create_post(@content, {
              "permalink"   => "pretty",
              "source"      => source_dir,
              "destination" => dest_dir,
              "read_posts"  => true,
            })
          end
          assert_equal(
            "Invalid syntax for include tag. File contains invalid characters or " \
            "sequences:\n\n  ../README.markdown\n\nValid syntax:\n\n  " \
            "{% include_relative file.ext param='value' param2='value' %}\n\n",
            exception.message
          )
        end
      end
    end

    context "with symlink'd include" do
      should "not allow symlink includes" do
        File.open("tmp/pages-test", "w") { |file| file.write("SYMLINK TEST") }
        assert_raises IOError do
          content = <<CONTENT
---
title: Include symlink
---

{% include_relative tmp/pages-test %}

CONTENT
          create_post(content, {
            "permalink"   => "pretty",
            "source"      => source_dir,
            "destination" => dest_dir,
            "read_posts"  => true,
            "safe"        => true,
          })
        end
        @result ||= ""
        refute_match(%r!SYMLINK TEST!, @result)
      end

      should "not expose the existence of symlinked files" do
        ex = assert_raises IOError do
          content = <<CONTENT
---
title: Include symlink
---

{% include_relative tmp/pages-test-does-not-exist %}

CONTENT
          create_post(content, {
            "permalink"   => "pretty",
            "source"      => source_dir,
            "destination" => dest_dir,
            "read_posts"  => true,
            "safe"        => true,
          })
        end
        assert_match(
          "Ensure it exists in one of those directories and is not a symlink "\
          "as those are not allowed in safe mode.",
          ex.message
        )
      end
    end
  end
end
