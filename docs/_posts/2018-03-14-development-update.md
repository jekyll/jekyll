---
title: "Jekyll 4.0 is on the Horizon!"
date: "2018-03-14 16:07:00 +0100"
author: oe
categories: [community]
---

With the release of Jekyll 3.8.0, it's been 2 and a half years since the last major release. Jekyll 3.0.0 was released in late October of 2015! That's a long time ago, and we've been working towards the next major release of Jekyll for a couple of months now. Here's a small preview of what's to come:

- Dropping support for Ruby 2.1 and 2.2. Both versions are reaching or have reached their EOL period.
- Dropping Pygments as a dependency. We're already defaulting to Rouge, and this removes the implicit Python dependency. (finally!)
- Making the `link` tag use relative URLs. This is a big breaking change, but it's the cleaner solution.

We're open to more ideas! If the development cost isn't too high, or if someone volunteers to take care of the implementation, it's likely that your suggestion might make it into Jekyll 4.0. Head over to this [issue] for more details. Some interesting topics might be improving Internationalization support in Jekyll, creating convenience Liquid tags, et cetera.

That being said, the development period of version 4.0 begins _now_. This means a couple of things:

- New features will only be implemented in Jekyll 4.0. There will be no 3.9.0 or the like.
- Same with bug fixes, unless they concern something introduced in Jekyll 3.7 or 3.8, in which case we will backport the fixes and release a patch version.
- Now is a great time to finally take on the feature you've wanted to see in Jekyll for ages! Just open an issue or experiment with the code to get going!

[issue]: http://google.com
