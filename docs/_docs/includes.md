---
title: Includes
permalink: /docs/includes/
---

The `include` tag allows you to include the content from another file stored in the `_includes` folder:

{% raw %}
```liquid
{% include footer.html %}
```
{% endraw %}

Jekyll will look for the referenced file (in this case, `footer.html`) in the `_includes` directory at the root of your source directory and insert its contents.

## Parameters

Includes can take parameters which is especially useful for reducing repetition across your Jekyll site.

To use parameters you pass a list of key/values to the include:

{% raw %}
```liquid
{% include note.html style="big" content="This is my sample note." %}
```
{% endraw %}

The parameters are available in the include under the `include` variable:

{% raw %}
```liquid
<div class="my-note {{ include.style }}">
  {{ include.content }}
</div>
```
{% endraw %}

To safeguard situations where users don't supply a value for the parameter, you can use [Liquid's default filter](https://shopify.github.io/liquid/filters/default/).

If you need to modify a variable before sending it to the include, you can save it to an intermediate variable. For example this is one way to prepend a string to variable used in an include:

{% raw %}
```liquid
{% capture download_note %}
The latest version of {{ site.product_name }} is now available.
{% endcapture %}
{% include note.html style="big" content=download_note %}
```
{% endraw %}



## Including files relative to another file

You can choose to include file fragments relative to the current file by using the `include_relative` tag:

{% raw %}
```liquid
{% include_relative somedir/footer.html %}
```
{% endraw %}

You won't need to place your included content within the `_includes` directory. Instead,
the inclusion is specifically relative to the file where the tag is being used. For example,
if `_posts/2014-09-03-my-file.markdown` uses the `include_relative` tag, the included file
must be within the `_posts` directory or one of its subdirectories.

Note that you cannot use the `../` syntax to specify an include location that refers to a higher-level directory.

All the other capabilities of the `include` tag are available to the `include_relative` tag,
such as variables.

## Include file by variable

The name of the file you want to embed can be specified as a variable instead of an actual file name. For example, suppose you defined a variable in your page's front matter like this:

```yaml
---
title: My page
my_variable: footer_company_a.html
---
```

You could then reference that variable in your include:

{% raw %}
```liquid
{% include {{ page.my_variable }} %}
```
{% endraw %}

In this example, the include would insert the file `footer_company_a.html` from the `_includes/footer_company_a.html` directory.
