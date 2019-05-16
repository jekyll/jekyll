---
title: Jekyll 4.0.0.pre.alpha1 Released
date: 2019-03-18 18:17:31 +0100
author: dirtyf
version: 4.0.0.pre.alpha1
category: release
---

Dear Jekyllers,

Time has come to release a first alpha for Jekyll 4!

This pre version fixes many bugs, and should improve your build times. Some of you already shared [really](https://forestry.io/blog/how-i-reduced-my-jekyll-build-time-by-61/) [good](https://boris.schapira.dev/2018/11/jekyll-build-optimization/) results. We hope your Jekyll sites will also benefit from these optimizations.

If you're a plugin developer, we definitely need your feedback, especially if your plugin does not work with v4.

Jekyll now exposes a [caching API](/tutorials/cache-api/), that some plugins could benefit from.

Also be aware that it's a new *major* version, and it comes with a few breaking changes, notably :

1. We dropped support for [Ruby 2.3 who goes EOL at the end of the month](https://www.ruby-lang.org/en/downloads/).
   GitHub Pages runs Ruby 2.5.x, services lile Netlify or Forestry already upgraded to latest Ruby 2.6.x.
2. `link` tag now include `relative_url` filter, hurray [no more need to prepend `{% raw %}{{ site.baseurl }}{% endraw %}` ](https://github.com/jekyll/jekyll/pull/6727).
3. [`{% raw %}{% highlight %}{% endraw %}` now behaves like `{% raw %}{% raw %}{% endraw %}`](https://github.com/jekyll/jekyll/pull/6821), so you can no longer use `include` tags within.
4. We dropped support for Pygments, RedCarpet and rdiscount.
5. We bumped kramdown to v2.

Checkout the complete [changelog](https://github.com/jekyll/jekyll/releases/tag/v4.0.0.pre.alpha1) for more details.

To test this pre version run:

```sh
gem install jekyll --pre
```

Please test this version thoroughly and file bugs as you encounter them.

Thanks to our dear contributors for helping making Jekyll better:

Aidan Fitzgerald, Akshat Kedia, Alex Wood, Alexey Kopytko, Alexey Pelykh, Ali Thompson, Ana María Martínez Gómez, Ananthakumar, Andreas Möller, Andrew Lyndem, Andy Alt, Anne Gentle, Anny, Arjun Thakur, Arthur Attwell, Ashwin Maroli, Behrang, Belhassen Chelbi, Ben Keith, Ben Otte, Bilawal Hameed, Boris Schapira, Boris van Hoytema, Brett C, Chris Finazzo, Christian Oliff, Damien Solodow, Dan Allen, Dan Friedman, Daniel Höpfl, David J. Malan, Denis McDonald, Derek Smart, Derpy, Dusty Candland, ExE Boss, Frank Taillandier, Gareth Cooper, Grzegorz Kaczorek, Isaac Goodman, Jacob Byers, Jakob Krigovsky, Jan Pobořil, Joe Shannon, Jordan Morgan, Jorie Tappa, Josue Caraballo, Justin Vallelonga, Jörg Steinsträter, Karel Bílek, Keith Mifsud, Kelly-Ann Green, Ken Salomon, Kevin Plattret, Kyle Barbour, Lars Kanis, Leandro Facchinetti, Luis Enrique Perez Alvarez, Luis Guillermo Yáñez, Ma HongJun, Manu Mathew, Mario, Martin Scharm, Matt Massicotte, Matthew Rathbone, Maxwell Gerber, Mertcan Yücel, Michael Hiiva, Mike Kasberg, Mike Neumegen, Monica Powell, Nicolas Hoizey, Nikhil Swaminathan, Nikita Skalkin, Olivia Hugger, Parker Moore, Pat Hawks, Patrick Favre-Bulle, Paul Kim, Philip Belesky, Preston Lim, Ralph, Robert Riemann, Rosário Pereira Fernandes, Samuel Gruetter, Scott Killen, Sri Pravan Paturi, Stephan Fischer, Stephen Weiss, Steven Westmoreland, Sundaram Kalyan Vedala, Thanos Kolovos, Timo Schuhmacher, Tobias, Tom Harvey, Tushar Prajapati, Victor Afanasev, Vitor Oliveira, Wouter Schoot, XhmikosR, Zhang Xiangze, _94gsc, argv-minus-one, chrisfinazzo, ikeji, jess, jpasholk, makmm, mo khan, ninevra, penguinpet, 김정환, 104fps

Happy Jekylling everyone!
