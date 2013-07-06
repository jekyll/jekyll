---
layout: news
title: News
permalink: /news/
author: all
---

<div class="grid">
  {% for post in site.posts %}
  <div class="unit whole entry">
  {% include news_item.html %}
  </div>
  {% endfor %}
  <div class="clear"></div>
</div>
