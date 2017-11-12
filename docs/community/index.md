---
layout: page
title: Community
permalink: /community/
---

## Jekyllconf

[JekyllConf](http://jekyllconf.com) is a free, online conference for all things Jekyll hosted by [CloudCannon](http://cloudcannon.com). Each year members of the Jekyll community speak about interesting use cases, tricks they've learned, or meta Jekyll topics.

### Featured
{% assign random = site.time | date: "%s%N" | modulo: site.data.jekyllconf-talks.size %}
{% assign featured = site.data.jekyllconf-talks[random] %}

{{ featured.topic }} - [{{ featured.speaker }}](https://twitter.com/{{ featured.twitter_handle }})
<div class="videoWrapper">
    <iframe width="420" height="315" src="https://www.youtube.com/embed/{{ featured.youtube_id }}" frameborder="0" allowfullscreen></iframe>
</div>

{% assign talks = site.data.jekyllconf-talks | group_by: 'year' %}
{% for year in talks reversed %}
### {{ year.name }}
    {% for talk in year.items %}
 * [{{ talk.topic }}](https://youtu.be/{{ talk.youtube_id }}) - [{{ talk.speaker }}](https://twitter.com/{{ talk.twitter_handle }})
    {% endfor %}
{% endfor %}
