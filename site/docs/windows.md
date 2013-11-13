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

## Automatic Regeneration

If you get the following error with the --watch option

```
C:/Ruby193/lib/ruby/gems/1.9.1/gems/listen-1.3.1/lib/listen/adapter.rb:207:in `require': cannot load such file -- wdm (LoadError)
```

To fix that error, open the gemfile in your jekyll project directory and add these two lines:

```
require 'rbconfig'
gem 'wdm', '>= 0.1.0' if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
```

## Encoding

If you use UTF-8 encoding, make sure that no <code>BOM</code> header
characters exist in your files or very, very bad things will happen to
Jekyll. This is especially relevant if you're running Jekyll on Windows.

Additionally, you might need to change the code page of the console window to UTF-8 
in case you get a "Liquid Exception: Incompatible character encoding" error during
the site generation process. It can be done with the following command.

{% highlight bash %}
$ chcp 65001
{% endhighlight %}

[windows-installation]: http://www.madhur.co.in/blog/2011/09/01/runningjekyllwindows.html
