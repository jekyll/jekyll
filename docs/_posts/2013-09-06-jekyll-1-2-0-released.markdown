---
title: "Jekyll 1.2.0 Released"
date: "2013-09-06 22:02:41 -0400"
author: parkr
version: 1.2.0
category: release
---

After nearly a month and a half of hard work, the Jekyll team is happy to
announce the release of v1.2.0. It's chock full of bug fixes and some
enhancements that we think you'll love.

Here are a few things we think you'll want to know about this release:

* Run `jekyll serve --detach` to boot up a WEBrick server in the background. **Note:** you'll need to run `kill [server_pid]` to shut the server down.
* You can now **disable automatically-generated excerpts** if you set `excerpt_separator` to `""`.
* If you're moving around pages and post, you can now check for **URL conflicts** by running `jekyll doctor`.
* If you're a fan of the drafts feature, you'll be happy to know we've added `-D`, a shortened version of `--drafts`.
* Permalinks with special characters should now generate without errors.
* Expose the current Jekyll version as the `jekyll.version` Liquid variable.

For a full run-down, visit our [change log](/docs/history/)!
