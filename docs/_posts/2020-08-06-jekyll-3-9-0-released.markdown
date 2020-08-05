---
title: 'Jekyll 3.9.0 Released'
author: parkr
version: 3.9.0
categories: [release]
---

Jekyll 3.9.0 allows use of kramdown v2, the latest series of kramdown. If you choose to upgrade, please note that the GitHub-Flavored Markdown parser and
the following features from kramdown v1 are now distributed via separate gems. So they will need to be added to your `Gemfile` separately to use the feature:

- GFM parser – `kramdown-parser-gfm`
- coderay syntax highlighter – `kramdown-syntax-coderay`
- mathjaxnode math engine – `kramdown-math-mathjaxnode`
- sskatex math engine – `kramdown-math-sskatex`
- katex math engine – `kramdown-math-katex`
- ritex math engine – `kramdown-math-ritex`
- itex2mml math engine – `kramdown-math-itex2mml`

Jekyll will require the given gem when the configuration requires it, and will show a helpful message when a dependency is missing.

You can check out the patches and see all the details in [the release notes](/docs/history/#v3-9-0)

Happy Jekylling!
