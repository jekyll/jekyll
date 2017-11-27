---
title: "Diversity in Open Source, and Jekyll's role in it"
date: 2017-10-19 21:33:00 +0200
author: pup
categories: [community]
---

Open Source has a problem with diversity. GitHub recently conducted a [survey](http://opensourcesurvey.org/2017) which revealed that 95% of the respondents were identifying as male. This is even worse than in the tech industry overall, where the percentage is only about 76%. Every other week, there seems to be another case of a maintainer engaging in targeted harassment against minorities. People somehow deem it completely okay to let these things slide, though.

Fortunately, there's a couple of things we can do to make it easier and more comfortable for people that have never contributed to any open source project before, to contribute to our projects.

## Add a Code of Conduct, and enforce it

This might seem like one of the easiest steps to do, but it actually requires a lot of dedication to pull through with. Basically, a Code of Conduct is a document detailing what is and what isn't acceptable behavior in your project. A good Code of Conduct also details enforcement procedures, that means how the person violating the Code of Conduct gets dealt with. This is the point at which I've seen a looooot of projects fail. It's easy enough to copy-paste a Code of Conduct into your project, but it's more important to be clear on how to enforce it. Inconsistent —or worse, nonexistent— enforcement is just going to scare off newcomers even more!

The most widely adopted Code of Conduct is the [Contributor Covenant](https://www.contributor-covenant.org/). It's a very good catch-all document, but it is a bit light in the enforcement section, so I'd recommend to flesh it out by yourself, be it by means of adding contact information or expanding the enforcement rules.

No matter which Code of Conduct you pick, the most important thing is to actually _read it for yourself_. The worst thing in open source is a maintainer that doesn't know when they've violated their own Code of Conduct.

## Document your contributing workflow

The problem that puts people off the most is incomplete or missing documentation, as revealed through GitHub's [open source survey](http://opensourcesurvey.org/2017). A very popular myth in programming is that good code explains itself, which might be true, but only for the person writing it. It's important, especially once you put your project out there for the world to see, to document not only your code, but also the process by which you maintain it. Otherwise, it's going to be extremely hard for newcomers to even figure out where to begin contributing to your project.

Jekyll has [an entire section of its docs](/docs/contributing) dedicated to information on how to contribute for this very reason. Every documentation page has a link to directly edit and improve it on GitHub. It's also important to realize that not all contributions are code. It can be documentation, it can be reviewing pull requests, but it can also just be weighing into issues, and all of this should be recognized in the same way. At Jekyll, out of 397 total merged pull requests in the last year, __204__ were documentation pull requests!

## Create newcomer-friendly issues

For most people new to open source, the biggest hurdle is creating their first pull request. That's why initiatives such as [YourFirstPR](https://twitter.com/yourfirstpr) and [First Timers Only](http://www.firsttimersonly.com/) were started. Recently, [a GitHub bot that automatically creates first-timer friendly issues](https://github.com/hoodiehq/first-timers-bot) was launched, which makes it very easy for maintainers to convert otherwise small or trivial changes into viable pull requests that can be taken on by newcomers! So we decided to give it a shot, and we've created a couple of very easy `first timers only` issues:

- [Issue #6437](https://github.com/jekyll/jekyll/issues/6437)
- [Issue #6438](https://github.com/jekyll/jekyll/issues/6438)
- [Issue #6439](https://github.com/jekyll/jekyll/issues/6439)

(There's also an up-to-date listing of all of our `first timers only` issues [here](https://github.com/jekyll/jekyll/issues?q=is%3Aissue+is%3Aopen+label%3Afirst-time-only))

These issues are designed to be taken on only by someone who has had little to no exposure to contributing to open source before, and additionally, project maintainers offer support in case a question arises.

Jekyll is a very big and popular open source project, and we hope that with these special issues, we can help people who haven't contributed to open source before to catch a footing in these unsteady waters.

## Be nice

I know this is a cliche and a overused phrase, but really, it works if you pull through with it. Come to terms with the fact that some people aren't as fast or reliable as you might want to think. Don't get angry when a contributor takes a day longer than you might like them to. Treat new contributors to your project with respect, but also with hospitality. Think twice before you send that comment with slurs in it.

I've been contributing to open source for about 4 years now, and I've had my fair share of horrible, horrible experiences. But Jekyll has historically been a project that has always valued the people contributing to it over the code itself, and I hope we can keep it that way. I also hope that other project maintainers read this and take inspiration from this post. Every project should be more diverse.
