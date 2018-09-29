---
title: Manual Deployment
permalink: /docs/deployment/manual/
---

Jekyll generates your static site to the `_site` directory by default. You can
transfer the contents of this directory to almost any hosting provider to get
your site live. Here are some manual ways of achieving this:

## rsync

Rsync is similar to scp except it can be faster as it will only send changed
parts of files as opposed to the entire file. You can learn more about using
rsync in the [Digital Ocean tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps).

## Amazon S3

If you want to host your site in Amazon S3, you can do so by
using the [s3_website](https://github.com/laurilehmijoki/s3_website)
application. It will push your site to Amazon S3 where it can be served like
any web server,
dynamically scaling to almost unlimited traffic. This approach has the
benefit of being about the cheapest hosting option available for
low-volume blogs as you only pay for what you use.

## FTP

Most traditional web hosting provider let you upload files to their servers over FTP. To upload a Jekyll site to a web host using FTP, run the `jekyll build` command and copy the contents of the generated `_site` folder to the root folder of your hosting account. This is most likely to be the `httpdocs` or `public_html` folder on most hosting providers.

## scp

If you have direct access to the deployment web server, the process is essentially the same, except you might have other methods available to you (such as `scp`, or even direct filesystem access) for transferring the files. Remember to make sure the contents of the generated `_site` folder get placed in the appropriate web root directory for your web server.


## Rack-Jekyll

[Rack-Jekyll](https://github.com/adaoraul/rack-jekyll/) allows you to deploy your site on any Rack server such as Amazon EC2, Slicehost, Heroku, and so forth. It also can run with [shotgun](https://github.com/rtomayko/shotgun/), [rackup](https://github.com/rack/rack), [mongrel](https://github.com/mongrel/mongrel), [unicorn](https://github.com/defunkt/unicorn/), and [others](https://github.com/adaoraul/rack-jekyll#readme).
