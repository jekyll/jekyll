---
title: "CircleCI"
---

Building, testing, and deploying your Jekyll-generated website can quickly be done with [CircleCI][0], a continuous integration & delivery tool. CircleCI supports [GitHub][1] and [Bitbucket][2], and you can get started for free using an open-source or private repository.

[0]: https://circleci.com/
[1]: https://github.com/
[2]: https://bitbucket.org/

## 1. Follow Your Project on CircleCI

To start building your project on CircleCI, all you need to do is 'follow' your project from CircleCI's website:

1. Visit the 'Add Projects' page: <https://circleci.com/add-projects>
1. From the GitHub or Bitbucket tab on the left, choose a user or organization.
1. Find your project in the list and click 'Build project' on the right.
1. The first build will start on its own. You can start telling CircleCI how to build your project by creating a [circle.yml][3] file in the root of your repository.

[3]: https://circleci.com/docs/configuration/

## 2. Dependencies

The easiest way to manage dependencies for a Jekyll project (with or without CircleCI) is via a [Gemfile][4]. You'd want to have Jekyll, any Jekyll plugins, [HTML Proofer](#html-proofer), and any other gems that you are using in the `Gemfile`. Don't forget to version `Gemfile.lock` as well. Here's an example `Gemfile`:

[4]: http://bundler.io/gemfile.html

```ruby
source 'https://rubygems.org'

ruby '2.4.0'

gem 'jekyll'
gem 'html-proofer'
```

CircleCI detects when `Gemfile` is present is will automatically run `bundle install` for you in the `dependencies` phase.

## 3. Testing

The most basic test that can be run is simply seeing if `jekyll build` actually works. This is a blocker, a dependency if you will,  for other tests you might run on the generate site. So we'll run Jekyll, via Bundler, in the `dependencies` phase.

```yaml
dependencies:
  post:
    - bundle exec jekyll build
```

### HTML Proofer

With your site built, it's useful to run tests to check for valid HTML, broken links, etc. There's a few tools out there but [HTML Proofer][5] is popular amongst Jekyll users. We'll run it in the `test` phase with a few preferred flags. Check out the `html-proofer` [README][6] for all available flags, or run `htmlproofer --help` locally.

[5]: https://github.com/gjtorikian/html-proofer
[6]: https://github.com/gjtorikian/html-proofer/blob/master/README.md#configuration

```yaml
test:
  post:
    - bundle exec htmlproofer ./_site --check-html --disable-external
```

## Complete Example circle.yml File

When you put it all together, here's an example of what that `circle.yml` file could look like:

```yaml
machine:
  environment:
    NOKOGIRI_USE_SYSTEM_LIBRARIES: true # speeds up installation of html-proofer

dependencies:
  post:
    - bundle exec jekyll build

test:
  post:
    - bundle exec htmlproofer ./_site --allow-hash-href --check-favicon --check-html --disable-external

deployment:
  prod:
    branch: master
    commands:
      - rsync -va --delete ./_site username@my-website:/var/html
```

## Questions?

This entire guide is open-source. Go ahead and [edit it][7] if you have a fix or [ask for help][8] if you run into trouble and need some help. CircleCI also has an [online community][9] for help.

[7]: https://github.com/jekyll/jekyll/edit/master/docs/_docs/continuous-integration/circleci.md
[8]: https://jekyllrb.com/help/
[9]: https://discuss.circleci.com
