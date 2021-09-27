---
title: Markdown Options
permalink: "/docs/configuration/markdown/"
---
The various Markdown renderers supported by Jekyll sometimes have extra options
available.

## Kramdown

Kramdown is the default Markdown renderer for Jekyll, and often works well with no additional configuration. However, it does support many configuration options.

### Kramdown Processor

By default, Jekyll uses the [GitHub Flavored Markdown (GFM) processor](https://github.com/kramdown/parser-gfm) for Kramdown. (Specifying `input: GFM` is fine, but redundant.) GFM supports a couple additional Kramdown options, documented by [kramdown-parser-gfm](https://github.com/kramdown/parser-gfm). These options can be used directly in your Kramdown Jekyll config, like this:

```yaml
kramdown:
  gfm_quirks: [paragraph_end]
```

You can also change the processor used by Kramdown (as specified for the `input` key in the [Kramdown RDoc](https://kramdown.gettalong.org/rdoc/Kramdown/Document.html#method-c-new)). For example, to use the non-GFM Kramdown processor in Jekyll, add the following to your configuration.

```yaml
kramdown:
  input: Kramdown
```

Documentation for Kramdown parsers is available in the [Kramdown docs](https://kramdown.gettalong.org/parser/kramdown.html). If you use a Kramdown parser other than Kramdown or GFM, you'll need to add the gem for it.

### Syntax Highlighting (CodeRay)

To use the [CodeRay](http://coderay.rubychan.de/) syntax highlighter with Kramdown, you  need to add a dependency on the `kramdown-syntax-coderay` gem. For example, `bundle add kramdown-syntax-coderay`. Then, you'll be able to specify CodeRay in your `syntax_highlighter` config:

```yaml
kramdown:
  syntax_highlighter: coderay
```

CodeRay supports several of its own configuration options, documented in the [kramdown-syntax-coderay docs](https://github.com/kramdown/syntax-coderay) which can be passed as `syntax_highlighter_opts` like this:

```yaml
kramdown:
  syntax_highlighter: coderay
  syntax_highlighter_opts:
    line_numbers: table
    bold_every: 5
```

### Advanced Kramdown Options

Kramdown supports a variety of other relatively advanced options such as `header_offset` and `smart_quotes`. These are documented in the [Kramdown configuration documentation](https://kramdown.gettalong.org/options.html) and can be added to your Kramdown config like this:

```yaml
kramdown:
  header_offset: 2
```

<div class="note warning">
  <h5>There are several unsupported kramdown options</h5>
  <p>
    Please note that Jekyll uses Kramdown's HTML converter. Kramdown options used only by other converters, such as <code>remove_block_html_tags</code> (used by the RemoveHtmlTags converter), will not work.
  </p>
</div>

## CommonMark

[CommonMark](https://commonmark.org/) is a rationalized version of Markdown syntax, implemented in C and thus faster than default Kramdown implemented in Ruby. It [slightly differs](https://github.com/commonmark/CommonMark#differences-from-original-markdown) from original Markdown and does not support all the syntax elements implemented in Kramdown, like [Block Inline Attribute Lists](https://kramdown.gettalong.org/syntax.html#block-ials).

It comes in two flavors: basic CommonMark with [jekyll-commonmark](https://github.com/jekyll/jekyll-commonmark) plugin and [GitHub Flavored Markdown supported by GitHub Pages](https://github.com/github/jekyll-commonmark-ghpages).

### Custom Markdown Processors

If you're interested in creating a custom markdown processor, you're in luck! Create a new class in the `Jekyll::Converters::Markdown` namespace:

```ruby
class Jekyll::Converters::Markdown::MyCustomProcessor
  def initialize(config)
    require 'funky_markdown'
    @config = config
  rescue LoadError
    STDERR.puts 'You are missing a library required for Markdown. Please run:'
    STDERR.puts '  $ [sudo] gem install funky_markdown'
    raise FatalException.new("Missing dependency: funky_markdown")
  end

  def convert(content)
    ::FunkyMarkdown.new(content).convert
  end
end
```

Once you've created your class and have it properly set up either as a plugin
in the `_plugins` folder or as a gem, specify it in your `_config.yml`:

```yaml
markdown: MyCustomProcessor
```
