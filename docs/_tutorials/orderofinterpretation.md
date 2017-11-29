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

2. **Liquid**. Jekyll processes any [Liquid](https://github.com/Shopify/liquid) formatting in pages that contain [front matter]({% link _docs/frontmatter.md %}). You can identify Liquid as follows:
   * **Liquid tags** start with `{% raw %}{%{% endraw %}` and end with a `{% raw %}%}{% endraw %}`. For example: `{% raw %}{% highlight %}{% endraw %}` or `{% raw %}{% seo %}{% endraw %}`. Tags can define blocks or be inline. Block-defining tags will also come with a corresponding end tag &mdash; for example, `{% raw %}{% endhighlight %}{% endraw %}`.
   * **Liquid variables** start and end with double curly braces. For example: `{% raw %}{{ site.myvariable }}{% endraw %}` or `{% raw %}{{ content }}{% endraw %}`.
   * **Liquid filters** start with a pipe character (`|`) and can only be used within **Liquid variables** after the variable string. For example: the `relative_url` filter in `{% raw %}{{ "css/main.css" | relative_url }}{% endraw %}`.

3. **Markdown**. Jekyll converts Markdown to HTML using the Markdown filter specified in your config file. Files must have a Markdown file extension and front matter in order for Jekyll to convert them.

4. **Layout**. Jekyll pushes content into the layouts specified by the page's front matter (or as specified in the config file). The content from each page gets pushed into the `{% raw %}{{ content }}{% endraw %}` tags within the layouts.

5. **Files**. Jekyll writes the generated content into files in the [directory structure]({% link _docs/structure.md %}) in `_site`. Pages, posts, and collections get structured based on their [permalink]({% link _docs/permalinks.md %}) setting. Directories that begin with `_` (such as `_includes` and `_data`) are usually hidden in the output.

## Scenarios where incorrect configurations create problems

For the most part, you don't have to think about the order of interpretation when building your Jekyll site. These details only become important to know when something isn't rendering.

The following scenarios highlight potential problems you might encounter. These problems come from misunderstanding the order of interpretation and can be easily fixed.

### Variable on page not rendered because variable is assigned in layout

In your layout file (`_layouts/default.html`), suppose you have a variable assigned:

{% raw %}
```liquid
{% assign myvar = "joe" %}
```
{% endraw %}

On a page that uses the layout, you reference that variable:

{% raw %}
```liquid
{{ myvar }}
```
{% endraw %}

The variable won't render because the page's order of interpretation is to render Liquid first and later process the Layout. When the Liquid rendering happens, the variable assignment isn't available.

To make the code work, you could put the variable assignment into the page's front matter.

### Markdown in include file not processed

Suppose you have a Markdown file at `_includes/mycontent.md`. In the Markdown file, you have some Markdown formatting:

```markdown
This is a list:
* first item
* second item
```

You include the file into an HTML file as follows:

{% raw %}
```liquid
{% include mycontent.md %}
```
{% endraw %}

The Markdown is not processed because first the Liquid (`include` tag) gets processed, inserting `mycontent.md` into the HTML file. *Then* the Markdown would get processed.

But because the content is included into an *HTML* page, the Markdown isn't rendered. The Markdown filter processes content only in Markdown files.

To make the code work, use HTML formatting in includes that are inserted into HTML files.

Note that `highlight` tags don't require Markdown to process. Suppose your include contains the following:

{% raw %}
```liquid
{% highlight javascript %}
console.log('alert');
{% endhighlight %}
```
{% endraw %}

The `highlight` tag *is* Liquid. (Liquid passes the content to Rouge or Pygments for syntax highlighting.) As a result, this code will actually convert to HTML with syntax highlighting. Jekyll does not need the Markdown filter to process `highlight` tags.

### Liquid mixed with JavaScript isn't rendered

Suppose you try to mix Liquid's `assign` tag with JavaScript, like this:

{% raw %}
```javascript
<button onclick="someFunction()">Click me</button>

<p id="intro"></p>

<script>
{% assign someContent = "This is some content" %}
function someFunction() {
    document.getElementById("intro").innerHTML = someContent;
}
</script>
```
{% endraw %}

This won't work because the `assign` tag is only available during the Liquid rendering phase of the site. In this JavaScript example, the script executes when a user clicks a button ("Click me") on the HTML page. At that time, the Liquid logic is no longer available, so the `assign` tag wouldn't return anything.

However, you can use Jekyll's site variables or Liquid to *populate* a script that is executed at a later time. For example, suppose you have the following property in your front matter: `someContent: "This is some content"`. You could do this:

{% raw %}
```js
<button onclick="someFunction()">Click me</button>

<p id="intro"></p>

<script>

function someFunction() {
    document.getElementById("intro").innerHTML = "{{ page.someContent }}";
}
</script>
```
{% endraw %}

When Jekyll builds the site, this `someContent` property populates the script's values, converting `{% raw %}{{ page.someContent }}{% endraw %}` to `"This is some content"`.

The key to remember is that Liquid renders when Jekyll builds your site. Liquid is not available at run-time in the browser when a user executes an event.

## Note about using Liquid in YAML

There's one more detail to remember: Liquid does not render when embedded in YAML files or front matter. (This isn't related to order of interpretation, but it's worth mentioning because it's a common question about element rendering.)

For example, suppose you have a `highlight` tag in your `_data/mydata.yml` file:

{% raw %}
```liquid
myvalue: >
  {% highlight javascript %}
  console.log('alert');
  {% endhighlight %}
```
{% endraw %}

On a page, you try to insert the value:

{% raw %}
```liquid
{{ site.data.mydata.myvalue }}
```
{% endraw %}

This would render only as a string rather than a code sample with syntax highlighting. To make the code render, consider using an include instead.
