---
layout: docs
title: Blog migrations
prev_section: variables
next_section: templates
---

Most methods listed on this page require read access to the database to generate posts from your old system. Each method generates `.markdown` posts in the `_posts` directory based on the entries in the DB. Please make sure you take a look at the generated posts to see that information has been transferred over properly. Also, the majority of the import scripts do not check for published or private posts, so please look over what Jekyll has created for you.

## How to use

These [migrators are part of the Jekyll gem](https://github.com/mojombo/jekyll/tree/master/lib/jekyll/migrators).

1. Add an `_import` directory to your project
2. Open a terminal
3. `gem install sequel mysqlplus`
4. Run the respective commands below.

## WordPress

### Using Jekyll + Mysql server connection

    $ ruby -rubygems -e 'require "jekyll/migrators/wordpress"; Jekyll::WordPress.process("database", "user", "pass")'

If you are using Webfaction and have to set an [SSH tunnel](http://docs.webfaction.com/user-guide/databases.html?highlight=mysql#starting-an-ssh-tunnel-with-ssh), make sure to make the hostname (127.0.0.1) explicit, otherwise MySQL may block your access based on localhost and 127.0.0.1 not being equivalent in its authentication system:

    $ ruby -rubygems -e 'require "jekyll/migrators/wordpress"; Jekyll::WordPress.process("database", "user", "pass", "127.0.0.1")'

### Using Jekyll + Wordpress export file (works with wordpress.com)

If hpricot is not already installed, `gem install hpricot`. Export your blog: https://YOUR-USER-NAME.wordpress.com/wp-admin/export.php. Assuming that file is called wordpress.xml:

    $ ruby -rubygems -e 'require "jekyll/migrators/wordpressdotcom"; Jekyll::WordpressDotCom.process("wordpress.xml")'


### Further Wordpress + alternatives

While the above methods usually works they do not import very much of the meta
data that usually is stored in wordpress posts and pages. If you need to keep
more of pages, tags, custom fields, image attachments and so on the following
resources might be of interest:

- [Exitwp](https://github.com/thomasf/exitwp) is a configurable tool written
  in python for migrating one or more wordpress blogs into jekyll/markdown
  format while keeping as much meta data as possible. Also downloads
  attachments and pages.
- [A great article](http://vitobotta.com/how-to-migrate-from-wordpress-to-jekyll/) with
  a step by step guide on migrating an wordpress blog while keeping most of
  the structure and meta data.
- [wpXml2Jekyll](https://github.com/theaob/wpXml2Jekyll) is an executable windows application for creating Markdown posts from your Wordpress XML file.

## [Drupal](https://github.com/mojombo/jekyll/blob/master/lib/jekyll/migrators/drupal.rb)

Note: This was written for Drupal 6.1. Please update it if necessary.
Thanks!

    $ ruby -rubygems -e 'require "jekyll/migrators/drupal"; Jekyll::Drupal.process("database", "user", "pass")'

## Movable Type

    $ ruby -rubygems -e 'require "jekyll/migrators/mt"; Jekyll::MT.process("database", "user", "pass")'

## Typo 4+

    $ ruby -rubygems -e 'require "jekyll/migrators/typo"; Jekyll::Typo.process("database", "user", "pass")'

This code also has only been tested with Typo version 4+.

## TextPattern

    $ ruby -rubygems -e 'require "jekyll/migrators/textpattern"; Jekyll::TextPattern.process("database_name", "username", "password", "hostname")'

Run the above from the folder above _import in Terminal. i.e. If _import is located in /path/source/_import, run the code from /path/source. The hostname defaults to localhost, all other variables are needed. You may
need to adjust the code used to filter entries. Left alone, it will attempt to
pull all entries that are live or sticky.

## Mephisto

    $ ruby -rubygems -e 'require "jekyll/migrators/mephisto"; Jekyll::Mephisto.process("database", "user", "password")'

If your data is in postgres, you can do this:

    $ ruby -rubygems -e 'require "jekyll/migrators/mephisto"; Jekyll::Mephisto.postgres({:database => "database", :username=>"username", :password =>"password"})'

## Blogger (Blogspot)

See [Migrate from Blogger to Jekyll](http://coolaj86.info/articles/migrate-from-blogger-to-jekyll.html)

[kennym](https://github.com/kennym) created a [little migration script](https://gist.github.com/1115810), because the solutions in the
previous article didn't work out for him.

[ngauthier](https://github.com/ngauthier) created [another importer](https://gist.github.com/1506614) that imports comments, and does so via blogger's archive instead of the rss feed.

[juniorz](https://github.com/juniorz) created [another importer](https://gist.github.com/1564581) that works for [Octopress](http://octopress.org). It is like [ngauthier](https://github.com/ngauthier)'s version but separates drafts from posts, imports tags and permalinks.

## Posterous

For your primary blog:

    $ ruby -rubygems -e 'require "jekyll/migrators/posterous"; Jekyll::Posterous.process("my_email", "my_pass")'

For another blog:

    $ ruby -rubygems -e 'require "jekyll/migrators/posterous"; Jekyll::Posterous.process("my_email", "my_pass", "blog_id")'

_An alternative Posterous migrator that maintains permalinks and attempts to import images lives [here](https://github.com/pepijndevos/jekyll/blob/patch-1/lib/jekyll/migrators/posterous.rb)_

## Tumblr

    $ ruby -rubygems -e 'require "jekyll/migrators/tumblr"; Jekyll::Tumblr.process("http://www.your_blog_url.com", true)'

A modified Tumblr migrator that exports posts as Markdown and also exports post tags lives [here](https://github.com/stephenmcd/jekyll/blob/master/lib/jekyll/migrators/tumblr.rb)

It requires the json gem and Python's html2text:

    $ gem install json
    $ pip install html2text

Once installed, simply use the format arg:

    $ ruby -rubygems -e 'require "jekyll/migrators/tumblr"; Jekyll::Tumblr.process("http://www.your_blog_url.com", format="md")'
