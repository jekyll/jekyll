---
title: 'Jekyll 3.4.1, or "Unintended Consequences"'
date: 2017-03-02 14:20:26 -0500
author: parkr
version: 3.4.1
categories: [release]
---

Conformity is a confounding thing.

We write tests to ensure that a piece of functionality that works today
will work tomorrow, as further modifications are made to the codebase. This
is a principle of modern software development: every change must have a
test to guard against regressions to the functionality implemented by that
change.

And yet, occasionally, our very best efforts to test functionality will be
thwarted. This is because of how our code produces unintended
functionality, which naturally goes untested.

In our documentation, we tell users to name their posts with the following
format:

```text
YYYY-MM-DD-title.extension
```

That format specifies exactly four numbers for the year, e.g. 2017, two
letters for the month, e.g. 03, and two letters for the day, e.g. 02. To
match this, we had the following regular expression:

```ruby
%r!^(?:.+/)*(\d+-\d+-\d+)-(.*)(\.[^.]+)$!
```

You might already see the punchline. While our documentation specifies the
exact number of numbers that is required for each section of the date, our
regular expression does not enforce this precision. What happens if a user
doesn't conform to our documentation?

We recently [received a bug report](https://github.com/jekyll/jekyll/issues/5603)
that detailed how the following file was considered a post:

```text
84093135-42842323-42000001-b890-136270f7e5f1.md
```

Of course! It matches the above regular expression, but doesn't satisfy
other requirements about those numbers being a valid date (unless you're
living in a world that has 43 million months, and 42 million (and one)
days). So, we [modified the regular expression to match our
documentation](https://github.com/jekyll/jekyll/pull/5609):

```ruby
%r!^(?:.+/)*(\d{4}-\d{2}-\d{2})-(.*)(\.[^.]+)$!
```

Our tests all passed and we were properly excluding this crazy date with 43
million months and days. This change shipped in Jekyll v3.4.0 and all was
well.

Well, not so much.

A very common way to specify the month of February is `2`. This is true for
all single-digit months and days of the month. Notice anything about our
first regular expression versus our second? The second regular expression
imposes a **minimum**, as well as maximum, number of digits. This change
made Jekyll ignore dates with single-digit days and months.

The first eight years of Jekyll's existence had allowed single-digit days
and months due to an imprecise regular expression. For some people, their
entire blog was missing, and there were no errors that told them why.

After receiving a few bug reports, it became clear what had happened.
Unintended functionality of the last eight years had been broken. Thus,
v3.4.0 was broken for a non-negligible number of sites. With a test site
in-hand from @andrewbanchich, I tracked it down to this regular expression
and [reintroduced](https://github.com/jekyll/jekyll/pull/5920) a proper
minimum number of digits for each segment:

```ruby
%r!^(?:.+/)*(\d{2,4}-\d{1,2}-\d{1,2})-(.*)(\.[^.]+)$!
```

And, I wrote a test.

This change was quickly backported to v3.4.0 and here we are: releasing
v3.4.1. It will fix the problem for all users who were using single-digit
months and days.

With this, I encourage all of you to look at your code for *unintended*
functionality and make a judgement call: if it's allowed, *should it be*?
If it should be allowed, make it *intended* functionality and test it! I
know I'll be looking at my code with much greater scrutiny going forward,
looking for unintended consequences.

Many thanks to our Jekyll affinity team captains who helped out, including
@pathawks, @pnn, and @DirtyF. Thanks, too, to @ashmaroli for reviewing my
change with an eye for consistency and precision. This was certainly a team
effort.

We hope Jekyll v3.4.1 brings your variable-digit dates back to their
previous glory. We certainly won't let that unintended functionality be
unintended any longer.

As always, Happy Jekylling!
