Contribute
==========

So you've got an awesome idea to throw into Jekyll. Great! Please keep the
following in mind:

* **Contributions will not be accepted without tests.**
* If you're creating a small fix or patch to an existing feature, just a simple
  test will do. Please stay in the confines of the current test suite and use
  [Shoulda](http://github.com/thoughtbot/shoulda/tree/master) and
  [RR](http://github.com/btakita/rr/tree/master).
* If it's a brand new feature, make sure to create a new
  [Cucumber](https://github.com/cucumber/cucumber/) feature and reuse steps
  where appropriate. Also, whipping up some documentation in your fork's wiki
  would be appreciated, and once merged it will be transferred over to the main
  wiki.
* If your contribution changes any Jekyll behavior, make sure to update the
  documentation. It lives in site/_posts. If the docs are missing information,
  please feel free to add it in. Great docs make a great project!

Test Dependencies
-----------------

To run the test suite and build the gem you'll need to install Jekyll's
dependencies. Jekyll uses Bundler, so a quick run of the bundle command and
you're all set!

    $ bundle

Before you start, run the tests and make sure that they pass (to confirm your
environment is configured properly):

    $ rake test
    $ rake features

Workflow
--------

Here's the most direct way to get your work merged into the project:

* Fork the project.
* Clone down your fork ( `git clone git://github.com/<username>/jekyll.git` ).
* Create a topic branch to contain your change ( `git checkout -b my_awesome_feature` ).
* Hack away, add tests. Not necessarily in that order.
* Make sure everything still passes by running `rake`.
* If necessary, rebase your commits into logical chunks, without errors.
* Push the branch up ( `git push origin my_awesome_feature` ).
* Create a pull request against mojombo/jekyll and describe what your change
  does and the why you think it should be merged.

Gotchas
-------

* If you want to bump the gem version, please put that in a separate commit.
  This way, the maintainers can control when the gem gets released.
* Try to keep your patch(es) based from the latest commit on mojombo/jekyll.
  The easier it is to apply your work, the less work the maintainers have to do,
  which is always a good thing.
* Please don't tag your GitHub issue with [fix], [feature], etc. The maintainers
  actively read the issues and will label it once they come across it.

Finally...
----------

Thanks! Hacking on Jekyll should be fun. If you find any of this hard to figure
out, let us know so we can improve our process or documentation!
