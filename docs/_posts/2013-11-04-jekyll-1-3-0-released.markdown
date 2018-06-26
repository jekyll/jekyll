---
title: 'Jekyll 1.3.0 Released'
date: 2013-11-04 21:46:02 -0600
author: mattr-
version: 1.3.0
categories: [release]
---

It's been about six weeks since v1.2.0 and the Jekyll team is happy to
announce the arrival of v1.3.0. This is a **huge** release full of all
sorts of new features, bug fixes, and other things that you're sure to
love.

Here are a few things we think you'll want to know about this release:

* You can add [arbitrary data][] to the site by adding YAML files under a
  site's `_data` directory. This will allow you to avoid
  repetition in your templates and to set site specific options without
  changing `_config.yml`.

* You can now run `jekyll serve --detach` to boot up a WEBrick server in the
  background. **Note:** you'll need to run `kill [server_pid]` to shut
  the server down. When ran, you'll get a process id that you can use in
  place of `[server_pid]`

* You can now **disable automatically-generated excerpts** if you set
  `excerpt_separator` to `""`.

* If you're moving pages and posts, you can now check for **URL
  conflicts** by running `jekyll doctor`.

* If you're a fan of the drafts feature, you'll be happy to know we've
  added `-D`, a shortened version of `--drafts`.

* Permalinks with special characters should now generate without errors.

* Expose the current Jekyll version as the `jekyll.version` Liquid
  variable.

For a full run-down, visit our [change log](/docs/history/)!

[arbitrary data]: /docs/datafiles/
