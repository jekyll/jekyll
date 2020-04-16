---
title: GitHub Actions
---

When building a Jekyll site with GitHub Pages, the standard flow is restricted for security reasons
and to make it simpler to get a site setup. For more control over the build and still host the site
with GitHub Pages you can use GitHub Actions.


## Advantages of using Actions

### Control over gemset

- **Jekyll version** --- Instead of using the currently enabled version at `3.8.5`, you can use any
  version of Jekyll you want. For example `4.0.0`, or point directly to the repository.
- **Plugins** --- You can use any Jekyll plugins irrespective of them being on the
  [supported versions][ghp-whitelist] list, even `*.rb` files placed in the `_plugins` directory
  of your site.
- **Themes** --- While using a custom theme is possible without Actions, it is now simpler.

### Workflow Management

- **Customization** --- By creating a workflow file to run Actions, you can specify custom build
  steps, use environment variables.
- **Logging** --- The build log is visible and can be tweaked to be verbose, so it is much easier to
  debug errors using Actions.


## Workspace setup

The first and foremost requirement is a Jekyll project hosted at GitHub. Choose an existing Jekyll
project or follow the [Quickstart]{{ '/docs' | relative_url }} and push the repository to GitHub
if it is not hosted there already.

We're only going to cover builds from the `master` branch in this page. Therefore, ensure that you
are working on the `master` branch. If necessary, you may create it based on your default branch.
When the Action builds your site, the contents of the *destination* directory will be automatically
pushed to the `gh-pages` branch with a commit, ready to be used for serving.

{: .note .warning}
The Action we're using here will create (or reset an existing) `gh-pages` branch on every successful
deploy.<br/> So, if you have an existing `gh-pages` branch that is used to deploy your production
build, ensure to make a backup of the contents into a different branch so that you can rollback
easily if necessary.

The Jekyll site we'll be using for the rest of this page initially consists of just a `_config.yml`,
an `index.md` page and a Gemfile. The contents are respectively:

```yaml
# _config.yml

title: "Jekyll Actions Demo"
```

{% raw %}
```liquid
---
---

Welcome to My Home Page

{% assign date = '2020-04-13T10:20:00Z' %}

- Original date - {{ date }}
- With timeago filter - {{ date | timeago }}
```
{% endraw %}


```ruby
# Gemfile

source 'https://rubygems.org'

gem 'jekyll', '~> 4.0'

group :jekyll_plugins do
  gem 'jekyll-timeago', '~> 0.13.1'
end
```

{: .note .info}
The demo site uses Jekyll 4 and a [third-party plugin][timeago-plugin] both of which are
currently not whitelisted for use on GitHub pages. The plugin will allow us to turn a date say,
`2016-03-23T10:20:00Z` into a description of how long ago it was from today (`2020-04-13T10:20:00Z`)
which would be `4 years and 3 weeks ago`.

{: .note .info}
The action we're using takes care of installing the Ruby gems and dependencies. While that keeps
the set-up simple for the user, one may encounter issues if they also check-in `Gemfile.lock` if it
was generated with an old version of Bundler.

### Setting up the Action

GitHub Actions are registered for a repository by using a YAML file inside the directory path
`.github/worksflows` (note the dot at the start). Here we shall employ
[Jekyll Actions][jekyll-actions] from the Marketplace for its simplicity.

Create a **workflow file**, say `jekyll.yml`, using either the GitHub interface or by pushing
a YAML file to directory path manually. The base contents are:

{% raw %}
```yaml
name: Build and deploy Jekyll site to GitHub Pages

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

The above workflow can be explained as the following:

- We set the build to be triggered on **push** to `master` only --- this prevents the Action from
  overwriting the `gh-pages` branch on feature branch pushes.
- The name of the job matches our YAML filename: `jekyll`
- The **checkout** action takes care of cloning your repository.
- We specify the select **action** and version number using `helaili/jekyll-action@2.0.0`. This
  handles the build and deploy.
- We set a reference to a secret **environment variable** for the action to use. The `JEKYLL_PAT`
  is a *Personal Access Token* and is detailed in the next section.

### Providing permissions

The action needs permissions to push to your `gh-pages` branch. So you need to create a GitHub
**authentication token** on your GitHub profile, then set it as an environment variable in your
build using _Secrets_:

1. On your GitHub profile, go to the [tokens] page and then
   the **Personal Access Tokens** section.
2. **Create** a token. Give it a name like "GitHub Actions" and ensure it has permissions to
   `public_repos` (or the entire `repo` scope for private repository) --- necessary for the action
   to commit to the `gh-pages` branch.
3. **Copy** the token value.
4. Go to your repository's _Settings_ and then the **Secrets** tab.
5. **Create** a token named `JEKYLL_PAT` (*important*). Set the value using the value copied above.

### Build and deploy

On pushing any local changes onto `master` the action will be triggered and the build will start.

To watch the progress and see any build errors, check on the build status using one of the following
approaches:

- **View by commit**
    - Go to the repository level view in GitHub. Under the most recent commit (near the top) you’ll
      see a status symbol next to the commit message. Click the tick or _X_, then click _details_.
- **Actions tab**
    - Go to the repository's Actions tab. Click on the `jekyll` workflow tab.

If all goes well, all steps will be green and the built assets will now exist on the `gh-pages`
branch.

On a successful build, GitHub Pages will publish the site stored on the repository `gh-pages`
branches. Note that you do not need to setup a `gh-pages` branch or enable GitHub Pages, as the
action will take care of this for you.
(For private repositories, you'll have to upgrade to a paid plan).

To see the live site:

1. Go to the _environment_ tab on your repository.
2. Click _View Deployment_ to see the deployed site URL. Optionally add this URL to your
   repository's main page and to your _README.md_ to make it easy for people to find and visit.
4. View your site. Make sure the `timeago` filter works as expected.

When you need to make further changes to the site, make changes to `master` and push them. The
workflow will build and deploy your site.

Be sure to not edit the `gh-pages` branch directly as any changes will be lost on the next
successful deploy from the Action.

## External links

- [jekyll-actions] is an action available on the GitHub Marketplace and was used in this guide.
- [jekyll-actions-quickstart] is an unofficial repository that includes a live demo of the
  `jekyll-actions` action. That project can be used as a template for making a new site.


[ghp-whitelist]: https://pages.github.com/versions/
[timeago-plugin]: https://rubygems.org/gems/jekyll-timeago
[tokens]: https://github.com/settings/tokens
[jekyll-actions]: https://github.com/marketplace/actions/jekyll-actions
[jekyll-actions-quickstart]: https://github.com/MichaelCurrin/jekyll-actions-quickstart
