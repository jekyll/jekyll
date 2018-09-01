---
title: Philosophy
permalink: /philosophy/
---

Jekyll offers a unique philosophy when approaching the problem of static
site generation. This core philosophy drives development and product
decisions. When a contributor, maintainer, or user asks herself what Jekyll
is about, the following principles should come to mind:

### 1. No Magic

Jekyll is not magic. A user should be able to understand the underlying
processes that make up the Jekyll build without much reading. It should
do only what you ask it to and nothing more. When a user takes a certain
action, the outcome should be easily understandable and focused.

### 2. It "Just Works"

The out-of-the-box experience should be that it "just works." Run
`gem install jekyll` and it should build any Jekyll site that it's given.
Features like auto-regeneration and settings like the markdown renderer
should represent sane defaults that work perfectly for the vast majority of
cases. The burden of initial configuration should not be placed on the user.

### 3. Content is King

Why is Jekyll so loved by content creators? It focuses on content first and
foremost, making the process of publishing content on the Web easy. Users
should find the management of their content enjoyable and simple.

### 4. Stability

If a user's site builds today, it should build tomorrow.
Backwards-compatibility should be strongly preferred over breaking changes.
Breaking changes should be made to support a strong practical goal, and
breaking changes should never be made to drive forward "purity" of the
codebase, or other changes purely to make the maintainers' lives easier.
Breaking changes provide a significant amount of friction between upgrades
and reduce the confidence of users in this software, and should thus be
avoided unless absolutely necessary.
Upon breaking changes, provide a clear path for users to upgrade.

### 5. Small & Extensible

The core of Jekyll should be simple and small, and extensibility should be
a first-class feature to provide added functionality from community
contributors. The core should be kept to features used by at least 90% of
users–everything else should be provided as a plugin. New features should
be shipped as plugins and focus should be put on creating extensible core
API's to support rich plugins.
