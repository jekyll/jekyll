---
layout: news_item
title: "Jekyll's Google Summer of Code Project: The CMS You Always Wanted"
date: "2016-06-03 13:21:02 -0700"
author: parkr
categories: [community]
---

This year, Jekyll applied to be a part of [Google Summer of Code](https://summerofcode.withgoogle.com/how-it-works/). Students were able to propose any project related to Jekyll. With a gracious sponsorship from GitHub and the participation of myself, @benbalter and @jldec, Jekyll was able to accept two students for the 2016 season, @mertkahyaoglu and @rush-skills.

These students are working on a project that fills a huge need for the community: **a graphical solution for managing your site's content.**

Current plans include a fully-integrated admin which spins up when you run `jekyll serve` and a web interface at an address like `http://localhost:4000/admin/`. The server implements a common interface which would make a hosted version to make updates to hosted content like a repository on GitHub very easy to write – simply implement the CRUD API and the web interface will happily use that instead.

The strength of text files as the storage medium for content has been part of Jekyll's success. [Our homepage](/) lauds the absence of a traditional SQL database when using Jekyll – your content should be what demands your time, not pesky database downtime. Unfortunately, understanding of the structure of a Jekyll site takes some work, enough that for some users, it's prohibitive to using Jekyll to accomplish their publishing goals.

Mert and Ankur both applied to take on this challenge and agreed to split the project, one taking on the web interface and the other taking on the backend. We're very excited to see a fully-functional CMS for Jekyll at the end of the summer produced by these excellent community members, and we hope you'll join us in cheering them on and sharing our gratitude for all their hard work.

Thanks, as always, for being part of such a wonderful community that made this all possible. I'm honored to work with each of you to create something folks all around the globe find a joy to use. I look forward to our continued work to move Jekyll forward.

As always, Happy Jekylling!
