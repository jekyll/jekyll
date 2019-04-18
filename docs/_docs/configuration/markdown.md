---
title: Markdown Options
permalink: "/docs/configuration/markdown/"
---
The various Markdown renderers supported by Jekyll sometimes have extra options
available.

### Kramdown

Kramdown is the default Markdown renderer for Jekyll. Below is a list of the
currently supported options:

* **auto_id_prefix** - Prefix used for automatically generated header IDs
* **auto_id_stripping** - Strip all formatting from header text for automatic ID generation
* **auto_ids** - Use automatic header ID generation
* **coderay_bold_every** - Defines how often a line number should be made bold
* **coderay_css** - Defines how the highlighted code gets styled
* **coderay_default_lang** - Sets the default language for highlighting code blocks
* **coderay_line_number_start** - The start value for the line numbers
* **coderay_line_numbers** - Defines how and if line numbers should be shown
* **coderay_tab_width** - The tab width used in highlighted code
* **coderay_wrap** - Defines how the highlighted code should be wrapped
* **enable_coderay** - Use coderay for syntax highlighting
* **entity_output** - Defines how entities are output
* **footnote_backlink** - Defines the text that should be used for the footnote backlinks
* **footnote_backlink_inline** - Specifies whether the footnote backlink should always be inline
* **footnote_nr** - The number of the first footnote
* **gfm_quirks** - Enables a set of GFM specific quirks
* **hard_wrap** - Interprets line breaks literally
* **header_offset** - Sets the output offset for headers
* **html_to_native** - Convert HTML elements to native elements
* **line_width** - Defines the line width to be used when outputting a document
* **link_defs** - Pre-defines link definitions
* **math_engine** - Set the math engine
* **math_engine_opts** - Set the math engine options
* **parse_block_html** - Process kramdown syntax in block HTML tags
* **parse_span_html** - Process kramdown syntax in span HTML tags
* **smart_quotes** - Defines the HTML entity names or code points for smart quote output
* **syntax_highlighter** - Set the syntax highlighter
* **syntax_highlighter_opts** - Set the syntax highlighter options
* **toc_levels** - Defines the levels that are used for the table of contents
* **transliterated_header_ids** - Transliterate the header text before generating the ID
* **typographic_symbols** - Defines a mapping from typographical symbol to output characters

<div class="note warning">
  <h5>There are two unsupported kramdown options</h5>
  <p>
    Please note that both <code>remove_block_html_tags</code> and
    <code>remove_span_html_tags</code> are currently unsupported in Jekyll due
    to the fact that they are not included within the kramdown HTML converter.
  </p>
</div>

For more details about these options have a look at the [Kramdown configuration documentation](https://kramdown.gettalong.org/options.html). 

### CommonMark

[CommonMark](https://commonmark.org/) is a rationalized version of Markdown syntax, implemented in C and thus faster than default Kramdown implemented in Ruby. It [slightly differs](https://github.com/commonmark/CommonMark#differences-from-original-markdown) from original Markdown and does not support all the syntax elements implemented in Kramdown, like [Block Inline Attribute Lists](https://kramdown.gettalong.org/syntax.html#block-ials).

It comes in two flavors: basic CommonMark with [jekyll-commonmark](https://github.com/jekyll/jekyll-commonmark) plugin and [GitHub Flavored Markdown supported by GitHub Pages](https://github.com/github/jekyll-commonmark-ghpages).

### Redcarpet

Redcarpet can be configured by providing an `extensions` sub-setting, whose
value should be an array of strings. Each string should be the name of one of
the `Redcarpet::Markdown` class's extensions; if present in the array, it will
set the corresponding extension to `true`.

Jekyll handles two special Redcarpet extensions:

- `no_fenced_code_blocks` --- By default, Jekyll sets the `fenced_code_blocks`
extension (for delimiting code blocks with triple tildes or triple backticks)
to `true`, probably because GitHub's eager adoption of them is starting to make
them inescapable. Redcarpet's normal `fenced_code_blocks` extension is inert
when used with Jekyll; instead, you can use this inverted version of the
extension for disabling fenced code.

Note that you can also specify a language for highlighting after the first
delimiter:

        ```ruby
        # ...ruby code
        ```

With both fenced code blocks and highlighter enabled, this will statically
highlight the code; without any syntax highlighter, it will add a
`class="LANGUAGE"` attribute to the `<code>` element, which can be used as a
hint by various JavaScript code highlighting libraries.

- `smart` --- This pseudo-extension turns on SmartyPants, which converts
  straight quotes to curly quotes and runs of hyphens to em (`---`) and en (`--`) dashes.

All other extensions retain their usual names from Redcarpet, and no renderer
options aside from `smart` can be specified in Jekyll. [A list of available
extensions can be found in the Redcarpet README file.](https://github.com/vmg/redcarpet/blob/v3.2.2/README.markdown#and-its-like-really-simple-to-use)
Make sure you're looking at the README for the right version of
Redcarpet: Jekyll currently uses v3.2.x. The most commonly used
extensions are:

- `tables`
- `no_intra_emphasis`
- `autolink`

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
