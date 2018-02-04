---
title: "Releasing a new version"
---

**This guide is for maintainers.** These special people have **write access** to one or more of Jekyll's repositories and help merge the contributions of others. You may find what is written here interesting, but it’s definitely not for everyone.
{: .note .info }

The most important thing to understand before making a release is that there's no need to feel nervous. Most things are revertable, and even if you do publish an incomplete gem version, we can always skip that one. Don't hestitate to contact the other maintainers if you feel unsure or don't know what to do next.

### Bump the version

There's three main places where you have to update the version number manually:

- In `lib/jekyll/version.rb`. This is the important one!
- In `docs/latest_version.txt`. This is necessary for the site to update correctly.
- In `docs/_config.yml` (the first element).

Everything else should orient itself around these. Feel free to commit and push to `master` now.

### Update the history document

Replace the first header of the history document with a version milestone. This looks like the following:

```diff
-## HEAD
+## 3.7.1 / 2018-01-25
```

Adjust the version number and the date. Don't worry about removing the `HEAD` part, it'll automatically be regenerated when the time comes.

Once you've done this, update the website's changelog by running the following command:

```sh
bundle exec rake site:history
```

It's recommended that you go over the `History.markdown` manually one more time, in case there are any spelling errors or such. Feel free to fix those manually, and after you're done generating the website changelog, commit your changes.

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

## For non-core gems

If you're not a maintainer for `jekyll/jekyll`, the procedure is much simpler in a lot of cases. Generally, the procedure still looks like this:

- Bump the gem version manually
- Adjust the history file
- Create a release tag and/or commit
- Build the gem
- Push the gem
- Rejoice

Be sure to ask your project's maintainers if you're unsure!
