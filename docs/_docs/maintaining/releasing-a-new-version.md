---
title: "Releasing a new version"
---

**This guide is for maintainers.** These special people have **write access** to one or more of Jekyll's repositories and help merge the
contributions of others. You may find what is written here interesting, but it's definitely not for everyone.
{: .note .info}

The most important thing to understand before making a release is that there's no need to feel nervous. Most things are revertable, and even if
you do publish an incomplete gem version, we can always skip that one. Don't hesitate to contact the other maintainers if you feel unsure or
don't know what to do next.

### Bump the version

The only important place you need to manually bump the version is in `lib/jekyll/version.rb`. Adjust that, and everything else should work fine.

The version will mostly be of the format `"major.minor.patch"`. At times, we may decide to ship pre-releases which will be in the format
`"major.minor.patch.suffix"`. `suffix` is not standardized and may be anything like `pre.alpha1`, `pre.rc2`, or simply `beta3`, etc.

To determine the correct version, consult the `## HEAD` section of our history document, `History.markdown`, first.

- If there's a subsection titled `Major Enhancements`
  - Increment the `major` component of the version string and reset both `minor` and `patch` components to `0`.
  - Add `suffix` if applicable.
  - For example, `"3.9.1" => "4.0.0"` or, `"3.9.1 => "4.0.0.alpha1"`.
  - Skip to next step in the release process.

- If there's a subsection titled `Minor Enhancements`
  - Increment just the `minor` component and reset the patch component to `0`.
  - Add `suffix` if applicable.
  - For example, `"4.0.2" => "4.1.0"` or `"4.1.0" => "4.2.0.pre"`.
  - Skip to next step in the release process.

- For anything else, increment just the `patch` component or `suffix` component as applicable. For example, `"4.0.2" => "4.0.3"` or
  `"4.1.0.beta3" => "4.1.0.rc"`.

### Write a release post

In case this wasn't done already, you can generate a new release post scaffold using the included `rake` command:

```sh
bundle exec rake site:releases:new[3.8.0]
```

where `3.8.0` should be replaced with the new version.

Then, write the post. Be sure to thank all of the collaborators and maintainers who have contributed since the last release. You can generate
a log of their names using the following command:

```sh
git shortlog -sn master...v3.7.2
```

where `v3.7.2` is the git tag for the previous release. In case the tag doesn't exist in your repository, run:

```sh
git pull
```

Be sure to open a pull request for your release post once its finished.

### Update the History document

Replace the first header of `History.markdown` with a version milestone. This looks like the following:

```diff
- ## HEAD
+ ## 3.7.1 / 2018-01-25
```

Adjust the version number and the date. The `## HEAD` heading will be regenerated the next time a pull request is merged.

Rearrange the subsections (as a whole) based on decreasing priorities as illustrated below:

```
## 4.2.0 / 2020-12-14

### Major Enhancements

...

### Minor Enhancements

...

### Bug Fixes

...

### Security Fixes

...

### Optimization Fixes

...

### Development Fixes

...

### Site Enhancements

...
```

Once you've done this, update the website by running the following command:

```sh
bundle exec rake site:generate
```

This updates the website's changelog, and pushes the versions in various other places.

It's recommended that you go over the `History.markdown` file manually one more time, in case there are any spelling errors or such. Feel free
to fix those manually, and after you're done generating the website changelog, commit your changes.

### Push the version

Before you do this step, make sure the following things are done:

- A release post has been prepared, and is ideally already live via a prior pull request.
- All of the prior steps are done, especially the change to `lib/jekyll/version.rb` has been staged for commit.
- Commit staged changes to the local `master` branch preferably with commit message `"Release :gem: v[CURRENT_VERSION]"`.

The only thing left to do now is to run this command:

```sh
git push upstream master
```

where `upstream` references `git@github.com:jekyll/jekyll.git`.

This will trigger a GitHub Actions workflow that will automatically build the new gem, tag the release commit, push the tag to GitHub and
then finally, push the new gem to RubyGems. Don't worry about creating a GitHub release either, @jekyllbot will take care of that when the
release workflow publishes the new tag.

And then, if the workflow has completed successfully, you're done! :tada:
Feel free to celebrate!

If you have access to the [@jekyllrb](https://twitter.com/jekyllrb) Twitter account, you should tweet the release post from there. If not, just
ask another maintainer to do it or to give you access.

### Build the docs

We package our documentation as a :gem: Gem for offline use.

This is done with the [**jekyll-docs**](https://github.com/jekyll/jekyll-docs#building) repository, and more detailed instructions are
provided there.

## For non-core gems

If you're not a maintainer for `jekyll/jekyll`, the procedure is much simpler in a lot of cases. Generally, the procedure still looks like
this:

- Bump the gem version manually, usually in `lib/<plugin_name>/version.rb`
- Adjust the history file
- Commit changes to default branch preferably with message `"Release :gem: v[CURRENT_VERSION]"`
- Push to remote repository
- Rejoice

Be sure to ask your project's maintainers if you're unsure!
