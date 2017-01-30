---
layout: tutorials
permalink: /tutorials/orderofinterpretation/
title: Order of interpretation
---

Jekyll's main job is to convert your raw text files into a static website. It does this by rendering Liquid, Markdown, and other transforms as it generates the static HTML output.

In this conversion process, it's important to understand Jekyll's order of interpretation. By "order of interpretation," we mean what gets rendered, in what order, and what rules get applied in converting content.

If an element isn't converting, you can troubleshoot the problem by analyzing the order of interpretation.

## Order of interpretations

Jekyll converts your site in the following order:

1. **Site variables**. Jekyll looks across your files and populates [site variables]({% link _docs/variables.md %}), such as `site`, `page`, `post`, and collection objects. (From these objects, Jekyll determines the values for permalinks, tags, categories, and other details.)

2. **Liquid**. Jekyll processes any Liquid formatting in pages that contain [front matter]({% link _docs/frontmatter.md %}). All Liquid tags, such as `include`, `highlight`, or `assign` tags, are rendered. (Anything in Jekyll with `{% raw %}{{ }}{% endraw %}` curly braces or `{% raw %}{% %}{% endraw %}` is usually a Liquid filter or tag.)

3. **Markdown**. Jekyll converts Markdown to HTML using the Markdown filter specified in your config file. Files must have a Markdown file extension and front matter in order for Jekyll to convert them.

4. **Layout**. Jekyll pushes content into the layouts specified by the page's front matter (or as specified in the config file). The content from each page gets pushed into the `{% raw %}{{ content }}{% endraw %}` tags within the layouts.

5. **Files**. Jekyll writes the generated content into files in the [directory structure]({% link _docs/structure.md %}) in `_site`. Pages, posts, and collections get structured based on their [permalink]({% link _docs/permalinks.md %}) setting. Directories that begin with `_` (such as `_includes` and `_data`) are usually hidden in the output.

## Scenarios where incorrect configurations create problems

For the most part, you don't have to think about the order of interpretation when building your Jekyll site. These details only become important to know when something isn't rendering.

The following scenarios highlight potential problems you might encounter. These problems stem from misunderstanding the order of interpretation and can be easily fixed.

### Variable on page not rendered because variable is assigned in layout

In your layout file (`_layouts/default.html`), suppose you have a variable assigned:

```
{% raw %}{% assign myvar = "joe" %}{% endraw %}
```

On a page that uses the layout, you reference that variable:

```
{% raw %}{{ myvar }}{% endraw %}
```

The variable won't render because the page's order of interpretation is to render Liquid first and later process the Layout. When the Liquid rendering happens, the variable assignment isn't available.

To make the code work, you could put the variable assignment into the page's front matter.

### Liquid tag in data reference not rendered

In `_data/mydata.yml`, suppose you have this mapping:

```
{% raw %}somevalue: {{ myvar }}{% endraw %}
```

On a page, you try to insert this value:

```
{% raw %}{{ site.data.mydata.somevalue }}{% endraw %}
```

This renders as a string (`{% raw %}"{{ site.data.mydata.somevalue }}{% endraw %}"` rather than the variable's value. This is because first the site variables populate, and then Liquid renders. When the site variables populate, the value for `{% raw %}{{ site.data.mydata.somevalue }}{% endraw %}` is simply `{% raw %}{{ myvar }}{% endraw %}`, which registers as a string. You can't use Liquid in data files.

Similarly, suppose you have a `highlight` tag in your `_data/mydata.yml` file:

```
{% raw %}myvalue: >
  {% highlight javascript %}
  console.log('alert');
  {% endhighlight %}{% endraw %}
```

On a page, you try to insert the value:

```
{% raw %}{{ site.data.mydata.myvalue }}{% endraw %}
```

This renders as a string for the same reasons described above. When the `site.data.mydata.myvalue` tag populates, the value gets stored as a string and printed to the page as a string.

To make the code work, consider populating content from includes.

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

The Markdown is not processed because first the Liquid (`include` tag) gets processed, inserting `mycontent.md` into the HTML file. *Then* the Markdown would get processed.

But because the content is included into an *HTML* page, the Markdown isn't rendered. The Markdown filter processes content only in Markdown files.

To make the code work, use HMTL formatting in includes that are inserted into HTML files.

Note that `highlight` tags don't require Markdown to process. Suppose your include contains the following:

```liquid
{% raw %}{% highlight javascript %}
console.log('alert');
{% endhighlight %}{% endraw %}
```

The `highlight` tag *is* Liquid. (Liquid passes the content to Rouge or Pygments for syntax highlighting.) As a result, this code will actually convert to HTML with syntax highlighting. Jekyll does not need the Markdown filter to process `highlight` tags.

### Liquid mixed with JavaScript isn't rendered

Suppose you try to mix Liquid's `assign` tag with JavaScript, like this:

```javascript
{% raw %}<button onclick="someFunction()">Click me</button>

<p id="intro"></p>

<script>
{% assign someContent = "This is some content" %}
function someFunction() {
    document.getElementById("intro").innerHTML = someContent;
}
</script>{% endraw %}
```

This won't work because the `assign` tag is only available during the Liquid rendering phase of the site. In this JavaScript example, the script executes when a user clicks a button ("Click me") on the page. At that time, the Liquid logic is no longer available, so the `assign` tag wouldn't return anything.

However, you can use Jekyll's site variables or Liquid to *populate* a script that is executed at a later time. For example, suppose you have the following property in your front matter: `someContent: "This is some content"`. You could do this:

```js
{% raw %}<button onclick="someFunction()">Click me</button>

<p id="intro"></p>

<script>

function someFunction() {
    document.getElementById("intro").innerHTML = "{{ page.someContent }}";
}
</script>{% endraw %}
```

When Jekyll builds the site, this `someContent` property populates the script's values, converting `{% raw %}{{ page.someContent }}{% endraw %}` to `"This is some content"`.

The key to remember is that Liquid renders when Jekyll builds your site. Liquid is not available at run-time in the browser when a user executes an event.
