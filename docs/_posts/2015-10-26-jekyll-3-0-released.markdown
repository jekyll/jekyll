---
title: 'Jekyll 3.0 Released'
date: 2015-10-26 15:37:30 -0700
author: parkr
version: 3.0
categories: [release]
---

The much-anticipated Jekyll 3.0 has been released! Key changes:

- Incremental regeneration (experimental, enable with `--incremental`)
- Liquid profiler (add `--profile` to a build or serve)
- Hook plugin API (no more monkey-patching!)
- Dependencies reduced from 14 to 8, none contain C extensions. We're hoping to reduce this even more in the future.
- Changed version support: no support for Ruby 1.9.3, added basic JRuby support. Better Windows support.
- Extension-less URLs
- `site.collections` is an array of collections, thus:
    - `collection[0]` becomes `collection.label`
    - `collection[1]` becomes `collection`
- Default highlighter is now Rouge instead of Pygments
- Lots of performance improvements
- ... and lots more!

We also added a [Code of Conduct](/docs/conduct/) to encourage a happier, nicer community where contributions and discussion is protected from negative behaviour.

A huge shout-out to the amazing Jekyll Core Team members Jordon Bedwell, Alfred Xing, and Matt Rogers for all their hard work in making Jekyll 3 the best release yet.

We also added [Jekyll Talk](https://talk.jekyllrb.com), managed solely by Jordon, which offers a modern forum experience for Jekyllers across the globe to talk and learn about Jekyll!

As always, check out the [full history](/docs/history/#v3-0-0) for more details.

Our contributors are the core of what makes Jekyll great! Many thanks to the 132 contributors who made this release possible (in alphabetical order): AJ Acevedo, Adam Richeimer, Alan Scherger, Alfred Xing, Anatol Broder, Andrew Dunning, Anna Debenham, Anton, Arne Gockeln, Arthur Hammer, Arthur Neves, BRAVO, Ben Balter, Bernardo Dias, BigBlueHat, Brandon Mathis, Bruce Smith, Cai⚡️, Carlos Matallín, ChaYoung You, Christian Vuerings, Cory Simmons, David Herman, David Silva Smith, David Smith, David Wales, David Williamson, DigitalSparky, Dimitri König, Dominik, Eduardo Boucas, Eduardo Bouças, Eduardo Bouças, Erlend Sogge Heggen, Eugene Pirogov, Ezmyrelda Andrade, Fabian Rodriguez, Fabian Tamp, Fabio Niephaus, Falko Richter, Florian Weingarten, Fonso, Garen Torikian, Guillaume LARIVIERE, Günter Kits, I´m a robot, Jason Ly, Jedd Ahyoung, Jensen Kuras, Jesse Pinho, Jesse W, Jim Meyer, Joel Glovier, Johan Bové, Joop Aué, Jordan Thornquest, Jordon Bedwell, Joseph Anderson, Julien Bourdeau, Justin Weiss, Kamil Dziemianowicz, Kevin Locke, Kevin Ushey, Leonard, Lukas, Mads Ohm Larsen, Malo Skrylevo, Marcus Stollsteimer, Mark Phelps, Mark Tareshawty, Martijn den Hoedt, Martin Jorn Rogalla, Martin Rogalla, Matt Rogers, Matt Sheehan, Matthias Nuessler, Max, Max Beizer, Max White, Merlos, Michael Giuffrida, Michael Tu, Mike Bland, Mike Callan, MonsieurV, Nate Berkopec, Neil Faccly, Nic West, Nicholas Burlett, Nicolas Hoizey, Parker Moore, Pascal Borreli, Pat Hawks, Paul Rayner, Pedro Euko, Peter Robins, Philipp Rudloff, Philippe Loctaux, Rafael Picanço, Renaud Martinet, Robert Papp, Ryan Burnette, Ryan Tomayko, Seb, Seth Warburton, Shannon, Stephen Crosby, Stuart Kent, Suriyaa Kudo, Sylvester Keil, Tanguy Krotoff, Toddy69, Tom Johnson, Tony Eichelberger, Tunghsiao Liu, Veres Lajos, Vitaly Repin, Will Norris, William Entriken, XhmikosR, chrisfinazzo, eksperimental, hartmel, jaybe@jekyll, kaatt, nightsense, nitoyon, robschia, schneems, sonnym, takuti, and tasken.

Happy Jekylling!
