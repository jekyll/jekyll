---
title: "Releasing a new version"
---

**This guide is for maintainers.** These special people have **write access** to one or more of Jekyll's repositories and help merge the contributions of others. You may find what is written here interesting, but it’s definitely not for everyone.
{: .note .info }

The most important thing to understand before making a release is that there's no need to feel nervous. Most things are revertable, and even if you do publish an incomplete gem version, we can always skip that one. Don't hestitate to contact the other maintainers if you feel unsure or don't know what to do next.

### Bump the version

The only important place you need to manually bump the version is in `lib/jekyll/version.rb`. Adjust that, and everything else should work fine.

### Update the history document

Replace the first header of the history document with a version milestone. This looks like the following:

```diff
-## HEAD
+## 3.7.1 / 2018-01-25
```

Adjust the version number and the date. The `## HEAD` heading will be regenerated next time a pull request is merged.

Once you've done this, update the website by running the following command:

```sh
bundle exec rake site:generate
```

This updates the website's changelog, and pushes the versions in various other places.

It's recommended that you go over the `History.markdown` file manually one more time, in case there are any spelling errors or such. Feel free to fix those manually, and after you're done generating the website changelog, commit your changes.

## Write a release post

In case this isn't done already, you can generate a new release post using the included `rake` command:

```sh
bundle exec rake site:releases:new[3.8.0]
```

where `3.8.0` should be replaced with the new version. Then, write the post. Be sure to thank all of the collaborators and maintainers who have contributed since the last release. You can generate a log of their names using the following command:

```sh
git shortlog -sn master...v3.7.2
```

where, again `v3.7.2` is the last release. Be sure to open a pull request for your release post.

### Push the version

Before you do this step, make sure the following things are done:

- You have permission to push a new gem version to RubyGems
- You're logged into RubyGems on your command line
- A release post has been prepared, and is ideally already live
- All of the prior steps are done, committed, and pushed to `master`

Really the only thing left to do is to run this command:

```sh
bundle exec rake release
```

This will automatically build the new gem, make a release commit and tag and then push the new gem to RubyGems. Don't worry about creating a GitHub release, @jekyllbot should take care of that.

And then, you're done! :tada: Feel free to celebrate!

If you have access to the [@jekyllrb](https://twitter.com/jekyllrb) Twitter account, you should tweet the release post from there. If not, just ask another maintainer to do it or to give you access.

### Build the docs

We package our documentation as a :gem: Gem for offline use.

This is done with the
[**jekyll-docs**](https://github.com/jekyll/jekyll-docs#building) repository,
and more detailed instructions are provided there.

## For non-core gems

If you're not a maintainer for `jekyll/jekyll`, the procedure is much simpler in a lot of cases. Generally, the procedure still looks like this:

- Bump the gem version manually, usually in `lib/<plugin_name>/version.rb`
- Adjust the history file
- Run `bundle exec rake release` or `script/release`, depending on which of the two exists
- Rejoice

Be sure to ask your project's maintainers if you're unsure!
