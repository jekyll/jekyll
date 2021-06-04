---
title: 'Jekyll 3.9.1 Released'
date: 2021-04-08 10:51:12 -0400
author: parkr
version: 3.9.1
categories: [release]
---

This patch release of the 3.9 series is released to fix a bug where the
`include` tag does not allow valid filename characters. For example, this
would previously fail:

{% raw %}
```text
{% include my-logo@2x.svg %}
```
{% endraw %}

This release adds support for the following characters in filenames:

- `@`
- `-`
- `(` and `)`
- `+`
- `~`
- `#`

Happy Jekylling!
