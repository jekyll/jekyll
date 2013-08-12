---
layout: docs
title: Deployment methods
prev_section: github-pages
next_section: troubleshooting
permalink: /docs/deployment-methods/
---

Sites built using Jekyll can be deployed in a large number of ways due to the static nature of the generated output. A few of the most common deployment techniques are described below.

## Web hosting providers (FTP)

Just about any traditional web hosting provider will let you upload files to their servers over FTP. To upload a Jekyll site to a web host using FTP, simply run the `jekyll` command and copy the generated `_site` folder to the root folder of your hosting account. This is most likely to be the `httpdocs` or `public_html` folder on most hosting providers.

### FTP using Glynn

There is a project called [Glynn](https://github.com/dmathieu/glynn), which lets you easily generate your Jekyll powered website’s static files and
send them to your host through FTP.

## Self-managed web server

If you have direct access yourself to the deployment web server yourself, the process is essentially the same, except you might have other methods available to you (such as `scp`, or even direct filesystem access) for transferring the files. Just remember to make sure the contents of the generated `_site` folder get placed in the appropriate web root directory for your web server.

## Automated methods

There are also a number of ways to easily automate the deployment of a Jekyll site. If you’ve got another method that isn’t listed below, we’d love it if you [contributed](../contributing/) so that everyone else can benefit too.

### Git post-update hook

If you store your jekyll site in [Git](http://git-scm.com/) (you are using version control, right?), it’s pretty easy to automate the
deployment process by setting up a post-update hook in your Git
repository, [like
this](http://web.archive.org/web/20091223025644/http://www.taknado.com/en/2009/03/26/deploying-a-jekyll-generated-site/).

### Git post-receive hook

To have a remote server handle the deploy for you every time you push changes using Git, you can create a user account which has all the public keys that are authorized to deploy in its `authorized_keys` file. With that in place, setting up the post-receive hook is done as follows:

{% highlight bash %}
laptop$ ssh deployer@myserver.com
server$ mkdir myrepo.git
server$ cd myrepo.git
server$ git --bare init
server$ cp hooks/post-receive.sample hooks/post-receive
server$ mkdir /var/www/myrepo
{% endhighlight %}

Next, add the following lines to hooks/post-receive and be sure Jekyll is
installed on the server:

{% highlight bash %}
GIT_REPO=$HOME/myrepo.git
TMP_GIT_CLONE=$HOME/tmp/myrepo
PUBLIC_WWW=/var/www/myrepo

git clone $GIT_REPO $TMP_GIT_CLONE
jekyll build -s $TMP_GIT_CLONE -d $PUBLIC_WWW
rm -Rf $TMP_GIT_CLONE
exit
{% endhighlight %}

Finally, run the following command on any users laptop that needs to be able to
deploy using this hook:

{% highlight bash %}
laptops$ git remote add deploy deployer@myserver.com:~/myrepo.git
{% endhighlight %}

Deploying is now as easy as telling nginx or Apache to look at
`/var/www/myrepo` and running the following:

{% highlight bash %}
laptops$ git push deploy master
{% endhighlight %}

### Rake

Another way to deploy your Jekyll site is to use [Rake](https://github.com/jimweirich/rake), [HighLine](https://github.com/JEG2/highline), and
[Net::SSH](http://net-ssh.rubyforge.org/). A more complex example of deploying Jekyll with Rake that deals with multiple branches can be found in [Git Ready](https://github.com/gitready/gitready/blob/en/Rakefile).

### rsync

Once you’ve generated the `_site` directory, you can easily rsync it using a `tasks/deploy` shell script similar to [this deploy script here](http://github.com/henrik/henrik.nyh.se/blob/master/tasks/deploy). You’d obviously need to change the values to reflect your site’s details. There is even [a matching TextMate command](http://gist.github.com/214959) that will help you run
this script from within Textmate.


## Rack-Jekyll

[Rack-Jekyll](http://github.com/bry4n/rack-jekyll/) is an easy way to deploy your site on any Rack server such as Amazon EC2, Slicehost, Heroku, and so forth. It also can run with [shotgun](http://github.com/rtomakyo/shotgun/), [rackup](http://github.com/rack/rack), [mongrel](http://github.com/mongrel/mongrel), [unicorn](http://github.com/defunkt/unicorn/), and [others](https://github.com/adaoraul/rack-jekyll#readme).

Read [this post](http://blog.crowdint.com/2010/08/02/instant-blog-using-jekyll-and-heroku.html) on how to deploy to Heroku using Rack-Jekyll.

## Jekyll-Admin for Rails

If you want to maintain Jekyll inside your existing Rails app, [Jekyll-Admin](http://github.com/zkarpinski/Jekyll-Admin) contains drop in code to make this possible. See Jekyll-Admin’s [README](http://github.com/zkarpinski/Jekyll-Admin/blob/master/README) for more details.

## Amazon S3

If you want to host your site in Amazon S3, you can do so with
[s3_website](https://github.com/laurilehmijoki/s3_website) application. It will
push your site to Amazon S3 where it can be served like any web server,
dynamically scaling to almost unlimited traffic. This approach has the
benefit of being about the cheapest hosting option available for
low-volume blogs as you only pay for what you use.

<div class="note">
  <h5>ProTip™: Use GitHub Pages for zero-hassle Jekyll hosting</h5>
  <p>GitHub Pages are powered by Jekyll behind the scenes, so if you’re looking for a zero-hassle, zero-cost solution, GitHub Pages are a great way to <a href="../github-pages/">host your Jekyll-powered website for free</a>.</p>
</div>
