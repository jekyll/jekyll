---
title: "Jekyll 4.2.2 Released"
date: 2022-03-03 19:15:20 +0530
author: ashmaroli
version: 4.2.2
category: release
---

Hello Jekyllers!

Jekyll 4.2.2 has been released. Unlike prior releases, this is a simple maintenance release and may be skipped.

For those who are still curious about the current release, here is some technical context: The previous `jekyll-4.2.1` package was built and
published using a Windows system. A side-effect of that action was that every file bundled into the gem ended up with Windows-style CRLF
line-endings instead of Unix-style LF line-endings.

For our end-users, this difference holds no significance. However, a third-party entity vendoring the release faced a roadblock. The executable
program `jekyll` apparently misplaced the executable bit because of the change in line-endings.

To that end, the Jekyll team decided to use the GitHub Actions service to build and publish releases. In-house plugins have already published
releases via this route serving as trials. Henceforth, and unless explicitly reported, all Jekyll releases will be built on GitHub Actions'
Ubuntu platform and published to Rubygems by @jekyllbot irrespective of the maintainer overseeing the release.

That is all for now.
Happy Jekyllin'!!

*P.S.: Jekyll 4.3.0 will be bringing you some new features very soon.. Also, our sass-converter plugin has been [enhanced][sass-220] to support
modern improvements to Sass.*

[sass-220]: https://github.com/jekyll/jekyll-sass-converter/tree/v2.2.0#sass-embedded
