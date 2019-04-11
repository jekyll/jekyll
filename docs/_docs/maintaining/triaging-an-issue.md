---
title: "Triaging an Issue"
---

**This guide is for maintainers.** These special people have **write access** to one or more of Jekyll's repositories and help merge the contributions of others. You may find what is written here interesting, but it’s definitely not for everyone.
{: .note .info }

Before evaluating an issue, it is important to identify if it is a feature
request or a bug. For the Jekyll project the following definitions are used
to identify a feature or a bug:

**Feature** - A feature is defined as a request that adds functionality to
Jekyll outside of its current capabilities.
**Bug** - A bug is defined as an issue that identifies an error that a user
(or users) encounter when using current Jekyll functionalities.

## Feature?

If the issue describes a feature request, ask:

1. Is this a setting? [Settings are a crutch](http://ben.balter.com/2016/03/08/optimizing-for-power-users-and-edge-cases/#settings-are-a-crutch) for doing "the right thing". Settings usually point to a bad default or an edge case that could be solved easily with a plugin. Keep the :christmas_tree: of settings as small as possible so as not to reduce the usability of the product. We like the philosophy "decisions not options."
2. Would at least 80% of users find it useful? If even a quarter of our users won't use it, it's very likely that the request doesn't fit our product's core goal.
3. Is there another way to accomplish the end goal of the request? Most feature requests are due to bad documentation for or understanding of a pre-existing feature. See if you can clarify the end goal of the request. What is the user trying to do? Could they accomplish that goal through another feature we already support?
4. Even if 80% of our users will use it, does it fit the core goal of our project? We are writing a tool for making static websites, not a swiss army knife for publishing more generally.

Feel free to get others' opinions and ask questions of the issue author, but depending upon the answers to the questions above, it may be out of scope for our project.

If the request is within scope, prioritize it on the product roadmap with the other maintainers. Apply the appropriate tags and ensure the right people have weighed in to define the feature's scope and implementation. If you want to be the _best ever_, submit a PR yourself which adds the feature.

## Bug?

### Reproducibility

If the bug has clear reproduction steps, take a minute to try them. If it helps, write a test in our test suite for the scenario which replicates the problem. Can you reliably replicate the issue?

If you can't replicate the issue, post your replication steps which didn't work and ask for clarification from the issue author.

### Supported Platform

Is the author using a supported platform? We support the latest versions of macOS, Ubuntu, Debian, CentOS, Fedora, and Arch Linux.

You may close the issue immediately if the author cannot reproduce the issue on a supported platform. For Windows-related problems, leave a comment letting the user know that Windows is not officially supported, but that they may absolutely continue using the issue to communicate with folks from `@jekyll/windows` to further investigate. Additionally, you can point them to Jekyll Talk (https://talk.jekyllrb.com) as a means of getting support from the community.

If the user is experiencing issues with GitHub Pages or another hosted platform that we cannot reproduce, please direct them to the platform's support channel and close the issue.

### What they wanted vs. what they got

An issue without a clear explanation of what the user got and what they were expecting to get is not an issue we can accurately respond to. If the user doesn't provide this information, please ask for clarification and apply the `pending-feedback` label. This information helps us build test cases such that we do not break the behaviour again in the future. The `pending-feedback` label will be removed automatically once the issue author posts a reply.

Is what they wanted to get something we want to happen? Sometimes a bug report is actually masquerading as a feature request. See the guidance above for handling feature requests.

### Staleness and automatic closure

@jekyllbot will automatically mark issues as `stale` if no activity occurs for at least one month. @jekyllbot leaves a comment asking for information about reproducibility in current versions. If no one responds after another month, the issue is automatically closed. This behavior can be suppressed by setting the [`pinned` label](/docs/maintaining/special-labels/#pinned).
