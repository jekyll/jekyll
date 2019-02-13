---
title: "Security Fixes for series 3.6, 3.7 and 3.8"
date: 2018-09-19 18:00:00 +0530
author: ashmaroli
categories: [release]
version: 3.8.4
---

Hi Jekyllers,

We have patched a **critical vulnerability** reported to GitHub a couple of weeks ago and have released a set of new gems to
bring that patch to you. The vulnerability allowed arbitrary file reads with the cunning use of the `include:` setting in the
config file.

By simply including a symlink in the `include` array allowed the symlinked file to be read into the build when they shouldn't
actually be read in any circumstance.  
Further details regarding the patch can be viewed at the [pull request URL]({{ site.repository }}/pull/7224)

The patch has been released as versions `3.6.3`, `3.7.4` and `3.8.4`.  
Thanks to @parkr `v3.7.4` was released a couple of weeks prior and has been bundled with `github-pages-v192`.


Please keep in mind that this issue affects _all previously released Jekyll versions_. If you have not had
a good reason to upgrade to `3.6`, `3.7` or `3.8` yet, we advise that you do so at the earliest.

As always, Happy Jekylling! :sparkles:
