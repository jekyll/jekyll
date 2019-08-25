---
title: 'Jekyll 1.5.1 Released'
date: 2014-03-27 22:43:48 -0400
author: parkr
version: 1.5.1
category: release
---

The hawk-eyed [@gregose](https://github.com/gregose) spotted a bug in our
`Jekyll.sanitized_path` code:

{% highlight ruby %}
> sanitized_path("/tmp/foobar/jail", "..c:/..c:/..c:/etc/passwd")
=> "/tmp/foobar/jail/../../../etc/passwd"
{% endhighlight %}

Well, we can't have that! In 1.5.1, you'll instead see:

{% highlight ruby %}
> sanitized_path("/tmp/foobar/jail", "..c:/..c:/..c:/etc/passwd")
=> "/tmp/foobar/jail/..c:/..c:/..c:/etc/passwd"
{% endhighlight %}

Luckily not affecting 1.4.x, this fix will make 1.5.0 that much safer for
the masses. Thanks, Greg!
