**This guide is for {{ include.who }}.**
{% case include.who -%}
  {%- when "affinity team captains" -%}
These special people are **team maintainers** of one of our [affinity teams][] and help triage and evaluate the issues
and contributions of others.
  {%- when "contributors" -%}
These special people have contributed to one or more of Jekyll's repositories, but do not yet have write access to any.
  {%- when "maintainers" -%}
These special people have **write access** to one or more of Jekyll’s repositories and help merge the contributions of
others.
  {%- else -%}
These special people contribute to one or more of Jekyll's repositories or help merge the contributions of others.
{%- endcase %}
You may find what’s written here interesting, but it’s definitely not for everyone.
{: .note .info}
