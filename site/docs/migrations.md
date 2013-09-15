---
layout: docs
title: Blog migrations
prev_section: variables
next_section: templates
permalink: /docs/migrations/
---

If you’re switching to Jekyll from another blogging system, Jekyll’s importers
can help you with the move. Most methods listed on this page require read access
to the database from your old system to generate posts for Jekyll. Each method
generates `.markdown` posts in the `_posts` directory based on the entries in
the foreign system.

## Preparing for migrations

Because the importers have many of their own dependencies, they are made
available via a separate gem called
[`jekyll-import`](https://github.com/jekyll/jekyll-import). To use them, all
you need to do is install the gem, and they will become available as part of
Jekyll's standard command line interface.

{% highlight bash %}
$ gem install jekyll-import --pre
{% endhighlight %}

You should now be all set to run the importers below. If you ever get stuck, you
can see help for each importer:

{% highlight bash %}
$ jekyll help import           # => See list of importers
$ jekyll help import IMPORTER  # => See importer specific help
{% endhighlight %}

Where IMPORTER is the name of the specific importer.

<div class="note info">
  <h5>Note: Always double-check migrated content</h5>
  <p>

    Importers may not distinguish between published or private posts, so
    you should always check that the content Jekyll generates for you appears as
    you intended.

  </p>
</div>

<!-- TODO all these need to be fixed -->

## WordPress

### WordPress export files

If hpricot is not already installed, you will need to run `gem install hpricot`.
Next, export your blog using the WordPress export utility. Assuming that the
exported file is saved as `wordpress.xml`, here is the command you need to run:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/wordpressdotcom";
    JekyllImport::WordpressDotCom.process({ :source => "wordpress.xml" })'
{% endhighlight %}

<div class="note">
  <h5>ProTip™: WordPress.com Export Tool</h5>
  <p markdown="1">If you are migrating from a WordPress.com account, you can
  access the export tool at the following URL:
  `https://YOUR-USER-NAME.wordpress.com/wp-admin/export.php`.</p>
</div>

### Using WordPress MySQL server connection

If you want to import using a direct connection to the WordPress MySQL server,
here's how:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/wordpress";
    JekyllImport::WordPress.process({:dbname => "database", :user => "user", :pass => "pass"})'
{% endhighlight %}

If you are using Webfaction and have to set up an [SSH
tunnel](http://docs.webfaction.com/user-guide/databases.html?highlight=mysql#starting-an-ssh-tunnel-with-ssh),
be sure to make the hostname (`127.0.0.1`) explicit, otherwise MySQL may block
your access based on `localhost` and `127.0.0.1` not being equivalent in its
authentication system:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/wordpress";
    JekyllImport::WordPress.process({:host => "127.0.0.1", :dbname => "database", :user => "user", :pass => "pass"})'
{% endhighlight %}

### Further WordPress migration alternatives

While the above methods work, they do not import much of the metadata that is
usually stored in WordPress posts and pages. If you need to export things like
pages, tags, custom fields, image attachments and so on, the following resources
might be useful to you:

- [Exitwp](https://github.com/thomasf/exitwp) is a configurable tool written in
  Python for migrating one or more WordPress blogs into Jekyll (Markdown) format
  while keeping as much metadata as possible. Exitwp also downloads attachments
  and pages.
- [A great
  article](http://vitobotta.com/how-to-migrate-from-wordpress-to-jekyll/) with a
  step-by-step guide for migrating a WordPress blog to Jekyll while keeping most
  of the structure and metadata.
- [wpXml2Jekyll](https://github.com/theaob/wpXml2Jekyll) is an executable
  windows application for creating Markdown posts from your WordPress XML file.

## Drupal

If you’re migrating from [Drupal](http://drupal.org), there are two migrators
for you, depending upon your Drupal version:
- [Drupal 6](https://github.com/jekyll/jekyll-import/blob/v0.1.0.beta1/lib/jekyll/jekyll-import/drupal6.rb)
- [Drupal 7](https://github.com/jekyll/jekyll-import/blob/v0.1.0.beta1/lib/jekyll/jekyll-import/drupal7.rb)

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/drupal6";
    JekyllImport::Drupal6.process("dbname", "user", "pass")'
# ... or ...
$ ruby -rubygems -e 'require "jekyll/jekyll-import/drupal7";
    JekyllImport::Drupal7.process("dbname", "user", "pass")'
{% endhighlight %}

If you are connecting to a different host or need to specify a table prefix for
your database, you may optionally add those two parameters to the end of either
Drupal migrator execution:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/drupal6";
    JekyllImport::Drupal6.process("dbname", "user", "pass", "host", "table_prefix")'
# ... or ...
$ ruby -rubygems -e 'require "jekyll/jekyll-import/drupal7";
    JekyllImport::Drupal7.process("dbname", "user", "pass", "host", "table_prefix")'
{% endhighlight %}

## Movable Type

To import posts from Movable Type:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/mt";
    JekyllImport::MT.process("database", "user", "pass")'
{% endhighlight %}

## Typo

To import posts from Typo:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/typo";
    JekyllImport::Typo.process("database", "user", "pass")'
{% endhighlight %}

This code has only been tested with Typo version 4+.

## TextPattern

To import posts from TextPattern:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/textpattern";
    JekyllImport::TextPattern.process("database_name", "username", "password", "hostname")'
{% endhighlight %}

You will need to run the above from the parent directory of your `_import`
folder. For example, if `_import` is located in `/path/source/_import`, you will
need to run this code from `/path/source`. The hostname defaults to `localhost`,
all other variables are required. You may need to adjust the code used to filter
entries. Left alone, it will attempt to pull all entries that are live or
sticky.

## Mephisto

To import posts from Mephisto:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/mephisto";
    JekyllImport::Mephisto.process("database", "user", "password")'
{% endhighlight %}

If your data is in Postgres, you should do this instead:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/mephisto";
    JekyllImport::Mephisto.postgres({:database => "database", :username=>"username", :password =>"password"})'
{% endhighlight %}

## Blogger (Blogspot)

To import posts from Blogger, see [this post about migrating from Blogger to
Jekyll](http://blog.coolaj86.com/articles/migrate-from-blogger-to-jekyll.html). If
that doesn’t work for you, you might want to try some of the following
alternatives:

- [@kennym](https://github.com/kennym) created a [little migration
  script](https://gist.github.com/1115810), because the solutions in the
  previous article didn't work out for him.
- [@ngauthier](https://github.com/ngauthier) created [another
  importer](https://gist.github.com/1506614) that imports comments, and does so
  via blogger’s archive instead of the RSS feed.
- [@juniorz](https://github.com/juniorz) created [yet another
  importer](https://gist.github.com/1564581) that works for
  [Octopress](http://octopress.org). It is like [@ngauthier’s
  version](https://gist.github.com/1506614) but separates drafts from posts, as
  well as importing tags and permalinks.

## Posterous

To import posts from your primary Posterous blog:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/posterous";
    JekyllImport::Posterous.process("my_email", "my_pass")'
{% endhighlight %}

For any other Posterous blog on your account, you will need to specify the
`blog_id` for the blog:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/posterous";
    JekyllImport::Posterous.process("my_email", "my_pass", "blog_id")'
{% endhighlight %}

There is also an [alternative Posterous
migrator](https://github.com/pepijndevos/jekyll/blob/patch-1/lib/jekyll/migrators/posterous.rb)
that maintains permalinks and attempts to import images too.

## Tumblr

To import posts from Tumblr:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/jekyll-import/tumblr";
    JekyllImport::Tumblr.process(url, format, grab_images, add_highlights, rewrite_urls)'
# url    - String: your blog's URL
# format - String: the output file extension. Use "md" to have your content
#          converted from HTML to Markdown. Defaults to "html".
# grab_images    - Boolean: whether to download images as well. Defaults to false.
# add_highlights - Boolean: whether to wrap code blocks (indented 4 spaces) in a Liquid
                   "highlight" tag. Defaults to false.
# rewrite_urls   - Boolean: whether to write pages that redirect from the old Tumblr paths
                   to the new Jekyll paths. Defaults to false.
{% endhighlight %}

## Other Systems

If you have a system for which there is currently no migrator, consider writing
one and sending us [a pull request](https://github.com/jekyll/jekyll-import).
