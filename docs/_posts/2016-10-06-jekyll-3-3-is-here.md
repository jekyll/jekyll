---
title: 'Jekyll 3.3 is here with better theme support, new URL filters, and tons more'
date: 2016-10-06 11:10:38 -0700
author: parkr
version: 3.3.0
category: release
---

There are tons of great new quality-of-life features you can use in 3.3.
Three key things you might want to try:

### 1. Themes can now ship static & dynamic assets in an `/assets` directory

In Jekyll 3.2, we shipped the ability to use a theme that was packaged as a
[gem](http://guides.rubygems.org/). 3.2 included support for includes,
layouts, and sass partials. In 3.3, we're adding assets to that list.

In an effort to make theme management a bit easier, any files you put into
`/assets` in your theme will be read in as though they were part of the
user's site. This means you can ship SCSS and CoffeeScript, images and
webfonts, and so on -- anything you'd consider a part of the
*presentation*. Same rules apply here as in a Jekyll site: if it has YAML
front matter, it will be converted and rendered. No front matter, and
it will simply be copied over like a static asset.

Note that if a user has a file of the same path, the theme content will not
be included in the site, i.e. a user's `/assets/main.scss` will be read and
processed if present instead of a theme's `/assets/main.scss`.

See our [documentation on the subject]({{ "/docs/themes/#assets" | relative_url }})
for more info.

### 2. `relative_url` and `absolute_url` filters

Want a clean way to prepend the `baseurl` or `url` in your config? These
new filters have you covered. When working locally, if you set your
`baseurl` to match your deployment environment, say `baseurl: "/myproject"`,
then `relative_url` will ensure that this baseurl is prepended to anything
you pass it:

{% highlight liquid %}
{% raw %}
{{ "/docs/assets/" | relative_url }} => /myproject/docs/assets
{% endraw %}
{% endhighlight %}

By default, `baseurl` is set to `""` and therefore yields (never set to
`"/"`):

{% highlight liquid %}
{% raw %}
{{ "/docs/assets/" | relative_url }} => /docs/assets
{% endraw %}
{% endhighlight %}

A result of `relative_url` will safely always produce a URL which is
relative to the domain root. A similar principle applies to `absolute_url`.
It prepends your `baseurl` and `url` values, making absolute URLs all the
easier to make:

{% highlight liquid %}
{% raw %}
{{ "/docs/assets/" | absolute_url }} => https://jekyllrb.com/myproject/docs/assets
{% endraw %}
{% endhighlight %}

### 3. `site.url` is set by the development server

When you run `jekyll serve` locally, it starts a web server, usually at
`http://localhost:4000`, that you use to preview your site during
development. If you are using the new `absolute_url` filter, or using
`site.url` anywhere, you have probably had to create a development config
which resets the `url` value to point to `http://localhost:4000`.

No longer! When you run `jekyll serve`, Jekyll will build your site with
the value of the `host`, `port`, and SSL-related options. This defaults to
`url: http://localhost:4000`. When you are developing locally, `site.url`
will yield `http://localhost:4000`.

This happens by default when running Jekyll locally. It will not be set if
you set `JEKYLL_ENV=production` and run `jekyll serve`. If `JEKYLL_ENV` is
any value except `development` (its default value), Jekyll will not
overwrite the value of `url` in your config. And again, this only applies
to serving, not to building.

## A *lot* more!

There are dozens of bug fixes and minor improvements to make your Jekyll
experience better than ever. With every Jekyll release, we strive to bring
greater stability and reliability to your everyday development workflow.

As always, thanks to our many contributors who contributed countless hours
of their free time to making this release happen:

Anatoliy Yastreb, Anthony Gaudino, Antonio, Ashwin Maroli, Ben Balter,
Charles Horn, Chris Finazzo, Daniel Chapman, David Zhang, Eduardo
Bouças, Edward Thomson, Eloy Espinaco, Florian Thomas, Frank Taillandier,
Gerardo, Heng Kwokfu, Heng, K. (Stephen), Jeff Kolesky, Jonathan Thornton,
Jordon Bedwell, Jussi Kinnula, Júnior Messias, Kyle O'Brien, Manmeet Gill,
Mark H. Wilkinson, Marko Locher, Mertcan GÖKGÖZ, Michal Švácha, Mike
Kasberg, Nadjib Amar, Nicolas Hoizey, Nicolas Porcel, Parker Moore, Pat
Hawks, Patrick Marsceill, Stephen Checkoway, Stuart Kent, XhmikosR, Zlatan
Vasović, mertkahyaoglu, shingo-nakanishi, and vohedge.

[Full release notes]({{ "/docs/history/#v3-3-0" | relative_url }}) are available
for your perusal. If you notice any issues, please don't hesitate to file a
bug report.

Happy Jekylling!
