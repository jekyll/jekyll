---
title: 'Jekyll 1.4.3 Released'
date: 2014-01-13 17:43:32 -0800
author: benbalter
version: 1.4.3
categories: [release]
---

Jekyll 1.4.3 contains two **critical** security fixes. If you run Jekyll locally
and do not run Jekyll in "safe" mode (e.g. you do not build Jekyll sites on behalf
of others), you are not affected and are not required to update at this time.
([See pull request.]({{ site.repository }}/pull/1944))

Versions of Jekyll prior to 1.4.3 and greater than 1.2.0 may allow malicious
users to expose the content of files outside the source directory in the
generated output via improper symlink sanitization, potentially resulting in an
inadvertent information disclosure.

Versions of Jekyll prior to 1.4.3 may also allow malicious users to write
arbitrary `.html` files outside of the destination folder via relative path
traversal, potentially overwriting otherwise-trusted content with arbitrary HTML
or Javascript depending on your server's configuration.

*Maintainer's note: Many thanks to @gregose and @charliesome for discovering
these vulnerabilities, and to @BenBalter and @alindeman for writing the patch.*
