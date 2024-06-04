---
title: Sass/SCSS Options
permalink: "/docs/configuration/sass/"
---

Jekyll comes bundled with [jekyll-sass-converter](https://github.com/jekyll/jekyll-sass-converter) plugin. By default, Jekyll will look for Sass partials in the `_sass` directory relative to your site's `source` directory.

You can further configure the plugin by adding options to your Jekyll config under the `sass` attribute. See the [plugin's documentation](https://github.com/jekyll/jekyll-sass-converter#usage) for details and for its default values.

{:.note .info}
**Note:** If you see a warning in VSCode regarding `@import "main";`, it is a known issue with VSCode and does not affect the functionality of the SCSS code in Jekyll. For more details, see [this discussion](https://talk.jekyllrb.com/t/an-error-in-styles-scss-which-should-be-ignored/8264) and [VSCode issue](https://github.com/microsoft/vscode-cpptools/issues/1231).



<div class="note info">
  <p>
    Note that directory paths specified in the <code>sass</code> configuration
    are resolved relative to your site's <code>source</code>, not relative to the location of the <code>_config.yml</code> file.
  </p>
</div>
