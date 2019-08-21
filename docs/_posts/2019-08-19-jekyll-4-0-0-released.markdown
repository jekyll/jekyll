---
title: 'Jekyll 4.0.0 Released'
date: 2019-08-20 10:00:00 -0500
author: mattr-
version: 4.0.0
category: release
---

Hi! 👋 I bring some good news! Jekyll 4.0.0 is finally here! 🎉

There's quite a bit in this release to unpack, so let me hit the high points quickly:
 - Ruby 2.4.0 or greater is now required.
 - Rouge 3.0 or greater is now required for syntax highlighting.
 - Jekyll builds should be much faster.
 - Kramdown 2.1 is now the default markdown engine.
 - Sass processing should be faster.
 - We dropped support for a lot of stuff, specifically:
   - Pygments
   - RedCarpet
   - RDiscount


Alright, so with the high points out of the way, let's get into the details a little bit.

### Cache all the things! 💰

While some optimizations first made an appearance with Jekyll 3.8.0, Jekyll 4.0 takes
it to another level altogether.

Jekyll 4.0 caches the processing done by Liquid in memory. So every Liquid
template is processed only as required. If you have 10 pages depending on a
single layout, the layout is cached and that data is then rendered as per the
10 different contexts of the individual files.

There's also a disk cache! Jekyll can now cache data to disk to avoid repeated
processing of content that doesn't change between build sessions. Currently,
this is limited to markdown. So while the very first build will take a certain
amount of time, consequent builds for content that hasn't changed will take
much less time due to the disk-cache. Disk caching is disabled for `safe` mode,
however.

### Super-powered content transformations 💪

We've upgraded Sass support so it should be faster. There's also
support for sourcemaps now! Under the hood, our Sass support uses the `SassC`
library now, which is supported directly by the Sass team, which should mean
better support for everybody in the long run.

Kramdown is updated to version 2.1. This also brings with it a bunch of changes
to the Kramdown configuration, as the Kramdown team have extracted a fair
number of features into separate gems. Support for GitHub Flavored Markdown is
enabled by default, but if you're using another Kramdown extension in your
site, you'll likely need to update your plugin configuration. See the [upgrade
guide](/docs/upgrading/3-to-4/) for more details.

The `link` and `post_url` tags no longer need `site.baseurl` prepended every
time they're used. Those tags now use our `relative_url` filter to take care of
this for you. Existing uses of the prepending pattern will break though!
Sorry! :sweat_smile:

A few other smaller features when it comes to content:
 - The `link` tag understands Liquid variables in the same fashion our
 `include` tag does now.
 - Disable Liquid processing for a particular page / document by adding
 `render_with_liquid: false` to its front matter.
 - Liquid's binary `and` and `or` operations can be used in the `where_exp`
 filter for more powerful filtering

There's some goodies for theme community as well. Developers may now bundle a
`config.yml` into their theme-gem to provide some boilerplate configurations for
the theme. Like other resources in the theme, these configuration values can also
be customized at the user's end.


Check out the [full history](/docs/history/#v4-0-0) and the various pull requests
for more details on all the enhancements and bug-fixes.

### Upgrading 📈

First, read the [upgrade guide](/docs/upgrading/3-to-4/)!

Next, Edit your project's `Gemfile` to test Jekyll v4.x:

```ruby
gem "jekyll", "~> 4.0"
```

Then run `bundle update` to update all dependencies. Unless you're using
third-party plugins that haven't yet added support for Jekyll 4.0, you should be
good to go.

Plugins and themes authors must relax the jekyll dependency in their `gemspec` file
to allow for Jekyll v4.0:

`spec.add_runtime_dependency "jekyll", ">= 3.6", "< 5.0"`

If your favorite plugin hasn't relaxed that dependency yet, please gently
encourage them to do so. :slightly_smiling_face:

### Have questions❓

Please reach out on our [community forum](https://talk.jekyllrb.com)


### Thank you!! 🙇

Jekyll would not be possible without the many people who have taken the time to write issues, submit pull requests, create themes, answer questions for other users, or make their own sites using our project. Thanks to all of you who contribute, no matter how small you think your contribution might have been.

In addition, special thanks to the 139 contributors who made this
release possible via a pull request submission (in alphabetical order): Aidan
Fitzgerald, Akshat Kedia, Ale Muñoz, Alex Wood,
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
Benesch, Nikhil Swaminathan, Nikita Skalkin, Niklas Eicker, ninevra, Olivia
Hugger, Parker Moore, Pat Hawks, Patrick Favre-Bulle, Paul Kim, penguinpet,
Philip Belesky, Preston Lim, Ralph, Robert Riemann, Rosário Pereira Fernandes,
Sadik Kuzu, Samuel Gruetter, Scott Killen, Sri Pravan Paturi, Stephan Fischer,
Stephen Weiss, Steven Westmoreland, strangehill, Sundaram Kalyan Vedala, Thanos
Kolovos, Timo Schuhmacher, Tobias, Tom Harvey, Tushar Prajapati, Victor Afanasev,
Vinicius Flores, Vitor Oliveira, Wouter Schoot, XhmikosR, Yi Feng Xie, Zhang
Xiangze, 김정환, 104fps.

Happy Jekylling everyone!
