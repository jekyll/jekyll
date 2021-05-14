---
title: GitHub Actions
---

When building a Jekyll site with GitHub Pages, the standard flow is restricted for security reasons
and to make it simpler to get a site setup. For more control over the build and still host the site
with GitHub Pages you can use GitHub Actions.

## Advantages of using Actions

### Control over gemset

- **Jekyll version** --- Instead of using the currently enabled version at `3.9.0`, you can use any
  version of Jekyll you want. For example `{{site.version}}`, or point directly to the repository.
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
project or follow the [quickstart]({{ '/docs/' | relative_url }}) and push the repository to GitHub
if it is not hosted there already.

We're only going to cover builds from the `main` branch in this page. Therefore, ensure that you
are working on the `main` branch. If necessary, you may create it based on your default branch.
When the Action builds your site, the contents of the _destination_ directory will be automatically
pushed to the `gh-pages` branch with a commit, ready to be used for serving.

{: .note .warning}
The Action we're using here will create (or reset an existing) `gh-pages` branch on every successful
deploy.<br/> So, if you have an existing `gh-pages` branch that is used to deploy your production
build, ensure to make a backup of the contents into a different branch so that you can rollback
easily if necessary.

The Jekyll site we'll be using for the rest of this page initially consists of just a `_config.yml`,
an `index.md` page and a `Gemfile`. The contents are respectively:

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

gem 'jekyll', '~> 4.2'

group :jekyll_plugins do
  gem 'jekyll-timeago', '~> 0.13.1'
end
```

{: .note .info}
The demo site uses Jekyll 4 and a [third-party plugin][timeago-plugin], both of which are currently
not whitelisted for use on GitHub pages. The plugin will allow us to describe how far back a date
was from today. e.g. If we give a date as `2016-03-23T10:20:00Z` and the current date is
`2020-04-13T10:20:00Z`, then the output would be `4 years and 3 weeks ago`.

{: .note .info}
The action we're using takes care of installing the Ruby gems and dependencies. While that keeps
the setup simple for the user, one may encounter issues if they also check-in `Gemfile.lock` if it
was generated with an old version of Bundler.

### Setting up the Action

GitHub Actions are registered for a repository by using a YAML file inside the directory path
`.github/workflows` (note the dot at the start). Here we shall employ
[Jekyll Actions][jekyll-actions] from the Marketplace for its simplicity.

Create a **workflow file**, say `github-pages.yml`, using either the GitHub interface or by pushing
a YAML file to the workflow directory path manually. The base contents are:

{% raw %}

```yaml
name: Build and deploy Jekyll site to GitHub Pages

on:
  push:
    branches:
      - main # or master before October 2020

jobs:
  github-pages:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: helaili/jekyll-action@v2
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
```

{% endraw %}

The above workflow can be explained as the following:

- We trigger the build using **on.push** condition for `main` branch only --- this prevents
  the Action from overwriting the `gh-pages` branch on any feature branch pushes.
- The **name** of the job matches our YAML filename: `github-pages`.
- The **checkout** action takes care of cloning your repository.
- We specify our selected **action** and **version number** using `helaili/jekyll-action@2.0.5`.
  This handles the build and deploy.
- We set a reference to a secret **environment variable** for the action to use. The `GITHUB_TOKEN`
  is a _Personal Access Token_ and is detailed in the next section.

Instead of using the **on.push** condition, you could trigger your build on a **schedule** by
using the [on.schedule] parameter. For example, here we build daily at midnight by specifying
**cron** syntax, which can be tested at the [crontab guru] site.

```yaml
on:
  schedule:
    - cron: "0 0 * * *"
```

Note that this string must be quoted to prevent the asterisks from being evaluated incorrectly.

[on.schedule]: https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#onschedule
[crontab guru]: https://crontab.guru/

### Providing permissions

The action needs permissions to push to your `gh-pages` branch. So you need to create a GitHub
**authentication token** on your GitHub profile, then set it as an environment variable in your
build using _Secrets_:

1. On your GitHub profile, under **Developer Settings**, go to the [Personal Access Tokens][tokens]
   section.
2. **Create** a token. Give it a name like "GitHub Actions" and ensure it has permissions to
   `public_repos` (or the entire `repo` scope for private repository) --- necessary for the action
   to commit to the `gh-pages` branch.
3. **Copy** the token value.
4. Go to your repository's **Settings** and then the **Secrets** tab.
5. **Create** a token named `GITHUB_TOKEN` (_important_). Give it a value using the value copied
   above.

### Build and deploy

On pushing any local changes onto `master`, the action will be triggered and the build will
**start**.

To watch the progress and see any build errors, check on the build **status** using one of the
following approaches:

- **View by commit**
  - Go to the repository level view in GitHub. Under the most recent commit (near the top) you’ll
    see a **status symbol** next to the commit message as a tick or _X_. Hover over it and click
    the **details** link.
- **Actions tab**
  - Go to the repository's Actions tab. Click on the `jekyll` workflow tab.

If all goes well, all steps will be green and the built assets will now exist on the `gh-pages`
branch.

On a successful build, GitHub Pages will **publish** the site stored on the repository `gh-pages`
branches. Note that you do not need to setup a `gh-pages` branch or enable GitHub Pages, as the
action will take care of this for you.
(For private repositories, you'll have to upgrade to a paid plan).

To see the **live site**:

1. Go to the **environment** tab on your repository.
2. Click **View Deployment** to see the deployed site URL.
3. View your site at the **URL**. Make sure the `timeago` filter works as expected.
4. Optionally **add** this URL to your repository's main page and to your `README.md`, to make it
   easy for people to find.

When you need to make further **changes** to the site, commit to `master` and push. The workflow
will build and deploy your site again.

Be sure **not to edit** the `gh-pages` branch directly, as any changes will be lost on the next
successful deploy from the Action.

## External links

- [jekyll-actions] is an action available on the GitHub Marketplace and was used in this guide.
- [jekyll-actions-quickstart] is an unofficial repository that includes a live demo of the
  `jekyll-actions` action. That project can be used as a template for making a new site.
- [jekyll-action-ts] is another action to build and publish Jekyll sites on GiHub Pages that includes HTML formatting options with Prettier and caching.

[ghp-whitelist]: https://pages.github.com/versions/
[timeago-plugin]: https://rubygems.org/gems/jekyll-timeago
[tokens]: https://github.com/settings/tokens
[jekyll-actions]: https://github.com/marketplace/actions/jekyll-actions
[jekyll-actions-quickstart]: https://github.com/MichaelCurrin/jekyll-actions-quickstart
[jekyll-action-ts]: https://github.com/limjh16/jekyll-action-ts
