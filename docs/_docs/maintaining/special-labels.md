---
title: "Special Labels"
---

**This guide is for maintainers.** These special people have **write access** to one or more of Jekyll's repositories and help merge the contributions of others. You may find what is written here interesting, but it’s definitely not for everyone.
{: .note .info }

We use a series of "special labels" on GitHub.com to automate handling of some parts of the pull request and issue process. @jekyllbot may automatically apply or remove certain labels based on actions taken by users or maintainers. Below are the labels and how they work:

## `pending-feedback`

This label is used to indicate that we need more information from the issue/PR author in order to continue. It may be that you need more info before you can properly triage a bug report, or that you have some unanswered questions about a PR that need to be resolved before moving forward. You can safely ignore any issue with this label, as it is waiting for feedback.

## `needs-work` & `pending-rebase`

These labels are used to indicate that the Git state of a pull request must change. Both are removed once a push is registered (a "synchronize" event for the pull request) and the pull request becomes mergable. Add `needs-work` to a PR if, after your review, it requires code changes. Add `pending-rebase` to a PR if the code is fine but the branch is not automatically mergable with the target branch (e.g. `master`).

## `stale`

This label is automatically added and removed by @jekyllbot based on activity on an issue or pull request. The rules for this label are laid out in [Triaging an Issue: Staleness and automatic closure](../triaging-an-issue/#staleness-and-automatic-closure).

## `pinned`

This label is for @jekyllbot to ignore the age of the issue, which means that the `stale` label won't be automatically added, and the issue won't be closed after a while. This needs to be set manually, and should be set with care. (The `has-pull-request` label does the same thing, but shouldn't be used to _only_ keep an issue open)
