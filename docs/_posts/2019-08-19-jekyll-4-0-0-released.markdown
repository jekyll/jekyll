---
title: 'Jekyll 4.0.0 Released'
date: 2019-08-19 09:00:00 -0500
author: mattr-
version: 4.0.0
category: release
---

The long awaited Jekyll v4.0 is finally here :tada:

Like we teased in the prereleases, Jekyll 4.0 requires at least Ruby 2.4.0 and
is all about optimizations. Of course there are some new features and enhancements
as well. Read on! :wink:

While optimizations first made an appearance with Jekyll 3.8.0, Jekyll 4.0 takes
it to another level altogether.

Processing by Liquid is now cached to memory. So every Liquid template is
processed only as required. If you have 10 pages depending on a single layout,
the layout is cached and that data is then rendered as per the 10 different
contexts of the individual files.

Jekyll can now cache data to disk to avoid repeated processing of content that
doesn't change between build sessions. We currently have this set up on our
Markdown converters. So while the very first build will take a certain amount of
time, consequent builds with the same *content snapshot* will take a much lesser
time due to the disk-cache. However, this cache mechanism is disabled for builds
under the `safe` mode.

Jekyll 4.0 has moved to using `jekyll-sass-converter-2.0.0` by default. So what?
Well, that brings the power of native extensions into the mix and processes your
Sass stylesheet and partials with greater efficiency. All thanks to the `SassC`
library from the Sass team themselves.

We have also moved to using `kramdown-2.1` by default. Kramdown 2.x is a much
slimmer version than the 1.x series and therefore reduces the memory usage.
Yep, along with improving *performance*, Jekyll 4.0 also has improved memory-usage
with various other optimizations all of which translate to an improvement in the
overall usage of your system's resources for a Jekyll build.

Jekyll removed a bunch of stuff as well. We no longer cater to Pygments, RedCarpet,
and RDiscount. Our default highlighter Rouge is now locked to just modern versions.
Versions older that Rouge 3 are no longer supported.

Okay, okay, 'nuf with the boring technical stuff and unwrap the goodies. :smiley:

For starters, one would no longer need to prepend `site.baseurl` everytime they
use our `link` tag or `post_url` tag in their Liquid templates. They now utilize
our `relative_url` filter to do just that for you. Of course, that does mean
existing usage will need to be altered. (Sorry! :smiley:)

Additionally, `link` tag can now understand Liquid variables in the same fashion
our `include` tag does.

Ever wished that your Sass partials generated sourcemaps as well? Wish no more.
Jekyll's builtin sass-converter at v2.0 has got you covered.

There's some goodies for theme community as well. Developers may now bundle a
`config.yml` into their theme-gem to provide some boilerplate configurations for
the theme. Like other resources in the theme, these configuration values can also
be customized at the user's end.

For those looking for greater control and flexibility, you can now disable Liquid
processing for a particular page / document by adding `render_with_liquid: false`
to it's front matter.

Users can now use Liquid binary operators `and` or `or` in our `where_exp` filter
to utilize two expressions to steer the filtering operation.

Check out the [full history](/docs/history/#v4-0-0) and the various pull requests
for more details on all the enhancements and bug-fixes.

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
Benesch, Nikhil Swaminathan, Nikita Skalkin, Niklas Eicker, ninevra, Olivia
Hugger, Parker Moore, Pat Hawks, Patrick Favre-Bulle, Paul Kim, penguinpet,
Philip Belesky, Preston Lim, Ralph, Robert Riemann, Rosário Pereira Fernandes,
Sadik Kuzu, Samuel Gruetter, Scott Killen, Sri Pravan Paturi, Stephan Fischer,
Stephen Weiss, Steven Westmoreland, strangehill, Sundaram Kalyan Vedala, Thanos
Kolovos, Timo Schuhmacher, Tobias, Tom Harvey, Tushar Prajapati, Victor Afanasev,
Vinicius Flores, Vitor Oliveira, Wouter Schoot, XhmikosR, Yi Feng Xie, Zhang
Xiangze, 김정환, 104fps.

Happy Jekylling everyone!
