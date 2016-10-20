# Jekyll docs site

This directory contains the code for the Jekyll docs site, [jekyllrb.com](http://jekyllrb.com/).

## Contributing

For information about contributing, see the [Contributing page](http://jekyllrb.com/docs/contributing/).

## Running locally

You can preview your contributions before opening a pull request by running from within the directory:

1. `bundle install --without test test_legacy benchmark`
2. `bundle exec rake site:preview`

If you're developing on a Windows Machine, the steps above will not regenerate the build on every change you make. You can have that enabled by opening a Jekyll server from within the `site` directory:

1. `cd site`
2. `bundle exec jekyll serve`

It's just a jekyll site, afterall! :wink:
