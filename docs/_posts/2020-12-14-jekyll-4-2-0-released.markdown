---
title: "Jekyll 4.2.0 Released"
date: 2020-12-14 14:12:20 +0530
author: ashmaroli
version: 4.2.0
category: release
---

Greetings Jekyllers! Jekyll v4.2.0 is out!

This release gives you a new hook named `:post_convert` that allows modifying rendered HTML contents before they are
placed into the designated layout(s).

Detecting files that get written into the same destination path has been a part of the diagnostics from `jekyll doctor`
for quite some time now. However, v4.2 has integrated that feature into the build process itself.

On the topic of log output, the `--verbose` output got a bit more verbose. Instead of just showing *documents* that are
being read, the output will now also show *pages* and *layouts* that are being read into the site.

Additionally, we have stopped overriding the `site.url` to `http://localhost:4000` in absolute URLs while developing
via `jekyll serve`.

As always, you can go through [the full list of changes](/docs/history/#v4-2-0) if you are interested in the various
memory-allocation optimizations made to Jekyll.

Special thanks to our community members who helped improving Jekyll codebase and documentation from v4.1.1:
Adam Alton, Alex Malaszkiewicz, Alexey Pelykh, Brittany Joiner, bytecode1024, Christopher Brown, Chuck Houpt,
Corey Megown, Dan Nemenyi, Enrico Tolotto, fauno, Felix Breidenstein, Francesco Bianco, Frank Taillandier,
Gabriel Staples, iBug, Jacobo Vidal, jaybe@jekyll, jesuslerma, jnozsc, joelkennedy, Joe Marshall, Liam Cooke,
Lou Rectoret, Malathi, m-naumann, Nicholas Paxford, Nikita Skalkin, Parker Moore, Pratyaksh Gautam, Rachel Cheyfitz,
SaintMalik, Seeker, Shannon Kularathna, Steven Xu, Takuya N, Thelonius Kort and Toby Glei.
