---
layout: docs
title: Templates
permalink: /docs/templates/
---

Jekyll uses the [Liquid](https://shopify.github.io/liquid/) templating language to
process templates. All of the standard Liquid [tags](https://shopify.github.io/liquid/tags/) and
[filters](https://shopify.github.io/liquid/filters/) are
supported. Jekyll even adds a few handy filters and tags of its own to make
common tasks easier.

## Filters

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Description</th>
      <th><span class="filter">Filter</span> and <span class="output">Output</span></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p class="name"><strong>Relative URL</strong></p>
        <p>Prepend the <code>baseurl</code> value to the input. Useful if your site is hosted at a subpath rather than the root of the domain.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "/assets/style.css" | relative_url }}{% endraw %}</code>
        </p>
        <p>
         <code class="output">/my-baseurl/assets/style.css</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Absolute URL</strong></p>
        <p>Prepend the <code>url</code> and <code>baseurl</code> value to the input.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "/assets/style.css" | absolute_url }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">http://example.com/my-baseurl/assets/style.css</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Date to XML Schema</strong></p>
        <p>Convert a Date into XML Schema (ISO 8601) format.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.time | date_to_xmlschema }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">2008-11-07T13:07:54-08:00</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Date to RFC-822 Format</strong></p>
        <p>Convert a Date into the RFC-822 format used for RSS feeds.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.time | date_to_rfc822 }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">Mon, 07 Nov 2008 13:07:54 -0800</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Date to String</strong></p>
        <p>Convert a date to short format.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.time | date_to_string }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">07 Nov 2008</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Date to Long String</strong></p>
        <p>Format a date to long format.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.time | date_to_long_string }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">07 November 2008</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Where</strong></p>
        <p>Select all the objects in an array where the key has the given value.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.members | where:"graduation_year","2014" }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Where Expression</strong></p>
        <p>Select all the objects in an array where the expression is true. Jekyll v3.2.0 & later.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.members | where_exp:"item",
"item.graduation_year == 2014" }}{% endraw %}</code>
         <code class="filter">{% raw %}{{ site.members | where_exp:"item",
"item.graduation_year < 2014" }}{% endraw %}</code>
         <code class="filter">{% raw %}{{ site.members | where_exp:"item",
"item.projects contains 'foo'" }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Group By</strong></p>
        <p>Group an array's items by a given property.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.members | group_by:"graduation_year" }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">[{"name"=>"2013", "items"=>[...]},
{"name"=>"2014", "items"=>[...]}]</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>XML Escape</strong></p>
        <p>Escape some text for use in XML.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.content | xml_escape }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>CGI Escape</strong></p>
        <p>
          CGI escape a string for use in a URL. Replaces any special characters
          with appropriate %XX replacements.
        </p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "foo,bar;baz?" | cgi_escape }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">foo%2Cbar%3Bbaz%3F</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>URI Escape</strong></p>
        <p>
          URI escape a string.
        </p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "foo, bar \baz?" | uri_escape }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">foo,%20bar%20%5Cbaz?</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Number of Words</strong></p>
        <p>Count the number of words in some text.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.content | number_of_words }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">1337</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Array to Sentence</strong></p>
        <p>Convert an array into a sentence. Useful for listing tags. Optional argument for connector.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.tags | array_to_sentence_string }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">foo, bar, and baz</code>
        </p>
        <p>
         <code class="filter">{% raw %}{{ page.tags | array_to_sentence_string: 'or' }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">foo, bar, or baz</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Markdownify</strong></p>
        <p>Convert a Markdown-formatted string into HTML.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.excerpt | markdownify }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Smartify</strong></p>
        <p>Convert "quotes" into &ldquo;smart quotes.&rdquo;</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.title | smartify }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Converting Sass/SCSS</strong></p>
        <p>Convert a Sass- or SCSS-formatted string into CSS.</p>
      </td>
      <td class="align-center">
        <p>
          <code class="filter">{% raw %}{{ some_scss | scssify }}{% endraw %}</code>
          <code class="filter">{% raw %}{{ some_sass | sassify }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Slugify</strong></p>
        <p>Convert a string into a lowercase URL "slug". See below for options.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "The _config.yml file" | slugify }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">the-config-yml-file</code>
        </p>
        <p>
         <code class="filter">{% raw %}{{ "The _config.yml file" | slugify: 'pretty' }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">the-_config.yml-file</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Data To JSON</strong></p>
        <p>Convert Hash or Array to JSON.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.data.projects | jsonify }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Normalize Whitespace</strong></p>
        <p>Replace any occurrence of whitespace with a single space.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "a \n b" | normalize_whitespace }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Sort</strong></p>
        <p>Sort an array. Optional arguments for hashes: 1.&nbsp;property name 2.&nbsp;nils order (<em>first</em> or <em>last</em>).</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.tags | sort }}{% endraw %}</code>
        </p>
        <p>
         <code class="filter">{% raw %}{{ site.posts | sort: 'author' }}{% endraw %}</code>
        </p>
        <p>
         <code class="filter">{% raw %}{{ site.pages | sort: 'title', 'last' }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Sample</strong></p>
        <p>Pick a random value from an array. Optional: pick multiple values.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.pages | sample }}{% endraw %}</code>
        </p>
        <p>
         <code class="filter">{% raw %}{{ site.pages | sample:2 }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>To Integer</strong></p>
        <p>Convert a string or boolean to integer.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ some_var | to_integer }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Array Filters</strong></p>
        <p>Push, pop, shift, and unshift elements from an Array.</p>
        <p>These are <strong>NON-DESTRUCTIVE</strong>, i.e. they do not mutate the array, but rather make a copy and mutate that.</p>
      </td>
      <td class="align-center">
        <p>
          <code class="filter">{% raw %}{{ page.tags | push: 'Spokane' }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">['Seattle', 'Tacoma', 'Spokane']</code>
        </p>
        <p>
          <code class="filter">{% raw %}{{ page.tags | pop }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">['Seattle']</code>
        </p>
        <p>
          <code class="filter">{% raw %}{{ page.tags | shift }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">['Tacoma']</code>
        </p>
        <p>
          <code class="filter">{% raw %}{{ page.tags | unshift: "Olympia" }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">['Olympia', 'Seattle', 'Tacoma']</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Inspect</strong></p>
        <p>Convert an object into its String representation for debugging.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ some_var | inspect }}{% endraw %}</code>
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

### Options for the `slugify` filter

The `slugify` filter accepts an option, each specifying what to filter.
The default is `default`. They are as follows (with what they filter):

- `none`: no characters
- `raw`: spaces
- `default`: spaces and non-alphanumeric characters
- `pretty`: spaces and non-alphanumeric characters except for `._~!$&'()+,;=@`

## Tags

### Includes

If you have small page fragments that you want to include in multiple places on your site, you can use the `include` tag:

```liquid
{% raw %}{% include footer.html %}{% endraw %}
```

Jekyll expects all include files to be placed in an `_includes` directory at the root of your source directory. This will embed the contents of `<source>/_includes/footer.html` into the calling file.

### Including files relative to another file

You can also choose to include file fragments relative to the current file by using the `include_relative` tag:

```liquid
{% raw %}{% include_relative somedir/footer.html %}{% endraw %}
```

You won't need to place your included content within the `_includes` directory. Instead,
the inclusion is specifically relative to the file where the tag is being used. For example,
if `_posts/2014-09-03-my-file.markdown` uses the `include_relative` tag, the included file
must be within the `_posts` directory, or one of its subdirectories. 

Note that you cannot use the `../` syntax to specify an include location that refers to a higher-level directory.

All the other capabilities of the `include` tag are available to the `include_relative` tag,
such as using variables.

### Using variables names for the include file

The name of the file you want to embed can be specified as a variable instead of an actual file name. For example, suppose you defined a variable in your page's frontmatter like this:

```yaml
---
title: My page
my_variable: footer_company_a.html
---
```

You could then reference that variable in your include:

```liquid
{% raw %}{% include {{page.my_variable}} %}{% endraw %}
```

In this example, the include would insert the file footer_company_a.html from the \_includes directory.

### Passing parameters to includes

You can also pass parameters to an include. For example, suppose you have a file called note.html in your \_includes folder that contains this formatting: 
 
```liquid
{% raw %}<div markdown="span" class="alert alert-info" role="alert">
<i class="fa fa-info-circle"></i> <b>Note:</b> {{include.content}}
</div>{% endraw %}
```

The {% raw %}`{{include.content}}`{% endraw %} is a parameter gets populated when you call the include and specify a value for that parameter, like this:

```liquid
{% raw %}{% include note.html content="This is my sample note." %} {% endraw %}
```

The value of `content` (which is `This is my sample note`) will be inserted into the {% raw %}`{{include.content}}`{% endraw %} parameter.

Passing parameters to includes is especially helpful when you want to hide away complex formatting from your Markdown content. 

For example, images with figure captions often have complicated formatting that you might want to simplify through an include with parameters. Here's an example:

```html 
<figure><a href="http://jekyllrb.com"><img src="logo.png" 
style="max-width: 200px;" alt="Jekyll logo" /><figcaption>
This is the Jekyll logo</figcaption></figure>
```

You could templatize this content in your include and make each value available as a parameter, like this:

```liquid
{% raw %}<figure>{% if {{include.url}} %}<a href="{{include.url}}">
{% endif %}<img src="{{include.file}}" {% if {{include.max-width}} 
%} style="max-width: {{include.max-width}}" {% endif %} 
alt="{{include.alt}}" />{% if {{include.url}} %}</a>{% endif %}
{% if {{include.caption}} %}<figcaption>{{include.caption}}
</figcaption>{% endif %}</figure>{% endraw %}
```

This include contains 5 parameters:
    
* `url`
* `max-width`
* `file`
* `alt`
* `caption`

To account for optional parameters, the include uses `if` tags with the parameters. For example, `{% raw %}if {{include.url}}{% endraw %}` will include the `url` only if the `url` parameter is specified in the include.

Here's an example that passes all the parameters to this include (the include file is named image.html):

```liquid
{% raw %}{% include image.html url="http://jekyllrb.com" 
max-width="200px" file="logo.png" alt="Jekyll logo" 
caption="This is the Jekyll logo." %} {% endraw %}
```

The result is the original HTML code shown earlier. 

You can create includes that act as templates for a variety of uses &mdash; inserting audio or video clips, alerts, special formatting, and more.

### Passing parameter variables to includes

Suppose the parameter you want to pass to the include is a variable rather than a string. For example, you might be using {% raw %}`{{site.product_name}}`{% endraw %} to refer to every instance of your product rather than the actual hard-coded name. (In this case, your _config.yml file would have a key called `product_name` with a value of your product's name.)

The string you pass to your include parameter can't contain curly braces. For example, you can't pass a parameter that contains this: {% raw %}`"The latest version of {{site.product_name}} is now available."`{% endraw %} 

If you want to include this variable in your parameter that you pass to an include, you need to store the entire parameter as a variable before passing it to the include. You can use `capture` tags to create the variable:

```liquid
{% raw %}{% capture download_note %}The latest version of 
{{site.product_name}} is now available.{% endcapture %}{% endraw %}
```

Then pass this captured variable into the parameter for the include. Omit the quotation marks around the parameter content because it's no longer a string (it's a variable):

```liquid
{% raw %}{% include note.html content=download_note %}{% endraw %}
```

### Passing references to YAML files as parameter values
 
Instead of passing string variables to the include, you can pass a reference to a YAML data file stored in the \_data folder. 

Here's an example. In the \_data folder, suppose you have a YAML file called profiles.yml. Its content looks like this:
 
```yaml
- name: John Doe
  login_age: old
  image: johndoe.jpg

- name: Jane Doe
  login_age: new
  image: janedoe.jpg
```

In the \_includes folder, you have a file called spotlight.html with this code:

```liquid
{% raw %}{% for person in {{include.participants}} %}
{% if person.login_age == "new" %}
{{person.name}}
{% endif %}
{% endfor %}{% endraw %}
```

Now when you include the spotlight.html file, you can submit the YAML file as a parameter:

```
{% raw %}{% include spotlight.html participants=site.data.profiles %}{% endraw %}
```

In this instance, `site.data.profiles` gets inserted in place of {% raw %}`{{include.participants}}`{% endraw %} in the include, and the Liquid logic processes. The result will be `Jane Doe`. 

### Code snippet highlighting

Jekyll has built in support for syntax highlighting of over 60 languages
thanks to [Rouge](http://rouge.jneen.net). Rouge is the default highlighter
in Jekyll 3 and above. To use it in Jekyll 2, set `highlighter` to `rouge`
and ensure the `rouge` gem is installed properly.

Alternatively, you can use [Pygments](http://pygments.org) to highlight
your code snippets. To use Pygments, you must have Python installed on your
system, have the `pygments.rb` gem installed and set `highlighter` to
`pygments` in your site's configuration file. Pygments supports [over 100
languages](http://pygments.org/languages/)

To render a code block with syntax highlighting, surround your code as follows:

```liquid
{% raw %}
{% highlight ruby %}
def foo
  puts 'foo'
end
{% endhighlight %}
{% endraw %}
```

The argument to the `highlight` tag (`ruby` in the example above) is the
language identifier. To find the appropriate identifier to use for the language
you want to highlight, look for the “short name” on the [Rouge
wiki](https://github.com/jayferd/rouge/wiki/List-of-supported-languages-and-lexers)
or the [Pygments' Lexers page](http://pygments.org/docs/lexers/).

#### Line numbers

There is a second argument to `highlight` called `linenos` that is optional.
Including the `linenos` argument will force the highlighted code to include line
numbers. For instance, the following code block would include line numbers next
to each line:

```liquid
{% raw %}
{% highlight ruby linenos %}
def foo
  puts 'foo'
end
{% endhighlight %}
{% endraw %}
```

#### Stylesheets for syntax highlighting

In order for the highlighting to show up, you’ll need to include a highlighting
stylesheet. For an example stylesheet you can look at
[syntax.css](https://github.com/mojombo/tpw/tree/master/css/syntax.css). These
are the same styles as used by GitHub and you are free to use them for your own
site. If you use `linenos`, you might want to include an additional CSS class
definition for the `.lineno` class in `syntax.css` to distinguish the line
numbers from the highlighted code.

### Link

If you want to include a link to a collection's document, a post, a page
or a file the `link` tag will generate the correct permalink URL for the path
you specify.

You must include the file extension when using the `link` tag.

```liquid
{% raw %}
{{ site.baseurl }}{% link _collection/name-of-document.md %}
{{ site.baseurl }}{% link _posts/2016-07-26-name-of-post.md %}
{{ site.baseurl }}{% link news/index.html %}
{{ site.baseurl }}{% link /assets/files/doc.pdf %}
{% endraw %}
```

You can also use this tag to create a link in Markdown as follows:

```liquid
{% raw %}
[Link to a document]({{ site.baseurl }}{% link _collection/name-of-document.md %})
[Link to a post]({{ site.baseurl }}{% link _posts/2016-07-26-name-of-post.md %})
[Link to a page]({{ site.baseurl }}{% link news/index.html %})
[Link to a file]({{ site.baseurl }}{% link /assets/files/doc.pdf %})
{% endraw %}
```

### Post URL

If you would like to include a link to a post on your site, the `post_url` tag
will generate the correct permalink URL for the post you specify.

```liquid
{% raw %}
{{ site.baseurl }}{% post_url 2010-07-21-name-of-post %}
{% endraw %}
```

If you organize your posts in subdirectories, you need to include subdirectory
path to the post:

```liquid
{% raw %}
{{ site.baseurl }}{% post_url /subdir/2010-07-21-name-of-post %}
{% endraw %}
```

There is no need to include the file extension when using the `post_url` tag.

You can also use this tag to create a link to a post in Markdown as follows:

```liquid
{% raw %}
[Name of Link]({{ site.baseurl }}{% post_url 2010-07-21-name-of-post %})
{% endraw %}
```

### Gist

Use the `gist` tag to easily embed a GitHub Gist onto your site. This works
with public or secret gists:

```liquid
{% raw %}
{% gist parkr/931c1c8d465a04042403 %}
{% endraw %}
```

You may also optionally specify the filename in the gist to display:

```liquid
{% raw %}
{% gist parkr/931c1c8d465a04042403 jekyll-private-gist.markdown %}
{% endraw %}
```

To use the `gist` tag, you'll need to add the
[jekyll-gist](https://github.com/jekyll/jekyll-gist) gem to your project.
