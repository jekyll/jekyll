---
layout: docs
title: Jekyll on Windows
prev_section: configuration
next_section: posts
permalink: /docs/windows/
---

While Windows is not an officially-supported platform, it can be used to run
Jekyll with the proper tweaks. This page aims to collect some of the general
knowledge and lessons that have been unearthed by Windows users.

## Installation

Madhur Ahuja has written up instructions to get
[Jekyll running on Windows][windows-installation] and it seems to work for most.

## Encoding

If you use UTF-8 encoding, make sure that no <code>BOM</code> header
characters exist in your files or very, very bad things will happen to
Jekyll. This is especially relevant if you're running Jekyll on Windows.

[windows-installation]: http://www.madhur.co.in/blog/2011/09/01/runningjekyllwindows.html
