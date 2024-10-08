---
title: Sass/SCSS Options
permalink: "/docs/configuration/sass/"
---

Jekyll comes bundled with [jekyll-sass-converter](https://github.com/jekyll/jekyll-sass-converter) plugin. By default, Jekyll will look for Sass partials in the `_sass` directory relative to your site's `source` directory.

You can further configure the plugin by adding options to your Jekyll config under the `sass` attribute. See the [plugin's documentation](https://github.com/jekyll/jekyll-sass-converter#usage) for details and for its default values.

{:.note .info}
If you see a warning in VSCode regarding `@import "main";`, you may ignore it as the same does not affect the functionality of the SCSS code in Jekyll. However, Jekyll 4 does not allow importing a `main` sass partial (`_sass/main.scss`) from a sass page of a same name, viz. `css/main.scss`.

<div class="note info">
  <p>
    Note that directory paths specified in the <code>sass</code> configuration
    are resolved relative to your site's <code>source</code>, not relative to the location of the <code>_config.yml</code> file.
  </p>
</div>
