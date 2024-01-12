---
title: GitHub Actions
---

When building a Jekyll site with GitHub Pages, the standard flow is restricted for security reasons
and to make it simpler to get a site setup. For more control over the build and still host the site
with GitHub Pages you can use GitHub Actions.

## Advantages of using Actions

### Control over gemset

- **Jekyll version** --- Instead of using the classic GitHub Pages provided version at `3.9.3`, you
  can use any version of Jekyll you want. For example `{{site.version}}`, or point directly to the
  repository.
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

gem "jekyll", "~> 4.2"

group :jekyll_plugins do
  gem "jekyll-timeago", "~> 0.13.1"
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

1. Go to the **Settings** tab on your repository.
    1. Click **Pages** under **Code and automation**.
    2. Change **Source** under **Build and deployment** from **Deploy from a branch** to **GitHub Actions**.
2. Go to the **Actions** tab on your repository.
    1. Start a **New workflow** and search for **Jekyll**.
    2. Click **Configure** under the **Jekyll** workflow (not **GitHub Pages Jekyll** workflow).
    3. Review the change and click **Commit changes**.

### Build and deploy

On pushing any local changes onto the default branch, the action will be triggered and the build will
**start**.

To watch the progress and see any build errors, check on the build **status** using one of the
following approaches:

- **View by commit**
  - Go to the repository level view in GitHub. Under the most recent commit (near the top) you’ll
    see a **status symbol** next to the commit message as a tick or _X_. Hover over it and click
    the **details** link.
- **Actions tab**
  - Go to the repository's Actions tab. Click on the `jekyll` workflow tab.

If all goes well, all steps will be green and the built assets will be uploaded to GitHub Pages. 

To see the **live site**, go to the **Deployments** tab on your repository, and click on the deployed
site URL.

When you need to make further **changes** to the site, commit to the default branch and push.
The workflow will build and deploy your site again.

## External links

- [starter-workflows] is the official repository providing the workflow template used in this guide.

[ghp-whitelist]: https://pages.github.com/versions/
[timeago-plugin]: https://rubygems.org/gems/jekyll-timeago
[starter-workflows]: https://github.com/actions/starter-workflows/blob/main/pages/jekyll.yml
