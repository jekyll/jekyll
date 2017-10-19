---
title: "Diversity in Open Source, and Jekyll's role in it"
date: 2017-10-19 21:33:00 +0200
author: pup
categories: [community]
---

Open Source has a problem with diversity. GitHub recently conducted a [survey](http://opensourcesurvey.org/2017) that revealed that 95% of the respondents were male, making the demographic even worse than in tech overall. Every other week, I seem to hear of another case of a maintainer engaging in targeted harassment against minorities. People somehow deem it completely okay to let these things slide, though.

So yeah, there's a bunch of big problems plaguing open source. Fortunately, there's a couple of things we can do to make it easier and more comfortable for people, especially minorities, that have never before contributed to any open source project before, to contribute to our project.

## Add a Code of Conduct, and enforce it

This might seem like one of the easiest steps to do, but it actually requires a lot of dedication to pull through with it. Basically, a Code of Conduct is a document detailing what is and what isn't acceptable behavior in your project. A good Code of Conduct also details enforcement procedures, that means, how the person violating the Code of Conduct gets dealt with. This is the point at which I've seen a looooot of projects fail at. It's easy enough to copy-paste a Code of Conduct into your project, but it's just, if not more important to be clear on how to enforce it. Inconsistent or worse, nonexistent enforcement is just going to scare off newcomers even more!

The most widely adopted Code of Conduct is the [Contributor Covenant](https://www.contributor-covenant.org/). It's a very good catch-all document, but it is a bit light in the enforcement section, so I'd recommend to flesh it out by yourself, be it by means of adding contact information or expanding the enforcement rules.

No matter which Code of Conduct you pick, the most important thing is to actually _read it for yourself_. The worst thing in open source is a maintainer that doesn't know when they've violated their own Code of Conduct.

## Document your contributing workflow

The problem that puts people off the most is incomplete or missing documentation, as revealed through GitHub's [open source survey](http://opensourcesurvey.org/2017). A very popular myth in programming is that good code explains itself, which might be true, but only for the person writing it. It's important, especially you put your code out there for the world to see, to document your code, but also the process by which you maintain your project. Otherwise, it's going to be extremely hard for newcomers to even figure out where to begin contributing to your project.

Jekyll has [an entire section of its docs](/docs/contributing) related to information on how to contribute for this very reason. Every documentation page has a link to directly edit and improve it on GitHub. It's important to realize that not all contributions are code. It can be documentation, it can be reviewing pull requests, but it can also just be weighing into issues, and all of this should be recognized in the same way.

## Create newcomer-friendly issues

For most people new to open source, by far the biggest hurdle is putting up the first pull request. That's why initiatives such as [YourFirstPR](https://twitter.com/yourfirstpr) and [First Timers Only](http://www.firsttimersonly.com/) were started. Recently, [a GitHub bot that automatically creates first-timer friendly issues](https://github.com/hoodiehq/first-timers-bot) was created, which makes it very easy to make small changes into viable pull requests that can be created by any newcomer! So we decided to give it a shot, and we've created a couple of very easy first timers only issues:

- [Issue #6437](https://github.com/jekyll/jekyll/issues/6437)
- [Issue #6438](https://github.com/jekyll/jekyll/issues/6438)
- [Issue #6439](https://github.com/jekyll/jekyll/issues/6439)

(There's also an up-to-date listing of all of our first-timers only issues [here](https://github.com/jekyll/jekyll/issues?q=is%3Aissue+is%3Aopen+label%3Afirst-time-only))

These issues are designed only to be done by someone who has had little to no exposure to contributing to open source before, and are offering full support from project maintainers in case a question arises.

Jekyll is a very big and popular open source project, and we hope that with these issues, we can help people who haven't contributed to open source before to catch a footing in these unsteady waters.

## Be nice

I know this is a cliche and a overused phrase, but really, it works if you pull through with it. Come to terms with the fact that some people aren't as fast or reliable as you might want to think. Don't get angry when a contributor takes a day longer than you might like them to. Treat new contributors to your project with respect, but also with hospitality. Think twice before you send that comment with slurs in it.

I've been contributing to open source for about 4 years now, and I've had my fair share of horrible, horrible experiences. But Jekyll has historically been a project that has always valued the people contributing to it over the code itself, and I hope we can keep it that way. I also hope that other project maintainers read this and take inspiration from this post. Every project should be more diverse.
