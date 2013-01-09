---
layout: docs
title: Blog migrations
prev_section: variables
next_section: templates
---

If you’re switching to Jekyll from another blogging system, Jekyll’s migrators can help you with the move. Most methods listed on this page require read access to the database to generate posts from your old system. Each method generates `.markdown` posts in the `_posts` directory based on the entries in the database.

## Preparing for migrations

The migrators are [built-in to the Jekyll gem](https://github.com/mojombo/jekyll/tree/master/lib/jekyll/migrators), and require a few things to be set up in your project directory before they are run. This should all be done from the root folder of your Jekyll project.

{% highlight bash %}
$ mkdir _import
$ gem install sequel mysqlplus
{% endhighlight %}

You should now be all set to run the migrators below.

<div class="note info">
  <h5>Note: Always double-check migrated content</h5>
  <p>Import scripts may not distinguish between published or private posts, so you should always check that the content Jekyll generates for you appears as you intended.</p>
</div>

## WordPress

### Wordpress export files

If hpricot is not already installed, you will need to run `gem install hpricot`. Next, export your blog using the Wordpress export utility. Assuming that exported file is saved as `wordpress.xml`, here is the command you need to run:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/wordpressdotcom";
    Jekyll::WordpressDotCom.process("wordpress.xml")'
{% endhighlight %}

<div class="note">
  <h5>ProTip™: Wordpress.com Export Tool</h5>
  <p>If you are migrating from a Wordpress.com account, you can access the export tool at the following URL: `https://YOUR-USER-NAME.wordpress.com/wp-admin/export.php`.</p>
</div>

### Using Wordpress MySQL server connection

If you want to import using a direct connection to the Wordpress MySQL server, here's how:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/wordpress";
    Jekyll::WordPress.process("database", "user", "pass")'
{% endhighlight %}

If you are using Webfaction and have to set an [SSH tunnel](http://docs.webfaction.com/user-guide/databases.html?highlight=mysql#starting-an-ssh-tunnel-with-ssh), make sure to make the hostname (`127.0.0.1`) explicit, otherwise MySQL may block your access based on localhost and `127.0.0.1` not being equivalent in its authentication system:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/wordpress";
    Jekyll::WordPress.process("database", "user", "pass", "127.0.0.1")'
{% endhighlight %}

### Further Wordpress migration alternatives

While the above methods work, they do not import much of the metadata that is usually stored in Wordpress posts and pages. If you need to export things like pages, tags, custom fields, image attachments and so on, the following resources might be useful to you:

- [Exitwp](https://github.com/thomasf/exitwp) is a configurable tool written in Python for migrating one or more Wordpress blogs into Jekyll (Markdown) format while keeping as much metadata as possible. Exitwp also downloads attachments and pages.
- [A great article](http://vitobotta.com/how-to-migrate-from-wordpress-to-jekyll/) with a step-by-step guide for migrating a Wordpress blog to Jekyll while keeping most of the structure and metadata.
- [wpXml2Jekyll](https://github.com/theaob/wpXml2Jekyll) is an executable windows application for creating Markdown posts from your Wordpress XML file.

## Drupal

If you’re migrating from [Drupal](), there is [a migrator](https://github.com/mojombo/jekyll/blob/master/lib/jekyll/migrators/drupal.rb) for you too:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/drupal";
    Jekyll::Drupal.process("database", "user", "pass")'
{% endhighlight %}

<div class="note warning">
  <h5>Warning: Drupal Version Compatibility</h5>
  <p>This migrator was written for Drupal 6.1 and may not work as expected on future versions of Drupal. Please update it and send us a pull request if necessary.</p>
</div>

## Movable Type

To import posts from Movable Type:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/mt";
    Jekyll::MT.process("database", "user", "pass")'
{% endhighlight %}

## Typo

To import posts from Typo:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/typo";
    Jekyll::Typo.process("database", "user", "pass")'
{% endhighlight %}

This code also has only been tested with Typo version 4+.

## TextPattern

To import posts from TextPattern:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/textpattern";
    Jekyll::TextPattern.process("database_name", "username", "password", "hostname")'
{% endhighlight %}

You will need to run the above from the parent directory of your `_import` folder. For example, if `_import` is located in `/path/source/_import`, you will need to run this code from `/path/source`. The hostname defaults to `localhost`, all other variables are required. You may need to adjust the code used to filter entries. Left alone, it will attempt to pull all entries that are live or sticky.

## Mephisto

To import posts from Mephisto:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/mephisto";
    Jekyll::Mephisto.process("database", "user", "password")'
{% endhighlight %}

If your data is in Postgres, you should do this instead:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/mephisto";
    Jekyll::Mephisto.postgres({:database => "database", :username=>"username", :password =>"password"})'
{% endhighlight %}

## Blogger (Blogspot)

To import posts from Blogger, see [this post about migrating from Blogger to Jekyll](http://coolaj86.info/articles/migrate-from-blogger-to-jekyll.html). If that doesn’t work for you, you might want to try some of the following alternatives:

- [@kennym](https://github.com/kennym) created a [little migration script](https://gist.github.com/1115810), because the solutions in the previous article didn't work out for him.
- [@ngauthier](https://github.com/ngauthier) created [another importer](https://gist.github.com/1506614) that imports comments, and does so via blogger’s archive instead of the RSS feed.
- [@juniorz](https://github.com/juniorz) created [yet another importer](https://gist.github.com/1564581) that works for [Octopress](http://octopress.org). It is like [@ngauthier’s version](https://gist.github.com/1506614) but separates drafts from posts, as well as importing tags and permalinks.

## Posterous

To import posts from your primary Posterous blog:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/posterous";
    Jekyll::Posterous.process("my_email", "my_pass")'
{% endhighlight %}

For any other Posterous blog on your account, you will need to specify the `blog_id` for the blog:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/posterous";
    Jekyll::Posterous.process("my_email", "my_pass", "blog_id")'
{% endhighlight %}

There is also an [alternative Posterous migrator](https://github.com/pepijndevos/jekyll/blob/patch-1/lib/jekyll/migrators/posterous.rb) that maintains permalinks and attempts to import images too.

## Tumblr

To import posts from Tumblr:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/tumblr";
    Jekyll::Tumblr.process("http://www.your_blog_url.com", true)'
{% endhighlight %}

There is also [a modified Tumblr migrator](https://github.com/stephenmcd/jekyll/blob/master/lib/jekyll/migrators/tumblr.rb) that exports posts as Markdown and preserves post tags.

The migrator above requires the `json` gem and Python's `html2text` to be installed as follows:

{% highlight bash %}
$ gem install json
$ pip install html2text
{% endhighlight %}

Once installed, simply use the format argument:

{% highlight bash %}
$ ruby -rubygems -e 'require "jekyll/migrators/tumblr";
    Jekyll::Tumblr.process("http://www.your_blog_url.com", format="md")'
{% endhighlight %}

## Other Systems

If you have a system that there isn’t currently a migrator for, you should consider writing one and sending us a pull request.