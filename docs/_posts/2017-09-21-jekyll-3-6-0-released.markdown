---
title: 'Jekyll turns 3.6!'
date: 2017-09-21 16:38:20 -0400
author: parkr
version: 3.6.0
categories: [release]
---

Another much-anticipated release of Jekyll. This release comes with it Rouge 2 support, but note you can continue to use Rouge 1 if you'd prefer. We also now require Ruby 2.1.0 as 2.0.x is no longer supported by the Ruby team.

Otherwise, it's a massive bug-fix release! A few bugs were found and squashed with our `Drop` implementation. We're using the Schwartzian transform to speed up our custom sorting (thanks, Perl community!). We now protect against images that are named like posts and we generally worked on guarding our code to enforce requirements, instead of assuming the input was as expected.

Please let us know if you find any bugs! You can see [the full history here](/docs/history/#v3-6-0).

Many thanks to our contributors who helped make this release possible: Aleksander Kuś, André Jaenisch, Antonio Argote, ashmaroli, Ben Balter, Bogdan, Bradley Meck, David Zhang, Florian Thomas, Frank Taillandier, Jordon Bedwell, Joshua Byrd, Kyle Zhao, lymaconsulting, Maciej Bembenista, Matt Sturgeon, Natanael Arndt, Ohad Schneider, Pat Hawks, Pedro Lamas, and Sid Verma.

As always, Happy Jekylling!
