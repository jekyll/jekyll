---
title: "Reviewing a Pull Request"
---

**This guide is for maintainers.** These special people have **write access** to one or more of Jekyll's repositories and help merge the contributions of others. You may find what is written here interesting, but it’s definitely not for everyone.
{: .note .info }

## Respond Kindly

Above all else, please review a pull request kindly. Our community can only be strong if we make it a welcoming and inclusive environment. To further promote this, the Jekyll community is governed by a [Code of Conduct](/docs/conduct/) by which all community members must abide.

Use emoji liberally :heart: :tada: :sparkles: :confetti_ball: and feel free to be emotive!! Contributions keep this project moving forward and we're always happy to receive them, even if the pull request isn't ultimately merged.

Mike McQuaid's post on the GitHub blog entitled ["Kindly Closing Pull Requests"](https://github.com/blog/2124-kindly-closing-pull-requests) is a great place to start. It describes various scenarios in which it would be acceptable to close a pull request for reasons other than lack of technical integrity or accuracy. Part of being kind is responding to and resolving pull requests quickly.

## Respond Quickly

We should be able to review all pull requests within one week. The only time initial review should take longer is if all the maintainers mysteriously took vacation during the same week. Promptness encourages frequent, high-quality contributions from community members and other maintainers.

If your response requires a response on the part of the author, please add the `pending-feedback` tag. @jekyllbot will automatically remove the tag once the author of the pull request responds.

## Resolve Quickly

Similarly, we should aim to resolve pull requests quickly. If a pull request introduces a feature which does not fit into the core purpose or goal of the project, close it promptly with a kind explanation of why it is not acceptable.

Leave detailed comments wherever possible. Provide the contributor with context around why the change you are requesting is necessary, or why the question you are asking is important to resolve. The more context we can clearly communicate to the contributor, the better able the contributor is to provide high-quality patches.

You may close a pull request if more than 30 days pass without a response from the author.

In some cases, review will involve many weeks of back-and-forth. As long as communication continues, this is fine. Ideally, any PR would be capable of resolution within 30 days of it being opened.

## Look for Tests

If this is a code change, are there tests for the updated or added behaviour? Shipping a version with bugs is inevitable, but ensuring changes are tested helps keep bugs and regressions to a minimum.

## CI Must Pass

It is fine to ask a contributor to investigate failures on Travis and patch them up before you begin your review. It is helpful to leave a message for the contributor indicating that the tests have failed and that no review will occur before the tests pass. If they ask for help, take a look and assist if you can.

## Rule of Two

A pull request may be merged once two maintainers have reviewed the pull request and indicated that it is acceptable to them. There is no need to wait for a third unless one of the two reviewers wishes for another set of eyes.

## Think Security

We owe it to our users to ensure that using a theme from the community or building someone else's site doesn't come with built-in security vulnerabilities. Things like where files may be read from and written to are important to keep secure. Jekyll is also the basis for hosted services such as [GitHub Pages](https://pages.github.com), which cannot upgrade when security issues are introduced.
