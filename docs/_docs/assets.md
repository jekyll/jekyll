---
title: Assets
permalink: /docs/assets/
---

Jekyll provides built-in support for [Sass](https://sass-lang.com/)
and can work with [CoffeeScript](https://coffeescript.org/) via a Ruby gem.
In order to use them, you must first create a file with the proper extension
name (one of `.sass`, `.scss`, or `.coffee`) and
***start the file with two lines of triple dashes***, like this:

```sass
---
---

// start content
.my-definition
  font-size: 1.2em
```

Jekyll treats these files the same as a regular page, in that the output file
will be placed in the same directory that it came from. For instance, if you
have a file named `css/styles.scss` in your site's source folder, Jekyll
will process it and put it in your site's destination folder under
`css/styles.css`.

<div class="note info">
  <h5>Jekyll processes all Liquid filters and tags in asset files</h5>
  <p>If you are using <a href="https://mustache.github.io">Mustache</a>
     or another JavaScript templating language that conflicts with
     the <a href="/docs/templates/">Liquid template syntax</a>, you
     will need to place <code>{&#37; raw &#37;}</code> and
     <code>{&#37; endraw &#37;}</code> tags around your code.</p>
</div>

## Sass/SCSS

Jekyll allows you to customize your Sass conversion in certain ways.

Place all your partials in your `sass_dir`, which defaults to
`<source>/_sass`. Place your main SCSS or Sass files in the place you want
them to be in the output file, such as `<source>/css`. For an example, take
a look at [this example site using Sass support in Jekyll][example-sass].

If you are using Sass `@import` statements, you'll need to ensure that your
`sass_dir` is set to the base directory that contains your Sass files:

```yaml
sass:
    sass_dir: _sass
```

The Sass converter will default the `sass_dir` configuration option to
`_sass`.

[example-sass]: https://github.com/jekyll/jekyll-sass-converter/tree/master/docs

<div class="note info">
  <h5>The <code>sass_dir</code> is only used by Sass</h5>
  <p>

    Note that the <code>sass_dir</code> becomes the load path for Sass imports,
    nothing more. This means that Jekyll does not know about these files
    directly. Any files here should not contain the empty front matter as
    described above. If they do, they'll not be transformed as described above. This
    folder should only contain imports.

  </p>
</div>

You may also specify the output style with the `style` option in your
`_config.yml` file:

```yaml
sass:
    style: compressed
```

These are passed to Sass, so any output style options Sass supports are valid
here, too.


## Coffeescript

To enable Coffeescript in Jekyll 3.0 and up you must

* Install the `jekyll-coffeescript` gem
* Ensure that your `_config.yml` is up-to-date and includes the following:

```yaml
plugins:
  - jekyll-coffeescript
```
