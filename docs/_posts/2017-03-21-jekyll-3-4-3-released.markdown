---
title: 'Jekyll 3.4.3 Released'
date: 2017-03-21 08:52:53 -0500
author: pathawks
version: 3.4.3
category: release
---

Another one-PR patch update as we continue our quest to destroy all bugs. A
fairly technical debriefing follows, but the TLDR is that we have updated the
`uri_escape` filter to more closely follow the pre-v3.4.0 behavior.

In [v3.4.0]({% link _posts/2017-01-18-jekyll-3-4-0-released.markdown %}), we
moved away from using the deprecated
[`URI.escape`](https://ruby-doc.org/stdlib-2.3.0/libdoc/uri/rdoc/URI/Escape.html#method-i-encode)
in favor of
[`Addressable::URI.encode`](http://www.rubydoc.info/gems/addressable/Addressable/URI#encode-class_method).
This is what powers our [`uri_escape`
filter](https://jekyllrb.com/docs/templates/).

While this transition was mostly a smooth one, the two methods are not
identical. While `URI.escape` was happy to escape any string,
`Addressable::URI.encode` first turns the string into an `Addressable::URI`
object, and will then escape each component of that object. In most cases, this
difference was insignificant, but there were a few cases where this caused some
unintended regressions when encoding colons.

While **Addressable** can understand that something like `"/example :page"` is a
relative URI, without the slash it cannot figure out how to turn
`"example :page"` into an `Addressable::URI` object. `URI.escape` had no such
objection. This lead to the following Liquid code working fine in Jekyll 3.3.x
but breaking in 3.4.0:

{% raw %}
```liquid
{{ "example :page" | uri_escape }}
```
{% endraw %}

This was not an intended consequence of switching to **Addressable**.

Fortunately, the solution was not complicated. **Addressable** has a method
[`Addressable::URI.normalize_component`](http://www.rubydoc.info/gems/addressable/Addressable/URI#normalize_component-class_method)
which will simply escape the characters in a string, much like `URI.escape`.

Thanks to @cameronmcefee and @FriesFlorian for reporting
[this issue](https://github.com/jekyll/jekyll/issues/5954).

Happy Jekylling!
