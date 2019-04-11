---
title: 'Jekyll 3.1.1 Released'
date: 2016-01-28 17:21:50 -0800
author: parkr
version: 3.1.1
category: release
---

This release squashes a few bugs :bug: :bug: :bug: noticed by a few
wonderful Jekyll users:

* If your `permalink` ended with a `/`, your URL didn't have any extension,
even if you wanted one
* We now strip the BOM by default per Ruby's `IO.open`.
* `page.dir` will not always end in a slash.

We also updated our [Code of Conduct](/docs/conduct/) to the latest version of
the Contributor Covenant. The update includes language to ensure that the
reporter of the incident remains confidential to non-maintainers and that
all complaints will result in an appropriate response. I care deeply about
Jekyll's community and will do everything in my power to ensure it is a
welcoming community. Feel free to reach out to me directly if you feel
there is a way we can improve the community for everyone! If you're
interested in more details, [there is a diff for
that](https://github.com/ContributorCovenant/contributor_covenant/blob/v1_4/diffs/1_3_vs_1_4.patch).

See links to the PR's on [the history page](/docs/history/#v3-1-1).

Thanks to Jordon Bedwell, chrisfinazzo, Kroum Tzanev, David Celis, and
Alfred Xing for their commits on this latest release! :sparkles:

Happy Jekylling!
