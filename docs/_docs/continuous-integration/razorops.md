---
title: "Razorops"
---

[Razorops][razorops-homepage] is a complete container native CI/CD solution handling all aspects of the software lifecycle from the moment a commit is created until it is deployed to production.
Razorops has all the capabilities that you would expect from a CI/CD platform such as
1. Code compilation/build
2. Artifact packaging
3. Testing Automation(unit, integration, acceptance etc.)
4. Faster builds and shipping to production

Razorops is a single solution that implements the whole pipeline from start to deployment.

With [Razorops][razorops-homepage] you can set up your Jekyll websites project's build, test, and deploy steps just in 15 min. It supports [GitHub][github-homepage], [Bitbucket][bitbucket-homepage], and [GitLab][gitlab-homepage] repositories. The following guide will show you how to set up a free environment to build, test and deploy your Jekyll project.

[razorops-homepage]: https://razorops.com/
[docker-homepage]: https://www.docker.com/
[github-homepage]: https://github.com
[bitbucket-homepage]: https://bitbucket.org/
[gitlab-homepage]: https://gitlab.com
[deploy-s3]: https://razorops.com/blog/how-to-deploy-a-static-website-to-aws-s3-with-razorops-ci-cd/

## 1. Getting started

1. Log in at [https://razorops.com/][razorops-homepage] with your GitHub/Bitbucket or GitLab account
2. Create a pipeline, choose your Git provider and select your Jekyll Project
3. Add .razorops.yaml file in your root directory of your project
4. Add environment var and your deployment is ready
5. Add build and deployment steps as shown in this post [How to Deploy a Static Website to AWS S3 with Razorops CI/CD][deploy-s3]

## 2. How it works

Whenever you make a push to the selected branch, your steps auto runs as defined in .razorops.yaml file 

```yaml
  tasks:
    build-and-deploy:
      steps:
      - checkout
      # commands to build jekyll website
      - commands:
        - bundle install
        - JEKYLL_ENV=production bundle exec jekyll build
      # Commands to upload static pages folder to AWS S3 or ftp
      # Set AWS access key & secrets environment variables under 
      # Razorops dashboard project pipelines 
      - commands:
        - aws s3 rm s3://$AWS_S3_BUCKET --recursive
        - aws s3 cp _site s3://$AWS_S3_BUCKET --recursive
        if: branch == 'main'

```



 Build step generates _site folder as Jekyll default and during deploy you will able to ship code to s3 or any ftp server you can define any command to ship your website code to server.

Razorops is FREE for opensource projects, Try it Now
[https://razorops.com/][razorops-homepage]


