# frozen_string_literal: true

require "helper"

class TestTagHighlight < TagUnitTest
  def render_content_with_text_to_highlight(code)
    content = <<~CONTENT
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
    render_content(content)
  end

  # Syntax sugar for low-level version of:
  #   ```
  #   {% highlight markup%}test{% endhighlight %}
  #   ```
  def highlight_block_with_markup(markup)
    Jekyll::Tags::HighlightBlock.parse(
      "highlight",
      markup,
      Liquid::Tokenizer.new("test{% endhighlight %}\n"),
      Liquid::ParseContext.new
    )
  end

  context "language name" do
    should "match only the required set of chars" do
      r = Jekyll::Tags::HighlightBlock::SYNTAX
      [
        "ruby",
        "c#",
        "xml+cheetah",
        "x.y",
        "coffee-script",
        "shell_session",
        "ruby key=val",
        "ruby a=b c=d",
      ].each { |sample| assert_match(r, sample) }

      refute_match r, "blah^"
    end
  end

  context "highlight tag in unsafe mode" do
    should "set the no options with just a language name" do
      tag = highlight_block_with_markup("ruby ")
      assert_equal({}, tag.instance_variable_get(:@highlight_options))
    end

    should "set the linenos option as 'inline' if no linenos value" do
      tag = highlight_block_with_markup("ruby linenos ")
      assert_equal(
        { :linenos => "inline" },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "set the linenos option to 'table' " \
           "if the linenos key is given the table value" do
      tag = highlight_block_with_markup("ruby linenos=table ")
      assert_equal(
        { :linenos => "table" },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "recognize nowrap option with linenos set" do
      tag = highlight_block_with_markup("ruby linenos=table nowrap ")
      assert_equal(
        { :linenos => "table", :nowrap => true },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "recognize the cssclass option" do
      tag = highlight_block_with_markup("ruby linenos=table cssclass=hl ")
      assert_equal(
        { :cssclass => "hl", :linenos => "table" },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "recognize the hl_linenos option and its value" do
      tag = highlight_block_with_markup("ruby linenos=table cssclass=hl hl_linenos=3 ")
      assert_equal(
        { :cssclass => "hl", :linenos => "table", :hl_linenos => "3" },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "recognize multiple values of hl_linenos" do
      tag = highlight_block_with_markup 'ruby linenos=table cssclass=hl hl_linenos="3 5 6" '
      assert_equal(
        { :cssclass => "hl", :linenos => "table", :hl_linenos => %w(3 5 6) },
        tag.instance_variable_get(:@highlight_options)
      )
    end

    should "treat language name as case insensitive" do
      tag = highlight_block_with_markup("Ruby ")
      assert_equal "ruby", tag.instance_variable_get(:@lang), "lexers should be case insensitive"
    end
  end

  context "with the rouge highlighter" do
    context "post content has highlight tag" do
      setup do
        render_content_with_text_to_highlight "test"
      end

      should "render markdown with rouge" do
        assert_match(
          %(<pre><code class="language-text" data-lang="text">test</code></pre>),
          @result
        )
      end

      should "render markdown with rouge with line numbers" do
        assert_match(
          %(<table class="rouge-table"><tbody>) +
            %(<tr><td class="gutter gl">) +
            %(<pre class="lineno">1\n</pre></td>) +
            %(<td class="code"><pre>test\n</pre></td></tr>) +
            %(</tbody></table>),
          @result
        )
      end
    end

    context "post content has highlight with file reference" do
      setup do
        render_content_with_text_to_highlight "./jekyll.gemspec"
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
        render_content_with_text_to_highlight "Æ"
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
        render_content_with_text_to_highlight <<~EOS


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

    context "post content has highlight tag with preceding spaces & lines in several places" do
      setup do
        render_content_with_text_to_highlight <<~EOS


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
        render_content <<~EOS
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

      should "should stop highlighting at boundary with rouge" do
        expected = <<~EOS
          <p>This is not yet highlighted</p>

          <figure class="highlight"><pre><code class="language-php" data-lang="php"><table class="rouge-table"><tbody><tr><td class="gutter gl"><pre class="lineno">1
          </pre></td><td class="code"><pre><span class="n">test</span>
          </pre></td></tr></tbody></table></code></pre></figure>

          <p>This should not be highlighted, right?</p>
        EOS
        assert_match(expected, @result)
      end
    end

    context "post content has highlight tag with " \
            "preceding spaces & Windows-style newlines" do
      setup do
        render_content_with_text_to_highlight "\r\n\r\n\r\n     [,1] [,2]"
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
        render_content_with_text_to_highlight <<~EOS
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
      @content = <<~CONTENT
        ---
        title: Kramdown post with pre
        ---

        _FIGHT!_

        {% highlight ruby %}
        puts "3..2..1.."
        {% endhighlight %}

        *FINISH HIM*
      CONTENT
    end

    context "using Kramdown" do
      setup do
        render_content(@content, "markdown" => "kramdown")
      end

      should "parse correctly" do
        assert_match %r{<em>FIGHT!</em>}, @result
        assert_match %r!<em>FINISH HIM</em>!, @result
      end
    end
  end
end
