---
layout: tutorials
permalink: /tutorials/orderofinterpretation/
title: Order of interpretation
---

Jekyll's main job is to convert your raw text files into a static website. It does this by rendering Liquid,  Markdown, and other transforms as it generates the static output.

In this conversion process, it's important to understand Jekyll's order of interpretation. By "order of interpretation," we mean what gets rendered first, in what order, and what rules get applied in converting content.

If an element isn't converting , you can troubleshoot the problem by analyzing the order of interpretation.

## Order of interpretations

Jekyll converts your site in the following order:

1. **Site variables**. Jekyll looks across your files and populates [site variables]({% link _docs/variables.md %}), such as `site`, `page`, `post`, and collection objects. (From these objects, Jekyll determines the values for permalinks, tags, categories, and other details.)

2. **Liquid**. Jekyll processes any Liquid formatting. Any Liquid tags, such as `include`, `highlight`, or `assign`, are rendered. (Anything in Jekyll with `{% raw %}{{ }}{% endraw %}` curly braces or `{% raw %}{% %}{% endraw %}` is usually a Liquid filter or tag.)

3. **Markdown**. Jekyll converts Markdown to HTML using the Markdown filter specified in your config file. Files must have a Markdown file extension and include [front matter]({% link _docs/frontmatter.md %}) in order for Jekyll to convert them.

4. **Layout**. Jekyll pushes content into the layouts specified by the page's front matter (or as specified in the config file). The content from each page gets pushed into the `{% raw %}{{content}}{% endraw %}` tags within the layouts.

5. **Files**. Jekyll writes the generated content into files in the [directory structure]({% link _docs/structure.md %}) in `_site`.  Pages, posts, and collections get structured based on their [permalink]({% link _docs/permalinks.md %}) setting. Directories that begin with `_` (such as `_includes` and `_data`) are usually hidden in the output.

## Scenarios where incorrect configurations yield problems

For the most part, you don't have to think about the order of interpretation when building your Jekyll site. These details only become important to know when something isn't rendering.

The following scenarios highlight potential problems you might encounter. These problems stem from misunderstanding the order of interpretation.

### Variable on page not rendered because variable is assigned in layout

In your layout file (`_layouts/default.html`), suppose you have a variable assigned:

```
{% raw %}{% assign myvar = "joe" %}{% endraw %}
```

On a page that uses the layout , you reference that variable:

```
{% raw %}{{myvar}}{% endraw %}
```

The variable won't render because the page's order of interpretation is Liquid > Markdown > Layout. When the Liquid rendering happens, the variable assignment isn't available. The variable doesn't get assigned until the Layout phase. As a fix, you might put the variable assignment into the page's front matter.

### Liquid tag in data reference not rendered

In `_data/mydata.yml`, suppose you have this reference:

```
{% raw %}somevalue: {{myvar}}{% endraw %}
```

On a page, you try to insert this value:

```
{% raw %}{{site.data.mydata.somevalue}}{% endraw %}
```
Nothing renders because first the site variables populate, and then Liquid renders. When the site variables populate, the value for `{% raw %}{{site.data.mydata.somevalue}}{% endraw %}` is simply `{% raw %}{{myvar}}{% endraw %}`, which registers as a string and gets printed as a string. You can't use Liquid in data files.

Similarly, suppose you have this in your `_data/mydata.yml` file:

```
{% raw %}myvalue: >
  {% highlight javascript %}
  console.log('alert');
  {% endhighlight %}{% endraw %}
```

On a page, you try to insert the value:

```
{% raw %}{{site.data.mydata.myvalue}}{% endraw %}
```

This renders as a string for the same reasons described above. When the `site.data.mydata.myvalue` tag populates, the value gets stored as a string and printed to the page as a string.

### Markdown in include file not processed

Suppose you have a Markdown file at `_includes/mycontent.md`. In the Markdown file, you have some Markdown formatting:

```markdown
This is a list:
* first item
* second item
```

You include the file into an HTML file as follows:

```liquid
{% raw %}{% include mycontent.md %}{% endraw %}
```

The Markdown is not processed. First the Liquid (`include` tag) gets processed, inserting `mycontent.md` into the HTML file. *Then* the Markdown gets processed.

But because you've included the content into an *HTML* page, the Markdown isn't rendered. The Markdown filter processes content only in Markdown files.

However, suppose your include contains the following:

```liquid
{% raw %}{% highlight javascript %}
console.log('alert');
{% endhighlight %}{% endraw %}
```

`highlight` *is* a Liquid tag. (Liquid passes the content to Rouge or Pygments for syntax higlighting.) As a result, this code will actually convert to HTML with syntax highlighting. Jekyll does not need the Markdown filter to process `highlight` tags.

### Liquid mixed with JavaScript isn't rendered

Suppose you try to mix Liquid with JavaScript, like this:

```liquid
{% raw %}if page.type == "home" { 
    $("intro").addClass("bright");
elsif page.type == "normal" {
    $("intro").addClass("muted");
 }{% endraw %}
```

The Liquid renders long before the page gets converted to HTML. So when JavaScript executes in the browser, the Liquid is no longer present.

You can never mix Liquid with JavaScript because Liquid processes when the site builds. JavaScript processes in the browser when a user interacts with your site.