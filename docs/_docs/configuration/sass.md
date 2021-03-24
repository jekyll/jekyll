---
title: Sass/SCSS Options
permalink: "/docs/configuration/sass/"
---

By default, Jekyll will look for Sass partials in the `_sass` directory relative to your site's `source` directory. You can change the default load path or specify additional load paths with the following options:

- **sass_dir** - Look for Sass partials in this directory path.
* **load_paths** - An array of additional filesystem-paths which should be searched for Sass partials.

<div class="note info">
  <p>
    Note that filesystem-paths specified in the <code>sass_dir</code> and
    <code>load_paths</code> options are resolved relative to your site's
    <code>source</code>, not relative to the location of the
    <code>_config.yml</code> file.
  </p>
</div>

The following additional Sass configuration options are offered by the [jekyll-sass-converter](https://github.com/jekyll/jekyll-sass-converter) plugin.

* **style** - Sets the style of the CSS-output. Can be `nested`, `compact`, `compressed`, or `expanded`. See the [Sass docs](https://sass-lang.com/documentation/cli/dart-sass#style) for details.
* **sourcemap** - Controls when source maps shall be generated.
  * `never` — causes no source maps to be generated at all.
  * `always` — source maps will always be generated.
  * `development` — source maps will only be generated if the site is in development environment. That is, when the environment variable [`JEKYLL_ENV`]({{ '/docs/configuration/environments/' | relative_url }}) is set to `development`.
* **line_comments** - When set to `true`, the line number and filename of the source is included in the compiled CSS-file. Useful for debugging when the source map is not available, but might considerably increase the size of the generated CSS files.

### Default Configuration
```yaml
sass:
  sass_dir: _sass
  load_paths: []
  style: compressed
  sourcemap: always
  line_comments: false
```
