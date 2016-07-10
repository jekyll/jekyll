---
title: Post
layout: post
include1: rel_include.html
include2: include_relative/rel_include
include3: rel_INCLUDE
include4: params
include5: clude
---

Liquid tests
- 1 {% include_relative include_relative/{{ page.include1 }} %}
- 2 {% include_relative {{ page.include2 | append: '.html' }} %}
- 3 {% include_relative include_relative/{{ page.include3 | downcase | append: '.html' }} %}

Whitespace tests
- 4 {% include_relative include_relative/{{page.include1}} %}
- 5 {% include_relative include_relative/{{   page.include1}} %}
- 6 {% include_relative include_relative/{{  page.include3   | downcase |   append:  '.html'}} %}

Parameters test
- 7 {% include_relative include_relative/{{ page.include4 | append: '.html' }} var1='foo' var2='bar' %}

Partial variable test
- 8 {% include_relative include_relative/rel_in{{ page.include5 }}.html %}

Relative to self test:

- 9 {% include_relative 2014-03-03-yaml-with-dots.md %}
