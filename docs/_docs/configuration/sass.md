---
title: Sass/SCSS Options
permalink: "/docs/configuration/sass/"
---

Jekyll comes bundled with [jekyll-sass-converter](https://github.com/jekyll/jekyll-sass-converter) plugin. You can further configure the plugin by adding options to your Jekyll config under the `sass` attribute.

By default, Jekyll will look for Sass partials in the `_sass` directory relative to your site's `source` directory. You can change the default load path or specify additional load paths with the following options:

- **sass_dir** - Look for Sass partials in this directory path.
* **load_paths** - Search for additional Sass partials in this array of directory paths.

<div class="note info">
  <p>
    Note that directory paths specified in the <code>sass_dir</code> and
    <code>load_paths</code> options are resolved relative to your site's
    <code>source</code>, not relative to the location of the
    <code>_config.yml</code> file.
  </p>
</div>

### Default Configuration

```yaml
sass:
  sass_dir: _sass
  load_paths: []
  style: compressed
  sourcemap: always
  line_comments: false
```
