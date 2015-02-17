---
layout: docs
title: Basic Usage
permalink: /docs/usage/
---

The Jekyll gem makes a `jekyll` executable available to you in your Terminal
window. You can use this command in a number of ways:

{% highlight bash %}
$ jekyll build
# => The current folder will be generated into ./_site

$ jekyll build --destination <destination>
# => The current folder will be generated into <destination>

$ jekyll build --source <source> --destination <destination>
# => The <source> folder will be generated into <destination>

$ jekyll build --watch
# => The current folder will be generated into ./_site,
#    watched for changes, and regenerated automatically.
{% endhighlight %}

<div class="note warning">
  <h5>Destination folders are cleaned on site builds</h5>
  <p>
    The contents of <code>&lt;destination&gt;</code> are automatically
    cleaned, by default, when the site is built. Files or folders that are not
    created by your site will be removed. Files and folders you wish to retain 
    in <code>&lt;destination&gt;</code> may be specified within the <code>&lt;keep_files&gt;</code> 
    configuration directive.
  </p>
  <p>
    Do not use an important location for <code>&lt;destination&gt;</code>; 
    instead, use it as a staging area and copy files from there to your web server.
  </p>
</div>

Jekyll also comes with a built-in development server that will allow you to
preview what the generated site will look like in your browser locally.

{% highlight bash %}
$ jekyll serve
# => A development server will run at http://localhost:4000/
# Auto-regeneration: enabled. Use `--no-watch` to disable.

$ jekyll serve --detach
# => Same as `jekyll serve` but will detach from the current terminal.
#    If you need to kill the server, you can `kill -9 1234` where "1234" is the PID.
#    If you cannot find the PID, then do, `ps aux | grep jekyll` and kill the instance. [Read more](http://unixhelp.ed.ac.uk/shell/jobz5.html).
{% endhighlight %}

<div class="note info">
  <h5>Be aware of default behavior</h5>
  <p>
    As of version 2.4, the <code>serve</code> command will watch for changes automatically. To disable this, you can use <code>jekyll serve --no-watch</code>, which preserves the old behavior.
  </p>
</div>

{% highlight bash %}
$ jekyll serve --no-watch
# => Same as `jekyll serve` but will not watch for changes.
{% endhighlight %}

These are just a few of the available [configuration options](../configuration/).
Many configuration options can either be specified as flags on the command line,
or alternatively (and more commonly) they can be specified in a `_config.yml`
file at the root of the source directory. Jekyll will automatically use the
options from this file when run. For example, if you place the following lines
in your `_config.yml` file:

{% highlight yaml %}
source:      _source
destination: _deploy
{% endhighlight %}

Then the following two commands will be equivalent:

{% highlight bash %}
$ jekyll build
$ jekyll build --source _source --destination _deploy
{% endhighlight %}

For more about the possible configuration options, see the
[configuration](../configuration/) page.

If you're interested in browsing these docs on-the-go, install the
`jekyll-docs` gem and run `jekyll docs` in your terminal.
