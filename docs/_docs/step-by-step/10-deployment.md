---
layout: step
title: 10. Deployment
---
You're almost there! In this final tutorial we'll get the site ready for
production.

## Gemfile

It's good practice to have a `Gemfile` for your site. This ensures the version
of Jekyll and other gems remains consistent across different environments.

Create `Gemfile` in the root with the following:

```
source 'https://rubygems.org'

gem 'jekyll'
```

Then run `bundle install`. This installs the gems and creates `Gemfile.lock`
which locks the current gem versions for future `bundle install`. If you ever
want to update your versions you can run `bundle update`.

When you run commands like `jekyll serve` now you'll need to prefix it with
`bundle exec` so the full command is:

```bash
bundle exec jekyll serve
```

This restricts you Ruby environment to only use gems set in your `Gemfile`.

## Plugins

Jekyll plugins allow you to create custom generated content specific to your
site. There's many [plugins](/docs/plugins/) available or you can even
write your own.

There's three official plugins which are useful on almost any Jekyll site:

* [jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap) - Creates a sitemap
file to help search engines index content
* [jekyll-feed](https://github.com/jekyll/jekyll-feed) - Creates an RSS feed of
your posts
* [jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) - Adds meta tags to help
with SEO.

To use these first you need to add them to your `Gemfile`. If you put them
in a jekyll_plugins group they'll automatically be required into Jekyll:

```
source 'https://rubygems.org'

gem 'jekyll'

group :jekyll_plugins do
  gem 'jekyll-sitemap'
  gem 'jekyll-feed'
  gem 'jekyll-seo-tag'
end
```

Now install them by running a `bundle update`.

jekyll-sitemap doesn't need any setup, it will create your sitemap on build.

For jekyll-feed and jekyll-seo you need to add tags to `_layouts/default.html`:

{% raw %}
```liquid
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>{{ page.title }}</title>
    <link rel="stylesheet" href="/assets/styles.css">
    {% feed_meta %}
    {% seo %}
  </head>
  <body>
    {% include navigation.html %}
    {{ content }}
  </body>
</html>
```
{% endraw %}

Restart your Jekyll server and check these tags are added to the `<head>`.

## Environments

Sometimes you might want to output something on your site in production but not
in development. Analytics scripts are the most common example of this.

To do this you can use [environments](/docs/configuration/environments/). You
can set the environment by using the `JEKYLL_ENV` environment variable when
running a command. For example:

```bash
JEKYLL_ENV=production jekyll build
```

By default `JEKYLL_ENV` is development. The `JEKYLL_ENV` is available to you
in liquid using `jekyll.environment`. So to only output the analytics script
on production you would do the following:


{% if jekyll.environment == "production" %}
  <script src="my-analytics-script.js"></script>
{% endif %}

## Deployment

The final step is to get the site onto a production server. The most basic way
to do this is to run a production build:

```bash
JEKYLL_ENV=production jekyll build
```

And copy the contents of `_site` to your server.

A better way is to automate this process using a [CI](/docs/deployment/automated/)
or [3rd party](/docs/deployment/third-party/).

## Wrap up

That brings us to the end of this step-by-step tutorial and the beginning of
your Jekyll journey!

* Come say hi to the [community forums](https://talk.jekyllrb.com)
* Help us make Jekyll better by [contributing](/docs/contributing/)
* Keep building Jekyll sites!
