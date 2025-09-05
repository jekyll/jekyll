---
layout: step
title: Deployment
position: 10
---
In this final step we'll get the site ready for production.

## Gemfile

It's good practice to have a [Gemfile](/docs/ruby-101/#gemfile) for your site.
This ensures the version of Jekyll and other gems remains consistent across
different environments.

If you completed step one in this tutorial, you have already created a Gemfile. If you skipped step one, create a `Gemfile` in the root. 
The file should be called 'Gemfile' and should *not* have any extension. 
You can create a Gemfile with Bundler and then add the `jekyll` gem:

```sh
bundle init
bundle add jekyll
```

Your `Gemfile` should look something like:

```ruby
# frozen_string_literal: true
source "https://rubygems.org"

gem "jekyll"
```

Bundler installs the gems and creates a `Gemfile.lock` which locks the current 
gem versions for a future `bundle install`. If you ever want to update your gem 
versions you can run `bundle update`.

When using a `Gemfile`, you'll run commands like `jekyll serve` with
`bundle exec` prefixed. So the full command is:

```sh
bundle exec jekyll serve
```

This restricts your Ruby environment to only use gems set in your `Gemfile`.

Note: if publishing your site with GitHub Pages, you can match production
version of Jekyll by using the `github-pages` gem instead of `jekyll`
in your `Gemfile`. In this scenario you may also want to exclude `Gemfile.lock`
from your repository because GitHub Pages ignores that file.

## Plugins

Jekyll plugins allow you to create custom generated content specific to your
site. There are many [plugins](/docs/plugins/) available or you can even
write your own.

There are three official plugins which are useful on almost any Jekyll site:

* [jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap) - Creates a sitemap
file to help search engines index content
* [jekyll-feed](https://github.com/jekyll/jekyll-feed) - Creates an RSS feed for
your posts
* [jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) - Adds meta tags to help
with SEO

To use these first you need to add them to your `Gemfile`. If you put them
in a `jekyll_plugins` group they'll automatically be required into Jekyll:

```ruby
source 'https://rubygems.org'

gem "jekyll"

group :jekyll_plugins do
  gem "jekyll-sitemap"
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
end
```

Then add these lines to your `_config.yml`:

```yaml
plugins:
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-seo-tag
```

Now install them by running a `bundle update`.

`jekyll-sitemap` doesn't need any setup, it will create your sitemap on build.

For `jekyll-feed` and `jekyll-seo-tag` you need to add tags to
`_layouts/default.html`:

{% raw %}
```liquid
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>{{ page.title }}</title>
    <link rel="stylesheet" href="/assets/css/styles.css">
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

Sometimes you might want to output something in production but not
in development. Analytics scripts are the most common example of this.

To do this you can use [environments](/docs/configuration/environments/). You
can set the environment by using the `JEKYLL_ENV` environment variable when
running a command. For example:

```sh
JEKYLL_ENV=production bundle exec jekyll build
```
{: .note .warning}
If you are using Windows operating system, you need to instead set this variable in a command of its own: `set JEKYLL_ENV=production` Then start Jekyll like always.

By default `JEKYLL_ENV` is development. The `JEKYLL_ENV` is available to you
in liquid using `jekyll.environment`. So to only output the analytics script
on production you would do the following:

{% raw %}
```liquid
{% if jekyll.environment == "production" %}
  <script src="my-analytics-script.js"></script>
{% endif %}
```
{% endraw %}

## Deployment

The final step is to get the site onto a production server. The most basic way
to do this is to run a production build:

```sh
JEKYLL_ENV=production bundle exec jekyll build
```

And then copy the contents of `_site` to your server.

<div class="note warning">
  <h5>Destination folders are cleaned on site builds</h5>
  <p>
    The contents of <code>_site</code> are automatically cleaned, by default, when
    the site is built. Files or folders that are not created by your site's build
    process will be removed.
  </p>
  <p>
    Some files could be retained by specifying them within the <code>keep_files</code>
    configuration directive. Other files could be retained by keeping them in your
    assets directory.
  </p>
</div>

A better way is to automate this process using a [CI](/docs/deployment/automated/)
or [3rd party](/docs/deployment/third-party/).

## Wrap up

That brings us to the end of this step-by-step tutorial and the beginning of
your Jekyll journey!

* Come say hi to the [community forums](https://talk.jekyllrb.com)
* Help us make Jekyll better by [contributing](/docs/contributing/)
* Keep building Jekyll sites!
