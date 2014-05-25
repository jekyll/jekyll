---
title: Post
layout: post
include1: include.html
include2: include
include3: INCLUDE
include4: params
---

Liquid tests
- 1 {% include {{ page.include1 }} %}
- 2 {% include {{ page.include2 | append: '.html' }} %}
- 3 {% include {{ page.include3 | downcase | append: '.html' }} %}

Whitespace tests
- 4 {% include {{page.include1}} %}
- 5 {% include {{   page.include1}} %}
- 6 {% include {{  page.include3   | downcase |   append:  '.html'}} %}

Parameters test
- 7 {% include {{ page.include4 | append: '.html' }} var1='foo' var2='bar' %}
