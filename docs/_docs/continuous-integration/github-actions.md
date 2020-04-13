---
title: Github Actions
---

When building a Jekyll site with Github Pages, the standard flow is restricted for security reasons
and to make it simpler to get a site setup. So, to get flexibility over the build and deploy steps,
you can use Github Actions.

This guide shows some of the benefits of using this integration and how to setup it up on your own
repo, while still hosting with Github Pages.


## Advantages of using Actions

Using Jekyll with Github Actions lets you do the following:

### Gems

- **Jekyll version** - Specify a Jekyll version in your Gemfile rather than using the standard
  `3.8.5`. You can now use Jekyll `4` - see this guide to [upgrading][0] Jekyll.
- **Plugins** - Install Jekyll plugins which are not on the [supported versions][1] list. Or use a
  different version to the standard environment.
- **Themes** - While using a custom theme is possible without Actions, it is now simpler.

[0]: {{ '/docs/upgrading/3-to-4/' | relative_url }}
[1]: https://pages.github.com/versions/

### Workflow

- **Customization** - By creating a workflow file to run actions, you're no longer limited to the
  steps, environment variables or output destination of the standard Github Pages build.
- **Logging** - The build log is verbose, so it is much easier to debug errors than with the
  standard Github Pages flow.


## How to setup Jekyll with Actions

This guide covers how to setup a workflow file with a suitable action, then set a custom Jekyll
version and unsupported plugin so we can see that the action works.

Follow these steps to use Actions on your project.

### 1. Setup branches

Choose an existing Jekyll project or follow the [Quickstart][2] guide. Make sure the repo is on
Github.

[2]: {{ '/docs' | relative_url }}

Ensure that you are working on the `master` branch. If necessary, create it based on your default
branch. The action we use here only builds from the `master` branch.

Then optionally **delete** your `gh-pages` branch, as it is going to be recreated from scratch -
when the Action builds you site, the result will be automatically added with a commit to the
`gh-pages` branch and then used for serving.

Do **not** make any manual commits to `gh-pages` from now on as they will be lost.


### 2. Setup workflow

Now we add a Github workflow file to your project - this will ensure Actions is trigger and runs so
we can build and deploy. Though there are many similar Jekyll-related actions to choose from, we
chose [Jekyll Actions][3] from the marketplace for this tutorial. It simple to setup but gives
enough flexibility.

[3]: https://github.com/marketplace/actions/jekyll-actions

Create a **workflow file** using one of the following approaches:

- Actions tab
  - Go to the Actions tab on your Github repo and create a new file named `jekyll.yml` for example.
- Add file to repo
  - Create the the file directly in the repo at the path `.github/worksflows/jekyll.yml`. Note the
    dot at the start. This can be done locally too.

**Copy** the following to your workflow file, then save it.

{% highlight liquid %}
{% raw %}
name: Build and deploy Jekyll to Github Pages

on:
  push:
    branches:
      - master

jobs:
  jekyll:
    runs-on: ubuntu-16.04
    steps:
      - uses: actions/checkout@v2
      - uses: helaili/jekyll-action@2.0.0
        env:
          JEKYLL_PAT: ${{ secrets.JEKYLL_PAT }}
{% endraw %}
{% endhighlight %}

To explain that workflow file:

- We set the build to happen on **push** to `master` only - this prevents feature branch builds from
  overwriting the `gh-pages` branch.
- The **checkout** action takes care of cloning your repo.
- We specify the **action** and the version number using `helaili/jekyll-action@2.0.0`. This handles
  the build and deploy.
- We also set a reference to a secret **environment variable** for the action to use. We set this up
  in the section below.


### 3. Set a secret

The action needs permissions to push to your `gh-pages` branch. So we must create a Github
**authentication token** on your Github profile, then set it as an environment variable in your
build using _Secrets_.

1. On your Github profile, go to the [Tokens][4] page and then the _Personal Access Tokens_ (PAT)
   section.
2. Create a token.
    - Give it a name like _Github Actions_.
    - Ensure it has permissions to `public_repos` (necessary for pushing to `gh-pages` branch).
3. Copy the token value.
4. Go back back to your repo on Github. Go to the repo's _Settings_ then the _Secrets_ tab.
5. Create a token named `JEKYLL_PAT`. Set the value using the one copied above.

[4]: https://github.com/settings/tokens


### 4. Set Jekyll version

Jekyll version `4.0.0` has been selected for this tutorial. So dd this to your `Gemfile`:

```ruby
gem 'jekyll', '~> 4.0.0'
```


### 5. Add custom plugin

The [Timeago][5] plugin have been selected for this tutorial, as it is unsupported by the standard
Github Pages build. The point of the plugin is to turn a date (e.g. `2016-03-23T10:20:00Z`) into a
description of how long ago it was (e.g. _4 years and 3 weeks ago_).


1. Add the gem to your `Gemfile`:
    ```ruby
    group :jekyll_plugins do
      gem 'jekyll-timeago', '~> 0.13.1'
    end
    ```
2. Add the plugin to your `_config.yml` file:
    ```yaml
    plugins:
        - jekyll-timeago
    ```

On one of your markdown pages, use the [Timeago][5] plugin.

For example:

{% highlight liquid %}
{% raw %}
{% assign date = '2020-04-13T10:20:00Z' %}

- Original date - {{ date }}
- With timeago filter - {{ date | timeago }}
{% endraw %}
{% endhighlight %}

[5]: https://rubygems.org/gems/jekyll-timeago


### Install gems

It is recommended to use _Bundler_ to manage your project gems. Use that to install in gems we set
above.

```sh
bundle install --path vendor/bundle
```

If you get an **error** when building that sets _Bundler_ is not available, delete your `Gemfile.lock`
from version control and add that file to `.gitignore`.


### 6. Build and deploy

Save and push any local changes on `master`. The action will be triggered.

To watch the progress and see any build errors, check on the build status using one of the following
approaches:

- Go to your repo's level root in Github. Under the most recent commit (near the top) you’ll see a
  status symbol next to the commit message. Click the tick or _X_, then click _details_.
- Go to the repo's _Actions_ tab and click on a workflow run.

If all goes well, you'll see all steps are green, no serious errors in the log and the built assets
will exist on the `gh-pages` branch.


### 7. View site

On a successful build, _Github Pages_ will publish the site stored on the repo's `gh-pages`
branches. You do not need to setup a `gh-pages` branch or enable _Github Pages_ - the action will
take care of this for you.

To see the live site:

1. Go to the environment tab of your repo.
2. Click _View Deployment_ to see the deployed site URL. Optionally add this URL to your repo's main
   page and to your _README.md_ to make it easy for people to find and visit.
4. View your site. Make sure the `timeago` filter worked as expected.

When you need to make further changes to the site, make changes to `master` and push them. The
action will build and deploy your site. Be sure to not edit the `gh-pages` branch directly.


## Next steps

- Start to use Jekyll 4 features - also have a look at the differences in case some things such as URLs start to break.
- Choose another custom plugin you want to use and set it up.
- Look at other actions available in the Marketplace.


## External links

- [Actions][6] page on Github features.
- [Actions][7] page under Github help.
- [jekyll-actions][3] is an action available on the Github Marketplace and also used in this guide.
- [jekyll-actions-quickstart][8] is an unofficial repo that includes a live demo and can be used as
  a template for making a new site.

[6]: https://github.com/features/actions
[7]: https://help.github.com/en/actions
[8]: https://github.com/MichaelCurrin/jekyll-actions-quickstart
