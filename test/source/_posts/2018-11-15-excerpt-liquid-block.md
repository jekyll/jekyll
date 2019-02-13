---
title:  liquid_block excerpt test with open tags in excerpt
layout: post
---

{% assign company = "Yoyodyne" %}
{% do_nothing_other %}
{% do_nothing %}
    {% unless false %}
        {% for i in (1..10) %}
            {% if true %}
                {% raw %}
                    EVIL! PURE AND SIMPLE FROM THE EIGHTH DIMENSION!
                {% endraw %}
            {% elsif false %}
                No matter where you go, there you are.
                {% break %}
            {% else %}
                {% case company %}
                    {% when "Yoyodyne" %}
                        Buckaroo Banzai
                    {% else %}
                        {% continue %}

                {% endcase %}
            {% endif %}
        {% endfor %}
    {% endunless %}
{% enddo_nothing %}
