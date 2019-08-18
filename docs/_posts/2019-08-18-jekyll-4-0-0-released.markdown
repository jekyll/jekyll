---
title: 'Jekyll 4.0.0 Released'
date: 2019-08-18 09:00:00 -0500
author: mattr-
version: 4.0.0
category: release
---

The long awaited Jekyll v4.0 is finally here :tada:

### Key changes

- Lots of performance improvements :rocket:
- Cache builds for faster rebuilds (30% on average)
- Dropped support for Ruby < 2.4, tested on Ruby 2.6
- Dropped support for Rouge < 3, Pygments, RedCarpet, rdiscount
- Switched to SassC library, generate sourcemaps by default
- Incorporated `relative_url` in `link` and `post_url` tags
- Added support for using Liquid variables in the `link` tag.
- Allow custom sorting of collection documents (`sort_by`, `order`)
- Allow disabling Liquid via front matter with `render_with_liquid: false`
- Added support for binary operators in `where_exp` filter (`and`, `or`)
- Added support for loading `_config.yml` from within current gem-based theme
- and a lot of bug fixes :bug:

Check out the [full history](/docs/history/#v4-0-0) for more details.

We encourage you to [upgrade from Jekyll 3.x](/docs/upgrading/3-to-4/).

Edit your project's `Gemfile` to test Jekyll v4.x:

```ruby
gem "jekyll", "~> 4.0"
```

Then run `bundle update` to update all dependencies. Unless you're using
third-party plugins that haven't yet added support for Jekyll 4.0, you should be
good to go.

Plugins and themes authors must loosen jekyll dependency in their `gemspec` file
to allow for Jekyll v4.0:

`spec.add_runtime_dependency "jekyll", ">= 3.6", "< 5.0"`

Feel free to reach out on our [community forum](https://talk.jekyllrb.com) if
you have any question.

Many thanks to the 139 contributors who made this release possible (in
alphabetical order): Aidan Fitzgerald, Akshat Kedia, Ale Muñoz, Alex Wood,
Alexey Kopytko, Alexey Pelykh, Ali Thompson, Ana María Martínez Gómez,
Ananthakumar, Andreas Möller, Andrew Lyndem, Andrew Marcuse, Andy Alt, Anne
Gentle, Anny, Anuj Bhatnagar, argv-minus-one, Arjun Thakur, Arthur Attwell,
Ashwin Maroli, Behrang, Belhassen Chelbi, Ben Keith, Ben Otte, Bilawal Hameed,
Bjorn Krols, Boris Schapira, Boris van Hoytema, Brett C, Chris Finazzo, Chris
Oliver, chrisfinazzo, Christian Oliff, Christoph Päper, Damien Solodow, Dan
Allen, Dan Friedman, Daniel Höpfl, David J. Malan, David Kennell, David Zhang,
Denis McDonald, Derek Smart, Derpy, Dusty Candland, Edgar Tinajero, Elvio
Vicosa, ExE Boss, Fons van der Plas, Frank Taillandier, Gareth Cooper, Grzegorz
Kaczorek, Haris Bjelic, Hodong Kim, ikeji, Isaac Goodman, Jacob Byers, Jakob
Krigovsky, James Rhea, Jan Pobořil, jess, jingze_lu, Joe Shannon, Jordan Morgan,
Jörg Steinsträter, Jorie Tappa, Josue Caraballo, jpasholk, Justin Vallelonga,
Karel Bílek, Keith Mifsud, Kelly-Ann Green, Ken Salomon, Kevin Plattret, krissy,
Kyle Barbour, Lars Kanis, Leandro Facchinetti, Liam Rosenfeld, Luis Enrique
Perez Alvarez, Luis Guillermo Yáñez, Ma HongJun, makmm, Manu Mathew, Mario,
Martin Scharm, Matt Kraai, Matt Massicotte, Matt Rogers, Matthew Rathbone,
Maxwell Gerber, Mertcan Yücel, Michael Bishop, Michael Hiiva, Michelle Greer,
Mike Kasberg, Mike Neumegen, mo khan, Monica Powell, Nicolas Hoizey, Nikhil
Swaminathan, Nikita Skalkin, Niklas Eicker, ninevra, Olivia Hugger, Parker
Moore, Pat Hawks, Patrick Favre-Bulle, Paul Kim, penguinpet, Philip Belesky,
Preston Lim, Ralph, Robert Riemann, Rosário Pereira Fernandes, Sadik Kuzu,
Samuel Gruetter, Scott Killen, Sri Pravan Paturi, Stephan Fischer, Stephen
Weiss, Steven Westmoreland, strangehill, Sundaram Kalyan Vedala, Thanos Kolovos,
Timo Schuhmacher, Tobias, Tom Harvey, Tushar Prajapati, Victor Afanasev, Vitor
Oliveira, Wouter Schoot, XhmikosR, Yi Feng Xie, Zhang Xiangze, 김정환, 104fps.

Happy Jekylling everyone!
