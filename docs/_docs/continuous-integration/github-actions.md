---
title: Github Actions
author: MichaelCurrin
---

When building a Jekyll site with Github Pages, the default flow can work fine. But sometimes you need more control over the build and deploy steps. This can be done using Github Actions.

Follow this guide to update an existing Jekyll project to work with Github Actions. We're going to add a chosen Github Action to workflow file and give it the action permissions it needs. Then we add Jekyll version 4 to the project, as well as plugin that is normally _unsupported_ by the standard Github Pages build. The result is a site served through Github Pages, but in a different way.


## Advantages of using Actions

### Gems

- **Jekyll version** - Specify a Jekyll version in your Gemfile rather than using the standard `3.8.5`. You can now use Jekyll `4` - see this guide to [upgrading][0].
- **Plugins** - Install Jekyll plugins which are not on the [supported versions][1] list. Or use a different version to the standard environment.
- **Themes** - Using a custom theme is possible without Actions, but now its simpler.

[0]: {{ '/docs/upgrading/3-to-4/' | relative_url }}
[1]: https://pages.github.com/versions/

### Workflow

- **Customization** - You're no longer limited to the steps, environment variables or output destination of the standard Github Pages build.
- **Logging** - The build log is verbose, so it is much easier to debug errors than with the standard Github Pages flow which can sometimes give one-line vague errors.


## How to setup Jekyll with Actions

Follow these steps to set a Jekyll site with Jekyll Actions.

### 1. Setup branches

Choose a Jekyll project you have on Github.

Make sure you are working on the `master` branch. This is necessary for the selected Action to work.

You can optionally delete your `gh-pages` branches, as it is going to be created from scratch.
Your built site will be committed automatically to the `gh-pages` branch, which is used for serving. So do not make any manual commits to `gh-pages` from now on.


### 2. Setup workflow

Now we add a Github workflow config file to your project - this will ensure Actions runs and we can build and deploy.  Though there are many similar actions out there. For this tutorial, we use [Jekyll Actions][2] from the marketplace.

2: https://github.com/marketplace/actions/jekyll-actions

Create a workflow file using one of the following approaches. The name can be anything.

- Actions tab
  - Go to the Actions tab on your Github repo and create a new file named `jekyll.yml`.
- Add file to repo
  - Create the the file directly in the repo as `.github/worksflows/jekyll.yml`. Note the dot at the start. This can be done locally.

Add the following content to the file. This can be copy and pasted as is.

```yaml
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
```

**Notes**

- The build happens on push to master only - this prevents feature branch builds overwriting `gh-pages` branch.
- We specify the Jekyll Actions version 2 in steps.
- We also set a reference to an environment variable which is covered next.


### 3. Set a secret

The action needs permissions to push to your `gh-pages` branch. So we must create a token for your profile and set it as an environment variable in your build using _Secrets_.

1. On your Github profile, go to the [Tokens][3] page and then _Personal Access Tokens_ (PAT).
2. Create a token.
    - Name it something like _Github Actions_.
    - Ensure it has permissions to the following:
        - *repo:status*
        - *repo_deployment*
        - *public_repos* (necessary for pushing to `gh-pages` branch)
        - *workflow*
3. Copy the token value.
4. Come back to your repo and go to _Settings_ then the _Secrets_ tab.
5. Create a token named `JEKYLL_PAT`. Set the value using the one copied above.

3: https://github.com/settings/tokens


### 4. Set Jekyll version

Jekyll version `4.0.0` has been selected for this tutorial.

Add this to your `Gemfile:

```ruby
gem 'jekyll', '~> 4.0.0'
```


### 5. Add custom plugin

The [Timeago][4] plugin have been selected for this tutorial, as it is unsupported by the standard Github Pages build.

The point of the plugin is to turn a date (e.g. `2016-03-23T10:20:00Z`) to a description of how long ago it was (e.g. _4 years and 3 weeks ago_).


1. Add the gem your `Gemfile`:
    ```ruby
    group :jekyll_plugins do
      gem 'jekyll-timeago', '~> 0.13.1'
    end
    ```
2. Add the plugin to your `_config.yml` file:
    ```ruby
    plugins:
    - jekyll-timeago
    ```

On one of your markdown pages, use the [Timeago][4] plugin. For example:

{% highlight liquid %}
{% raw %}
{% assign date = '2020-04-13T10:20:00Z' %}

- Original date - {{ date }}
- With timeago filter - {{ date | timeago }}
{% endraw %}
{% endhighlight %}

[4]: https://rubygems.org/gems/jekyll-timeago


### 6. Build and deploy

Save and push any local changes on `master`. The action will be triggered.

To watch the progress and see any build errors, check on the build status using one of the following approaches:

- Go to your repo's level root in Github. Under the most recent commit (near the top) you’ll see a status symbol next to the commit message.
- Go to the repo's _Actions_ tab.

If all goes well, you'll see all steps are green, there are no serious errors in the log and the built assets will exist on the `gh-pages` branch.

Continue to the last step.


### 7. View site

On a successful build, _Github Pages_ will publish the site from the repo's `gh-pages` branches. You do not need to setup a `gh-pages` branch or enable _Github Pages_ - the action will take care of this for you.

1. Go to the environment tab of your repo.
2. Click _View Deployment_ to see the deployed site.
    - e.g. [michaelcurrin.github.io/jekyll-actions/](https://michaelcurrin.github.io/jekyll-actions/)
    - Optionally add this URL to your repo's main page and to your _README.md_ to make it easy for people to find and visit.

Check on your page to make sure the `timeago` filter worked as expected.

If you do need to make further changes to the site, just make changes to master and the action will build and deploy your site. Be sure to not edit the `gh-pages` branch directly.
