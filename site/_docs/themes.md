---
layout: docs
title: Themes
permalink: /docs/themes/
---

<div class="note unreleased">
  <h5>This feature is unreleased!</h5>
  <p>
    Jekyll 3.0 and 3.1 do NOT have the ability to add themes in this way.
    The documentation below is for an unreleased version of Jekyll and
    cannot be used at the moment.
  </p>
</div>

Jekyll has an extensive theme system, which allows you to leverage community-maintained templates and styles to customize your site's presentation. Jekyll themes package layouts, includes, and stylesheets in a way that can be overridden by your site's content.

## Installing a theme

1. To install a theme, first, add the theme to your site's `Gemfile`:

        gem 'my-awesome-jekyll-theme'

2. Save the changes to your `Gemfile`
3. Run the command `bundle install` to install the theme
4. Finally, activate the theme by adding the following to your site's `_config.yml`:

        theme: my-awesome-jekyll-theme

You can have multiple themes listed in your site's Gemfile, but only one theme can be selected in your site's `_config.yml`.
{: .note .info }

## Overriding theme defaults

Jekyll themes set default layouts, includes, and stylesheets, that can be overridden by your site's content. For example, if your selected theme has a `page` layout, you can override the theme's layout by creating your own `page` layout in the `_layouts` folder (e.g., `_layouts/page.html`).

Jekyll will look first to your site's content, before looking to the theme's defaults, for any requested file in the following folders:

* `/_layouts`
* `/_includes`
* `/_sass`

Refer to your selected theme's documentation and source repository for more information on what files you can override.
{: .note .info}

## Creating a theme

Jekyll themes are distributed as Ruby gems. The only required file is the [Ruby Gemspec](http://guides.rubygems.org/specification-reference/). Here's an example of a minimal Gemspec for the `my-awesome-jekyll-theme` theme, saved as `/my-awsome-jekyll-theme.gemspec`:

{% highlight ruby %}
Gem::Specification.new do |s|
  s.name     = '<THEME TITLE>'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = '<THEME DESCRIPTION>'
  s.author   = '<YOUR NAME>'
  s.email    = '<YOUR EMAIL>'
  s.homepage = 'https://github.com/jekyll/my-awesome-jekyll-theme'
  s.files    = `git ls-files -z`.split("\x0").grep(%r{^_(sass|includes|layouts)/})
end
{% endhighlight %}

### Layouts and includes

Theme layouts and includes work just like they work in any Jekyll site. Place layouts in your theme's `/_layouts` folder, and place includes in your themes `/_includes` folder.

For example, if your theme has a `/_layouts/page.html` file, and a page has `layout: page` in its YAML front matter, Jekyll will first look to the site's `_layouts` folder for a the `page` layout, and if none exists, will use your theme's `page` layout.

### Stylesheets

Your theme's stylesheets should be placed in your theme's `/_sass` folder, again, just as you would when authoring a Jekyll site. Your theme's styles can be included in the user's stylesheet using the `@import` directive.

### Documenting your theme

Your theme should include a `/README.md` file, which explains how site authors can install and use your theme. What layouts are included? What includes? Do they need to add anything special to their site's configuration file?

### Adding a screenshot

Themes are visual. Show users what your theme looks like by including a screenshot as `/screenshot.png` within your theme's repository where it can be retrieved programatically. You can also include this screenshot within your theme's documentation.

### Previewing your theme

To preview your theme as you're authoring it, it may be helpful to add dummy content in, for example, `/index.html` and `/page.html` files. This will allow you to use the `jekyll build` and `jekyll serve` commands to preview your theme, just as you'd preview a Jekyll site.

If you do preview your theme locally, be sure to add `/_site` to your theme's `.gitignore` file to prevent the compiled site from also being included when you distribute your theme.
{: .info .note}

### Publishing your theme

Themes are published via [RubyGems.org](https://rubygems.org). You'll need a RubyGems account, which you can [create for free](https://rubygems.org/sign_up).

1. First, package your theme, by running the following command, replacing `my-awesome-jekyll-theme` with the name of your theme:

        gem build my-awesome-jekyll-theme.gemspec

2. Next, push your packaged theme up to the RubyGems service, by running the following command, again replacing `my-awesome-jekyll-theme` with the name of your theme:

        gem push my-awesome-jekyll-theme-*.gem
