---
title: Tags
permalink: /docs/plugins/tags/
---

If you’d like to include custom liquid tags in your site, you can do so by
hooking into the tagging system. Built-in examples added by Jekyll include the
`highlight` and `include` tags. Below is an example of a custom liquid tag that
will output the time the page was rendered:

```ruby
module Jekyll
  class RenderTimeTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "#{@text} #{Time.now}"
    end
  end
end

Liquid::Template.register_tag('render_time', Jekyll::RenderTimeTag)
```

At a minimum, liquid tags must implement:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Method</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>render</code></p>
      </td>
      <td>
        <p>Outputs the content of the tag.</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

You must also register the custom tag with the Liquid template engine as
follows:

```ruby
Liquid::Template.register_tag('render_time', Jekyll::RenderTimeTag)
```

In the example above, we can place the following tag anywhere in one of our
pages:

{% raw %}
```ruby
<p>{% render_time page rendered at: %}</p>
```
{% endraw %}

And we would get something like this on the page:

```html
<p>page rendered at: Tue June 22 23:38:47 –0500 2010</p>
```

## Tag Blocks

The `render_time` tag seen above can also be rewritten as a tag block by 
inheriting the `Liquid::Block` class. Look at the example below:

```ruby
module Jekyll
  class RenderTimeTagBlock < Liquid::Block

    def render(context)
      text = super
      "<p>#{text} #{Time.now}</p>"
    end

  end
end

Liquid::Template.register_tag('render_time', Jekyll::RenderTimeTagBlock)
```

We can now use the tag block anywhere:

{% raw %}
```liquid
{% render_time %}
page rendered at:
{% endrender_time %}
```
{% endraw %}

And we would still get the same output as above on the page:

```html
<p>page rendered at: Tue June 22 23:38:47 –0500 2010</p>
```

<div class="note info">
  <p>In the above example, the tag block and the tag are both registered with 
  the name <code>render_time</code> but to register a tag and a tag block using 
  the same name in the same project is not recommended as this may lead to 
  conflicts.</p>
</div>