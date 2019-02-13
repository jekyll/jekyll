---
title: 3rd Party
permalink: /docs/deployment/third-party/
---

## Aerobatic

[Aerobatic](https://www.aerobatic.com) has custom domains, global CDN distribution, basic auth, CORS proxying, and a growing list of plugins all included.

Automating the deployment of a Jekyll site is simple. See their [Jekyll docs](https://www.aerobatic.com/docs/static-site-generators/#jekyll) for more details. Your built `_site` folder is deployed to their highly-available, globally distributed hosting service.

## AWS Amplify

The [AWS Amplify Console](https://console.amplify.aws) provides continuous deployment and hosting for modern web apps (single page apps and static site generators). Continuous deployment allows developers to deploy updates to their web app on every code commit to their Git repository. Hosting includes features such as globally available CDNs, 1-click custom domain setup + HTTPS, feature branch deployments, redirects, trailing slashes, and password protection.

Read this [step-by-step guide](https://medium.com/@FizzyInTheHall/build-and-publish-a-jekyll-powered-blog-easily-with-aws-amplify-529852042ab6) to deploy and host your Jekyll site on AWS Amplify.

## CloudCannon

[CloudCannon](https://cloudcannon.com) has everything you need to build, host
and update Jekyll websites. Take advantage of our global CDN, automated SSL,
continuous deployment and [more](https://cloudcannon.com/features/).

## GitHub Pages

Sites on GitHub Pages are powered by Jekyll behind the scenes, so if you’re looking for a zero-hassle, zero-cost solution, GitHub Pages are a great way to [host your Jekyll-powered website for free](/docs/github-pages/).

## Kickster

Use [Kickster](http://kickster.nielsenramon.com/) for automated deploys to GitHub Pages when using unsupported plugins on GitHub Pages.

Kickster provides a basic Jekyll project setup packed with web best practises and useful optimization tools increasing your overall project quality. Kickster ships with automated and worry-free deployment scripts for GitHub Pages.

Install the Kickster gem and you are good to go. More documentation can here found [here](https://github.com/nielsenramon/kickster#kickster). If you do not want to use the gem or start a new project you can just copy paste the deployment scripts for [Travis CI](https://github.com/nielsenramon/kickster/tree/master/snippets/travis) or [Circle CI](https://github.com/nielsenramon/kickster#automated-deployment-with-circle-ci).


## Netlify

Netlify provides Global CDN, Continuous Deployment, one click HTTPS and [much more](https://www.netlify.com/features/), providing developers the most robust toolset available for modern web projects, without added complexity. Netlify supports custom plugins for Jekyll and has a free plan for open source projects.

Read this [Jekyll step-by-step guide](https://www.netlify.com/blog/2015/10/28/a-step-by-step-guide-jekyll-3.0-on-netlify/) to setup your Jekyll site on Netlify.

## Static Publisher

[Static Publisher](https://github.com/static-publisher/static-publisher) is another automated deployment option with a server listening for webhook posts, though it's not tied to GitHub specifically. It has a one-click deploy to Heroku, it can watch multiple projects from one server, it has an easy to user admin interface and can publish to either S3 or to a git repository (e.g. gh-pages).
