---
title: GitHub Actions
---

When building a Jekyll site with GitHub Pages, the standard flow is restricted for security reasons
and to make it simpler to get a site setup. So to get flexibility over the build and deploy steps
you can use GitHub Actions.

This guide shows some of the benefits of using this integration and how to setup it up on your own
GitHub repo, while still hosting with GitHub Pages.


## Advantages of using Actions

### Gems

- **Jekyll version** - Rather than using the standard version `3.8.5`, you can specify any version
  such as Jekyll `4.0.0`. See this guide to [upgrading][0] Jekyll for understanding the differences
  and how they impact you.
- **Plugins** - You can install Jekyll plugins which are not on the [supported versions][1] list. Or
  use a different version to the standard environment.
- **Themes** - While using a custom theme is possible without Actions, it is now simpler.

[0]: {{ '/docs/upgrading/3-to-4/' | relative_url }}
[1]: https://pages.github.com/versions/

### Workflow

- **Customization** - By creating a workflow file to run Actions, you can now specify custom build
  steps, use environment variables and set an output destination (such as another branch or repo).
- **Logging** - The build log is verbose, so it is much easier to debug errors using Actions.


## How to setup Jekyll with Actions

This guide covers how to setup a workflow file with a suitable action and then set a custom Jekyll
version and unsupported plugin so we can see that the action works.

Follow these steps to use Actions on your project.

### 1. Setup branches

Choose an existing Jekyll project or follow the [Quickstart][2] guide. Make sure the repo is on
GitHub.

[2]: {{ '/docs' | relative_url }}

Ensure that you are working on the `master` branch. If necessary, create it based on your default
branch. The Action we use here only builds from the `master` branch.

Then optionally **delete** your `gh-pages` branch, as it is going to be recreated from scratch -
when the action builds you site, the result will be automatically added with a commit to the
`gh-pages` branch and then used for serving.


### 2. Setup workflow

Now add a GitHub workflow file - this will ensure Actions is triggered. There are many similar
Jekyll-related actions to choose from, we chose [Jekyll Actions][3] from the Marketplace here as it
is simple to setup and gives flexibility.

[3]: https://github.com/marketplace/actions/jekyll-actions

Create a **workflow file** using one of the following approaches:

- Actions tab
  - Go to the Actions tab on your GitHub repo and create a new file, named `jekyll.yml` for example.
- Add file to repo
  - Create the the file directly in the repo at the path `.github/worksflows/jekyll.yml` - note the
    dot at the start. This can be done locally too.

**Copy** the following to your workflow file, then save it.

{% raw %}
```yaml
name: Build and deploy Jekyll to GitHub Pages

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
{% endraw %}

To explain that workflow:

- We set the build to happen on **push** to `master` only - this prevents the action from
  overwriting the `gh-pages` branch on feature branch pushes.
- The **checkout** action takes care of cloning your repo.
- We specify the select **action** and version number using `helaili/jekyll-action@2.0.0`. This
  handles the build and deploy.
- We set a reference to a secret **environment variable** for the action to use. This Jekyll "PAT"
  is a "Personal Access Token" and is detailed in the next section.


### 3. Give the action permissions

The action needs permissions to push to your `gh-pages` branch. So create a GitHub **authentication
token** on your GitHub profile, then set it as an environment variable in your build using
_Secrets_.

1. On your GitHub profile, go to the [Tokens][4] page and then the **Personal Access Tokens**
   section.
2. **Create** a token. Give it a name like "GitHub Actions" and ensure it has permissions to
   `public_repos` - necessary for the action to commit to the `gh-pages` branch.
3. **Copy** the token value.
4. Go to your repo's _Settings_ and then the **Secrets** tab.
5. **Create** a token named `JEKYLL_PAT`. Set the value using the value copied above.

[4]: https://github.com/settings/tokens


### 4. Set Jekyll version

Jekyll version `4.0.0` has been selected for this tutorial. So add this to your `Gemfile`:

```ruby
gem 'jekyll', '~> 4.0.0'
```


### 5. Add a custom plugin

The [Timeago][5] plugin have been selected for this tutorial, as it is unsupported by the standard
GitHub Pages build. The point of the plugin is to turn a date (e.g. `2016-03-23T10:20:00Z`) into a
description of how long ago it was (e.g. `4 years and 3 weeks ago`).


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

{% raw %}
```liquid
{% assign date = '2020-04-13T10:20:00Z' %}

- Original date - {{ date }}
- With timeago filter - {{ date | timeago }}
```
{% endraw %}

[5]: https://rubygems.org/gems/jekyll-timeago


### Install gems

It is recommended to use [Bundler][6] to manage your project gems. Use that to install the gems we
set above.

[6]: https://bundler.io/

```sh
bundle install --path vendor/bundle
```

When we do a build, the action we set could given an **error** if your version of _Bundler_ which
was used to create the lock file is **different** to the one in the action environment. One solution
to this to do remove the `Gemfile.lock` from version control and add it file to `.gitignore`, so do
this now.


### 6. Build and deploy

Save and push any local changes on `master`.

The action will be triggered and your build will start.

To watch the progress and see any build errors, check on the build status using one of the following
approaches:

- **View by commit**
    - Go to the repo's level view in GitHub. Under the most recent commit (near the top) you’ll see
      a status symbol next to the commit message. Click the tick or _X_, then click _details_.
- **Actions tab**
    - Go to the repo's Actions tab. Click on a workflow run.

If all goes well, all steps will be green successes and there will be no serious errors in the log.
Also, the built assets will now exist on the `gh-pages` branch.


### 7. View site

On a successful build, GitHub Pages will publish the site stored on the repo's `gh-pages` branches.
Note that you do not need to setup a `gh-pages` branch or enable GitHub Pages, as the action will
take care of this for you.

To see the live site:

1. Go to the _environment_ tab on your repo.
2. Click _View Deployment_ to see the deployed site URL. Optionally add this URL to your repo's main
   page and to your _README.md_ to make it easy for people to find and visit.
4. View your site. Make sure the `timeago` filter works as expected.


### 8. Make further changes

When you need to make further changes to the site, make changes to `master` and push them. The
workflow will build and deploy your site.

Be sure to not edit the `gh-pages` branch directly as any changes will be last on the next `master`
build.


## Next steps

- Start to use the [Jekyll 4][0] features. Address any unexpected changes such as broken URLs.
- Choose another custom plugin and set it up.
- Look at other actions available in the Marketplace.


## External links

- [Actions][7] page on GitHub features.
- [Actions][8] page under GitHub help.
- [jekyll-actions][3] is an action available on the GitHub Marketplace and was used in this guide.
- [jekyll-actions-quickstart][9] is an unofficial repo that includes a live demo of the
  `jekyll-actions` action. That project can be used as a template for making a new site.

[7]: https://github.com/features/actions
[8]: https://help.github.com/en/actions
[9]: https://github.com/MichaelCurrin/jekyll-actions-quickstart
