---
title: Releasing off older stable branches
---

Apart from having releases cut from the default `master` branch, Jekyll Core may occasionally cut releases containing security patches and
critical bug-fixes for older versions under maintenance. Such releases are cut from specially named branches, following the pattern
`[x].[y]-stable` where `[x]` denotes semver-major-version and `[y]`, the semver-minor-version. For example, the branch `3.9-stable` refers to
commits released as part of `jekyll-3.9.x` series.

Co-ordinating a release off a `*-stable` branch is complicated mainly because the default branch has to inevitably reflect the release as well.

## Requirements

- The maintainer has to have **write-access** to both the concerned `*-stable` and `master` branches.
- The maintainer needs to complete the task using their **local CLI program** instead of dispatching via GitHub Web UI.
- The maintainer is abreast with the workflow to [release off `master`]({{ 'docs/maintaining/releasing-a-new-version/' | relative_url }}). The
  procedure documented in the following section is an abridged adaptation of the workflow for `master`.
- A release post has been drafted and **is awaiting publish to `master`** via an approved pull request.
- Stable internet connection.

## Trigger release workflow

1. Ensure that you've **checked out the concerned `*-stable` branch** and is up-to-date with its counterpart at `jekyll/jekyll` at GitHub.
2. Bump the `VERSION` string in `lib/jekyll/version.rb`.
3. Update the **History document** as documented [here]({{ 'docs/maintaining/releasing-a-new-version/#update-the-history-document' | relative_url }}).<br/>
   (**IMPORTANT: Do not run `rake site:generate` on the stable branch though**).
4. Copy the entire History section pertaining to current release and paste into a new tab / window of your text-editor. We will use this
   temporary snippet at a future stage.
5. Commit changes to the version-file and History document with commit message `Release :gem: v[CURRENT_VERSION]`.
6. Push commit to upstream remote `jekyll/jekyll` at GitHub.

## Publish release post

1. Ensure the `Release Gem` workflow has completed successfully.
2. Merge release-post pull request to `master`.

## Update default branch to reflect release off the stable branch

1. Locally, check out `master` and ensure it is up-to-date with its remote counterpart at `jekyll/jekyll` at GitHub.
2. Update History document using the snippet in the temporary tab / window created earlier. The various sections in the History document are
   primarily in reverse chronological order and secondarily scoped to the semver-major-version. For example, a release section for `v3.9.2`
   will be listed above the section for `v3.9.1` but under release sections for v4.x.
   The snippet stashed earlier has to be injected into the correct location manually.
3. Optionally, update `VERSION` string in `lib/jekyll/version.rb`. (*If existing version is lesser than latest version*).
4. Now **run `rake site:generate`** to update various meta files:
     - docs/_config.yml
     - docs/_docs/history.md
     - docs/latest_version.txt
5. Commit changes to various meta files with commit message `Release :gem: v[CURRENT_VERSION]`.
6. Push commit to upstream remote.

## Publish GitHub Release

Unlike releases cut off the `master` branch, our JekyllBot does not automatically create and publish a GitHub Release for tags created from
*non-default* branches. Therefore, the maintainer has to **manually create and publish** the concerned GitHub Release.
1. Choose the newly pushed tag.
2. Title is same as the name of the selected tag.
3. The release snippet stashed previously forms the body.
4. Delete the snippet's title (`## x.y.z / YYYY-MM-DD`) from the release body.
5. Publish.

Note: The GitHub Release may optionally be *drafted* prior to updating the default branch and then *published* immediately after pushing the
update commit to the default branch to streamline the procedure.
