---
layout: post
---

{%
  highlight
  ruby
%}
{% assign foo = 'foobar' %}
{% raw
%}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{%
  endraw
%}
{%
  endhighlight
%}

So let's talk business.
