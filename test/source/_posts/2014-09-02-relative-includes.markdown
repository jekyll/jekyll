---
title: Post
layout: post
include1: rel_include.html
include2: relative_includes/rel_include
include3: rel_INCLUDE
include4: params
include5: clude
---

Liquid tests
- 1 {% relative_include relative_includes/{{ page.include1 }} %}
- 2 {% relative_include {{ page.include2 | append: '.html' }} %}
- 3 {% relative_include relative_includes/{{ page.include3 | downcase | append: '.html' }} %}

Whitespace tests
- 4 {% relative_include relative_includes/{{page.include1}} %}
- 5 {% relative_include relative_includes/{{   page.include1}} %}
- 6 {% relative_include relative_includes/{{  page.include3   | downcase |   append:  '.html'}} %}

Parameters test
- 7 {% relative_include relative_includes/{{ page.include4 | append: '.html' }} var1='foo' var2='bar' %}

Partial variable test
- 8 {% relative_include relative_includes/rel_in{{ page.include5 }}.html %}
