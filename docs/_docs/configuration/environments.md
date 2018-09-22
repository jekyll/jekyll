---
title: Environments
permalink: "/docs/configuration/environments/"
---
In the `build` (or `serve`) arguments, you can specify a Jekyll environment
and value. The build will then apply this value in any conditional statements
in your content.

For example, suppose you set this conditional statement in your code:

{% raw %}
```liquid
{% if jekyll.environment == "production" %}
   {% include disqus.html %}
{% endif %}
```
{% endraw %}

When you build your Jekyll site, the content inside the `if` statement won't be
run unless you also specify a `production` environment in the build command,
like this:

```sh
JEKYLL_ENV=production jekyll build
```

Specifying an environment value allows you to make certain content available
only within specific environments.

The default value for `JEKYLL_ENV` is `development`. Therefore if you omit
`JEKYLL_ENV` from the build arguments, the default value will be
`JEKYLL_ENV=development`. Any content inside
{% raw %}`{% if jekyll.environment == "development" %}`{% endraw %} tags will
automatically appear in the build.

Your environment values can be anything you want (not just `development` or
`production`). Some elements you might want to hide in development
environments include Disqus comment forms or Google Analytics. Conversely,
you might want to expose an "Edit me in GitHub" button in a development
environment but not include it in production environments.

By specifying the option in the build command, you avoid having to change
values in your configuration files when moving from one environment to another.

<div class="note info">
  <p>
    To switch part of your config settings depending on the environment, use the <a href="/docs/configuration/options/#build-command-options">build command option</a>, for example <code>--config _config.yml,_config_development.yml</code>. Settings in later files override settings in earlier files.
  </p>
</div>
