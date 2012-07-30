---
layout: docs
title: Manual deployment
prev_section: heroku
next_section: contributing
---

Deploying Jekyll? No problem: Just copy the generated `_site` to
somewhere that your favorite web server can serve it up. There’re also
automated ways to do it, listed below. If you’ve created your own way,
edit away!

Post-update hook
----------------

If you store your jekyll site in git, it’s pretty easy to automate the
deployment process by setting up a post-update hook in your git
repository, [like
this](http://web.archive.org/web/20091223025644/http://www.taknado.com/en/2009/03/26/deploying-a-jekyll-generated-site/).

Post-receive hook
-----------------

This is where it’s at. You created a user account named deployer which
has all the users public keys that are authorized to deploy in its
\`authorized\_keys\` file right? Great, deploying Jekyll is this easy
then:

{% highlight bash %}
laptop$ ssh deployer@myserver.com
server$ mkdir myrepo.git
server$ cd myrepo.git
server$ git --bare init
server$ cp hooks/post-receive.sample hooks/post-receive
server$ mkdir /var/www/myrepo
{% endhighlight %}

Add the following lines to hooks/post-receive and be sure jekyll is
installed on the server

    <code>GIT_REPO=$HOME/myrepo.git
    TMP_GIT_CLONE=$HOME/tmp/myrepo
    PUBLIC_WWW=/var/www/myrepo

    git clone $GIT_REPO $TMP_GIT_CLONE
    jekyll --no-auto $TMP_GIT_CLONE $PUBLIC_WWW
    rm -Rf $TMP_GIT_CLONE
    exit
    </code>

Finally do the following on any users laptop that needs to be able to
deploy

    <code>laptops$ git remote add deploy deployer@myserver.com:~/myrepo.git</code>

Deploying is now as easy as telling nginx or apache to look at
/var/www/myrepo and running the following:

    <code>laptops$ git push deploy master</code>

BOOM!

Rake
----

Another way to deploy your jekyll site is to use rake, highline, and
net-ssh. A more complex example that deals with multiple branches used
in [gitready](https://github.com/gitready/gitready/blob/en/Rakefile).

rsync
-----

Just generate the `_site` and rsync it, e.g. with a `tasks/deploy`
[shell
script](http://github.com/henrik/henrik.nyh.se/blob/master/tasks/deploy).

There’s even [a TextMate command](http://gist.github.com/214959) to run
this script.

ftp
---

As sometimes you don’t have anything else than FTP to deploy your site
(not dedicated hosting), with [glynn](http://github.com/dmathieu/glynn),
you can easily generate your jekyll powered website’s static files and
send them to your host through ftp.

Rack-Jekyll
-----------

Easy way to deploy your site on any server (EC2, Slicehost, Heroku, etc)
with [rack-jekyll](http://github.com/bry4n/rack-jekyll/). It also can
run with [shotgun](http://github.com/rtomakyo/shotgun/) ,
[rackup](http://github.com/rack/rack) ,
[mongrel](http://github.com/mongrel/mongrel),
[unicorn](http://github.com/defunkt/unicorn/) , and more…

See rack-jekyll’s [README](http://github.com/bry4n/rack-jekyll#readme)

Read [this
post](http://blog.crowdint.com/2010/08/02/instant-blog-using-jekyll-and-heroku.html)
on how to deploy to Heroku

Jekyll-Admin for Rails
----------------------

If you want to maintain Jekyll inside your existing Rails app,
[Jekyll-Admin](http://github.com/zkarpinski/Jekyll-Admin) contains drop
in code to make this possible. See Jekyll-Admin’s
[README](http://github.com/zkarpinski/Jekyll-Admin/blob/master/README)

Amazon S3
---------

If you want to host your site in Amazon S3, you can do so with
[jekyll-s3](https://github.com/versapay/jekyll-s3) application. It will
push your site to Amazon S3 where it can be served like any web server,
dynamically scaling to almost unlimited traffic. This approach has the
benefit of being about the cheapest hosting option available for
low-volume blogs as you only pay for what you use.
