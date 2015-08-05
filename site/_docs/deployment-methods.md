---
layout: docs
title: Deployment methods
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

If you store your Jekyll site in [Git](http://git-scm.com/) (you are using version control, right?), it’s pretty easy to automate the
deployment process by setting up a post-update hook in your Git
repository, [like
this](http://web.archive.org/web/20091223025644/http://www.taknado.com/en/2009/03/26/deploying-a-jekyll-generated-site/).

### Git post-receive hook

To have a remote server handle the deploy for you every time you push changes using Git, you can create a user account which has all the public keys that are authorized to deploy in its `authorized_keys` file. With that in place, setting up the post-receive hook is done as follows:

{% highlight bash %}
laptop$ ssh deployer@example.com
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
laptops$ git remote add deploy deployer@example.com:~/myrepo.git
{% endhighlight %}

Deploying is now as easy as telling nginx or Apache to look at
`/var/www/myrepo` and running the following:

{% highlight bash %}
laptops$ git push deploy master
{% endhighlight %}

### Jekyll-hook

You can also use jekyll-hook, a server that listens for webhook posts from
GitHub, generates a website with Jekyll, and moves it somewhere to be
published. Use this to run your own GitHub Pages-style web server.

This method is useful if you need to serve your websites behind a firewall,
need extra server-level features like HTTP basic authentication or want to
host your site directly on a CDN or file host like S3.

Setup steps are fully documented
[in the `jekyll-hook` repo](https://github.com/developmentseed/jekyll-hook).

### Static Publisher

[Static Publisher](https://github.com/static-publisher/static-publisher) is another automated deployment option with a server listening for webhook posts, though it's not tied to GitHub specifically. It has a one-click deploy to Heroku, it can watch multiple projects from one server, it has an easy to user admin interface and can publish to either S3 or to a git repository (e.g. gh-pages).

### Rake

Another way to deploy your Jekyll site is to use [Rake](https://github.com/jimweirich/rake), [HighLine](https://github.com/JEG2/highline), and
[Net::SSH](https://github.com/net-ssh/net-ssh). A more complex example of deploying Jekyll with Rake that deals with multiple branches can be found in [Git Ready](https://github.com/gitready/gitready/blob/cdfbc4ec5321ff8d18c3ce936e9c749dbbc4f190/Rakefile).


### scp

Once you’ve generated the `_site` directory, you can easily scp it using a `tasks/deploy` shell script similar to [this deploy script here](https://github.com/henrik/henrik.nyh.se/blob/master/script/deploy). You’d obviously need to change the values to reflect your site’s details. There is even [a matching TextMate command](http://gist.github.com/214959) that will help you run this script from within Textmate.

### rsync

Once you’ve generated the `_site` directory, you can easily rsync it using a `tasks/deploy` shell script similar to [this deploy script here](https://github.com/vitalyrepin/vrepinblog/blob/master/transfer.sh). You’d obviously need to change the values to reflect your site’s details.

#### Step 1: Install rrsync to your home folder (server-side)

We will use certificate-based authorization to simplify the publishing process. It makes sense to restrict rsync access only to the directory which it is supposed to sync.

That's why rrsync wrapper shall be installed. If it is not already installed by your hoster you can do it yourself:

- [download rrsync](http://ftp.samba.org/pub/unpacked/rsync/support/rrsync)
- Put it to the bin subdirectory of your home folder  (```~/bin```)
- Make it executable (```chmod +x```)

#### Step 2: Setup certificate-based ssh access (server side)

[This process is described in a lot of places in the net](https://wiki.gentoo.org/wiki/SSH#Passwordless_Authentication). We will not cover it here. What is different from usual approach is to put the restriction to certificate-based authorization in ```~/.ssh/authorized_keys```). We will launch ```rrsync``` utility and supply it with the folder it shall have read-write access to:

```
command="$HOME/bin/rrsync <folder>",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ssh-rsa <cert>
```

```<folder>``` is the path to your site. E.g., ```~/public_html/you.org/blog-html/```.

#### Step 3: Rsync! (client-side)

Add the script ```deploy``` to the web site source folder:

{% highlight bash %}
#!/bin/sh

rsync -avr --rsh='ssh -p2222' --delete-after --delete-excluded   <folder> <user>@<site>:
{% endhighlight %}

Command line parameters are:

- ```--rsh='ssh -p2222'``` It is needed if your hoster provides ssh access using ssh port different from default one (e.g., this is what hostgator is doing)
- ```<folder>``` is the name of the local folder with generated web content. By default it is ```_site/``` for Jekyll
- ```<user>``` &mdash; ssh user name for your hosting account
- ```<site>``` &mdash; your hosting server

Example command line is:

{% highlight bash %}
rsync -avr --rsh='ssh -p2222' --delete-after --delete-excluded   _site/ hostuser@vrepin.org:
{% endhighlight %}

Don't forget column ':' after server name!

#### Optional step 4: exclude transfer.sh from being copied to the output folder by Jekyll

This step is recommended if you use this how-to to deploy Jekyll-based web site. If you put ```deploy``` script to the root folder of your project, Jekyll copies it to the output folder.
This behavior can be changed in ```_config.yml```. Just add the following line there:

{% highlight yaml %}
# Do not copy these file to the output directory
exclude: ["deploy"]
{% endhighlight %}

#### We are done!

Now it's possible to publish your web site by launching ```deploy``` script. If your ssh certificate  is [passphrase-protected](https://martin.kleppmann.com/2013/05/24/improving-security-of-ssh-private-keys.html), you are asked to enter the password.

## Rack-Jekyll

[Rack-Jekyll](https://github.com/adaoraul/rack-jekyll/) is an easy way to deploy your site on any Rack server such as Amazon EC2, Slicehost, Heroku, and so forth. It also can run with [shotgun](https://github.com/rtomayko/shotgun/), [rackup](https://github.com/rack/rack), [mongrel](https://github.com/mongrel/mongrel), [unicorn](https://github.com/defunkt/unicorn/), and [others](https://github.com/adaoraul/rack-jekyll#readme).

Read [this post](http://blog.crowdint.com/2010/08/02/instant-blog-using-jekyll-and-heroku.html) on how to deploy to Heroku using Rack-Jekyll.

## Jekyll-Admin for Rails

If you want to maintain Jekyll inside your existing Rails app, [Jekyll-Admin](https://github.com/zkarpinski/Jekyll-Admin) contains drop in code to make this possible. See Jekyll-Admin’s [README](https://github.com/zkarpinski/Jekyll-Admin/blob/master/README) for more details.

## Amazon S3

If you want to host your site in Amazon S3, you can do so by
using the [s3_website](https://github.com/laurilehmijoki/s3_website)
application. It will push your site to Amazon S3 where it can be served like
any web server,
dynamically scaling to almost unlimited traffic. This approach has the
benefit of being about the cheapest hosting option available for
low-volume blogs as you only pay for what you use.

## OpenShift

If you'd like to deploy your site to an OpenShift gear, there's [a cartridge
for that](https://github.com/openshift-cartridges/openshift-jekyll-cartridge).

<div class="note">
  <h5>ProTip™: Use GitHub Pages for zero-hassle Jekyll hosting</h5>
  <p>GitHub Pages are powered by Jekyll behind the scenes, so if you’re looking for a zero-hassle, zero-cost solution, GitHub Pages are a great way to <a href="../github-pages/">host your Jekyll-powered website for free</a>.</p>
</div>
