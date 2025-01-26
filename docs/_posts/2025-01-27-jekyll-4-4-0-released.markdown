---
title: 'Jekyll 4.4.0 Released'
date: 2025-01-27 20:45:32 +0530
author: ashmaroli
version: 4.4.0
category: release
---

Greetings Jekyllers, Jekyll v4.4.0 has been published!

This release comes with the following notable changes since v4.3.x:

* Liquid tag `highlight` now allows marking specific lines in the code-block.
* Allow customizing the port that the vendored livereload script listens to, either via command-line flag
  `--livereload-port NUM` or via setting desired value to key `livereload_port` in configuration file.
* Acknowledge paths passed to CLI flag `--livereload-ignore` or list of paths defined under configuration key
  `livereload_ignore` in order prevent automatic browser-refreshes on change to those paths.
* Support for Ruby versions older than Ruby 2.7.0 has been dropped. Regardless, we recommend using Ruby 3.2.0 or newer
  to reduce inconveniences with installing newer versions of various plugins for Jekyll.
* In order to improve the out-of-the-box experience with newer versions of Ruby, we have added gems `base64`, `csv` as
  runtime-dependencies. Consequently, those gems will be automatically installed with Jekyll and made available for use
  on issuing `bundle exec jekyll <command>`. *Users on older versions of Jekyll will have to manually add the gems to
  their Gemfile to resolve dependency errors*.
* Gem `json` has been added as a runtime-dependency as well to provide consistent behavior across different platforms and
  different Ruby versions.
* Version constraint on `mercenary` gem has been relaxed to automatically allow future releases.

Special thanks to my co-maintainers and members from our community who were instrumental in improving Jekyll codebase,
documentation and development workflow since the release of v4.3:

Akira Taguchi, Andy Coates, Daniel Haim, David Silveira, Gabriel B. Nunes, Gaelan Lloyd, Gourav Khunger, IFcoltransG,
James Hoctor, Joe Mahoney, Joel Coffman, Jonas Jared Jacek, Jorge, Josh Soref, José Romero, Juan Vásquez, KenHV, Khalila,
Koichi ITO, Krisztian Zsolt Sallai, Maciek Palmowski, Mamoru TASAKA, Matt Rogers, Michael Nordmeyer, Mike Slinn,
Moncef Belyamani, Muhab Abdelreheem, Olle Jonsson, Olly Headey, Otto Liljalaakso, Parker Moore, QuinnG8, Ram Vasuthevan,
Robert Austin, Robert Love, Sean M. Collins, Seth Falco, Seth Louis, Shruti Dalvi, Silent, Simon Wagar, Sutou Kouhei,
Tomáš Hübelbauer, Valeriy Van, Virgil Ierubino, Vít Ondruch, William Entriken, William Underwood, a story, halorrr,
iulianOnofrei (U-lee-aan), masaki, naoki kodama, nisbet-hubbard, plgagne, velle, waqarnazir, なつき and 林博仁 Buo-ren Lin

Happy Jekyllin'!!
