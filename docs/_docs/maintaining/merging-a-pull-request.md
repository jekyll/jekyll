---
title: "Merging a Pull Request"
---

**This guide is for maintainers.** These special people have **write access** to one or more of Jekyll's repositories and help merge the contributions of others. You may find what is written here interesting, but it’s definitely not for everyone.
{: .note .info }

## Code Review

All pull requests should be subject to code review. Code review is a [foundational value](https://blog.fullstory.com/what-we-learned-from-google-code-reviews-arent-just-for-catching-bugs/) of good engineering teams. Besides providing validation of correctness, it promotes a sense of community and gives other maintainers understanding of all parts of the code base. In short, code review is crucial to a healthy open source project.

**Read our guide for [Reviewing a pull request](../reviewing-a-pull-request) before merging.** Notably, the change must have tests if for code, and at least two maintainers must give it an OK.

## Merging

We have [a helpful little bot](https://github.com/jekyllbot) which we use to merge pull requests. We don't use the GitHub.com interface for two reasons:

1. You can't modify anything on mobile (e.g. titles, labels)
2. We like to provide a consistent paper trail in the `History.markdown` file for each release

To merge a pull request, leave a comment thanking the contributor, then add the special merge request:

```text
Thank you very much for your contribution. Folks like you make this project and community strong. :heart:

@jekyllbot: merge +dev
```

The merge request is made up of three things:

1. `@jekyllbot:` – this is the prefix our bot looks for when processing commands
2. `merge` – the command
3. `+dev` – the category to which the changes belong.

The categories match the headings in the `History.markdown` file, and they are:

1. Major Enhancements (`+major`) – major updates or breaking changes to the code which necessitate a major version bump (v3 ~> v4)
2. Minor Enhancements (`+minor`) – minor updates (with the labels `feature` or `enhancement`) which necessitate a minor version bump (v3.1 ~> v3.2)
3. Bug Fixes (`+bug`) – corrections to code which do not change or add functionality, which necessitate a patch version bump (v3.1.0 ~> v3.1.1)
4. Documentation (`+doc`) - changes to the documentation found in `docs/_docs/`
5. Site Enhancements (`+site`) – changes to the source of [https://jekyllrb.com](https://jekyllrb.com) found in `docs/`
6. Development Fixes (`+dev`) – changes which do not affect user-facing functionality or documentation, such as test fixes or bumping internal dependencies
7. Forward Ports (`+port`) — bug fixes applied to a previous version of Jekyll pulled onto `master`, e.g. cherry-picked commits from `3-1-stable` to `master`

Once @jekyllbot has merged the pull request, you should see three things:

1. A successful merge
2. Addition of labels for the necessary category if they aren't already applied
3. A commit to the `History.markdown` file which adds a note about the change

If you forget the category, that's just fine. You can always go back and move the line to the proper category header later. The category is always necessary for `jekyll/jekyll`, but many plugins have too few changes to necessitate changelog categories.

## Rejoice

You did it! Thanks for being a maintainer for one of our official Jekyll projects. Your work means the world to our thousands of users who rely on Jekyll daily. :heart:
