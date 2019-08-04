---
title: Jekyll 4.0.0.pre.beta1 Released
date: 2019-08-04 10:43:31 -0500
author: mattr-
version: 4.0.0.pre.beta1
categories: [release]
redirect_from: /news/2019/07/20/jekyll-4-0-0-pre-beta1-released/
---

Dear Jekyllers,

It's time for another pre-release of Jekyll 4! 🎉

This pre-release moves us further down the path of releasing Jekyll 4.0.0. All the same goodies [from the last pre-release](/news/2019/03/18/jekyll-4-0-0-pre-alpha1-released/) are here, along with a few more things I want to highlight:

Jekyll 4.0 is a new *major* version and it comes with a few breaking changes, notably :

1. We dropped support for [Ruby 2.3 which EOL at the end of March 2019](https://www.ruby-lang.org/en/downloads/).
   GitHub Pages runs Ruby 2.5.x, services like Netlify or Forestry already upgraded to latest Ruby 2.6.x.
2. `link` tag now include `relative_url` filter, hurray [no more need to prepend `{% raw %}{{ site.baseurl }}{% endraw %}` ](https://github.com/jekyll/jekyll/pull/6727).
3. [`{% raw %}{% highlight %}{% endraw %}` now behaves like `{% raw %}{% raw %}{% endraw %}`](https://github.com/jekyll/jekyll/pull/6821), so you can no longer use `include` tags within.
4. We dropped support for Pygments, RedCarpet and rdiscount.
5. We bumped kramdown to v2.

If you're a plugin developer, we still need your feedback! Your plugin may not work with version 4 and we'd like to fix those issues before we release.

Checkout the complete [changelog](https://github.com/jekyll/jekyll/releases/tag/v4.0.0.pre.beta1) for more details.

To test this pre version run:

```sh
gem install jekyll --pre
```

Please test this version thoroughly and file bugs as you encounter them.

Thanks to our dear contributors for helping making Jekyll better:

Aidan Fitzgerald, Akshat Kedia, Alex Wood, Alexey Kopytko, Alexey Pelykh, Ali Thompson, Ana María Martínez Gómez, Ananthakumar, Andreas Möller, Andrew Lyndem, Andy Alt, Anne Gentle, Anny, Arjun Thakur, Arthur Attwell, Ashwin Maroli, Behrang, Belhassen Chelbi, Ben Keith, Ben Otte, Bilawal Hameed, Boris Schapira, Boris van Hoytema, Brett C, Chris Finazzo, Christian Oliff, Damien Solodow, Dan Allen, Dan Friedman, Daniel Höpfl, David J. Malan, Denis McDonald, Derek Smart, Derpy, Dusty Candland, ExE Boss, Frank Taillandier, Gareth Cooper, Grzegorz Kaczorek, Isaac Goodman, Jacob Byers, Jakob Krigovsky, Jan Pobořil, Joe Shannon, Jordan Morgan, Jorie Tappa, Josue Caraballo, Justin Vallelonga, Jörg Steinsträter, Karel Bílek, Keith Mifsud, Kelly-Ann Green, Ken Salomon, Kevin Plattret, Kyle Barbour, Lars Kanis, Leandro Facchinetti, Luis Enrique Perez Alvarez, Luis Guillermo Yáñez, Ma HongJun, Manu Mathew, Mario, Martin Scharm, Matt Massicotte, Matthew Rathbone, Maxwell Gerber, Mertcan Yücel, Michael Hiiva, Mike Kasberg, Mike Neumegen, Monica Powell, Nicolas Hoizey, Nikhil Swaminathan, Nikita Skalkin, Olivia Hugger, Parker Moore, Pat Hawks, Patrick Favre-Bulle, Paul Kim, Philip Belesky, Preston Lim, Ralph, Robert Riemann, Rosário Pereira Fernandes, Samuel Gruetter, Scott Killen, Sri Pravan Paturi, Stephan Fischer, Stephen Weiss, Steven Westmoreland, Sundaram Kalyan Vedala, Thanos Kolovos, Timo Schuhmacher, Tobias, Tom Harvey, Tushar Prajapati, Victor Afanasev, Vitor Oliveira, Wouter Schoot, XhmikosR, Zhang Xiangze, _94gsc, argv-minus-one, chrisfinazzo, ikeji, jess, jpasholk, makmm, mo khan, ninevra, penguinpet, 김정환, 104fps

Happy Jekylling everyone!
