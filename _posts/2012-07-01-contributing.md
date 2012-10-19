---
layout: docs
title: Contributing
prev_section: deployment-methods
next_section: troubleshooting
---

Contributions to Jekyll are always welcome, however there’s a few things that you should keep in mind to improve your chances of having your changes merged in.

## Workflow

Here’s the most typical way to get your change merged into the project:

1. Fork the project [on GitHub](https://github.com/mojombo/jekyll) and clone it down to your local machine.
2. Create a topic branch to contain your change.
3. Hack away, add tests. Not necessarily in that order.
4. Make sure all the existing tests still pass.
5. If necessary, rebase your commits into logical chunks, without errors.
6. Push the branch up to your fork on GitHub.
7. Create an issue on GitHub with a link to your branch.

<div class="note warning">
  <h5>Contributions will not be accepted without tests</h5>
  <p>If you’re creating a small fix or patch to an existing feature, just
    a simple test will do.</p>
</div>

## Tests

We’re big on tests, so please be sure to include them. Please stay in the confines of the current test suite and use [Shoulda](https://github.com/thoughtbot/shoulda) and [RR](https://github.com/btakita/rr).

### Tests for brand-new features

If it’s a brand new feature, make sure to create a new [Cucumber](https://github.com/cucumber/cucumber/) feature and reuse steps where appropriate. Also, whipping up some documentation in your fork’s `gh-pages` branch would be appreciated, so the main website can be updated as soon as your new feature is merged.

### Test dependencies

To run the test suite and build the gem you’ll need to install Jekyll’s dependencies. Jekyll uses Bundler, so a quick run of the bundle command and you’re all set!

{% highlight bash %}
$ bundle
{% endhighlight %}

Before you start, run the tests and make sure that they pass (to confirm
your environment is configured properly):

{% highlight bash %}
$ rake test
$ rake features
{% endhighlight %}

## Common Gotchas

- If you want to bump the gem version, please put that in a separate
  commit. This way, the maintainers can control when the gem gets released.
- Try to keep your patch(es) based from [the latest commit on
  mojombo/jekyll](https://github.com/mojombo/jekyll/commits/master). The easier it is to apply your work, the less work
  the maintainers have to do, which is always a good thing.
- Please don’t tag your GitHub issue with labels like “fix” or “feature”.
  The maintainers actively read the issues and will label it once they come
  across it.

<div class="note">
  <h5>Let us know what could be better!</h5>
  <p>Both using and hacking on Jekyll should be fun, simple, and easy, so if for some reason you find it’s a pain, please <a href="https://github.com/mojombo/jekyll/issues/new">create an issue</a> on GitHub describing your experience so we can make it better.</p>
</div>
