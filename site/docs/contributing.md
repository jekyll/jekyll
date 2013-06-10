---
layout: docs
title: Contributing
prev_section: upgrading
next_section: history
permalink: /docs/contributing/
---

So you've got an awesome idea to throw into Jekyll. Great! Please keep the
following in mind:

* If you're creating a small fix or patch to an existing feature, just a simple
  test will do. Please stay in the confines of the current test suite and use
  [Shoulda](http://github.com/thoughtbot/shoulda/tree/master) and
  [RR](http://github.com/btakita/rr/tree/master).
* If it's a brand new feature, make sure to create a new
  [Cucumber](https://github.com/cucumber/cucumber/) feature and reuse steps
  where appropriate. Also, whipping up some documentation in your fork's `site`
  directory would be appreciated, and once merged it will also appear in
  the next update of the main site.
* If your contribution adds or changes any Jekyll behavior, make sure to update
  the documentation. It lives in `site/docs`. If the docs are missing
  information, please feel free to add it in. Great docs make a great project!
* Please follow the [GitHub Ruby Styleguide](https://github.com/styleguide/ruby)
  when modifying Ruby code.

<div class="note warning">
  <h5>Contributions will not be accepted without tests</h5>
  <p>
    If you’re creating a small fix or patch to an existing feature, just
    a simple test will do.
  </p>
</div>

Test Dependencies
-----------------

To run the test suite and build the gem you'll need to install Jekyll's
dependencies. Jekyll uses Bundler, so a quick run of the `bundle` command and
you're all set!

{% highlight bash %}
$ bundle
{% endhighlight %}

Before you start, run the tests and make sure that they pass (to confirm your
environment is configured properly):

{% highlight bash %}
$ rake test
$ rake features
{% endhighlight %}

Workflow
--------

Here's the most direct way to get your work merged into the project:

* Fork the project.
* Clone down your fork:

{% highlight bash %}
git clone git://github.com/<username>/jekyll.git
{% endhighlight %}

* Create a topic branch to contain your change:

{% highlight bash %}
git checkout -b my_awesome_feature
{% endhighlight %}


* Hack away, add tests. Not necessarily in that order.
* Make sure everything still passes by running `rake`.
* If necessary, rebase your commits into logical chunks, without errors.
* Push the branch up:

{% highlight bash %}
git push origin my_awesome_feature
{% endhighlight %}

* Create a pull request against mojombo/jekyll and describe what your change
  does and the why you think it should be merged.

Updating Documentation
----------------------

We want the Jekyll documentation to be the best it can be and we
welcome pull request when you find it lacking.

You can find the documentation for jekyllrb.com in the
[site](https://github.com/mojombo/jekyll/tree/master/site)
directory, it is setup to use Jekyll pages.

All documentation pull requests should be directed at `master`.  Pull
requests directed at another branch will not be accepted.

The [Jekyll wiki](https://github.com/mojombo/jekyll/wiki) on GitHub can be freely updated without a pull request as all GitHub users have access.

Gotchas
-------

* If you want to bump the gem version, please put that in a separate commit.
  This way, the maintainers can control when the gem gets released.
* Try to keep your patch(es) based from the latest commit on mojombo/jekyll.
  The easier it is to apply your work, the less work the maintainers have to do,
  which is always a good thing.
* Please don't tag your GitHub issue with \[fix\], \[feature\], etc. The maintainers
  actively read the issues and will label it once they come across it.

<div class="note">
  <h5>Let us know what could be better!</h5>
  <p>
    Both using and hacking on Jekyll should be fun, simple, and easy, so if for
    some reason you find it’s a pain, please <a
    href="https://github.com/mojombo/jekyll/issues/new">create an issue</a> on
    GitHub describing your experience so we can make it better.
  </p>
</div>
