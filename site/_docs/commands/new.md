---
layout: docs
title: jekyll new
permalink: /docs/commands/new/
---

### jekyll new

This command generates a new jekyll site scaffold at the path specified.

  syntax  : `jekyll new PATH`  
  options :
  
  alias | option-name | description
  ----- | ----------- | -----------
        | `--force`   | Force site-creation even if PATH already exists
        | `--blank`   | Creates a site scaffold, but with empty files

`jekyll new` is probably the very first command one uses right after installing the Jekyll gem. Historically, the associated scaffolding followed this directory structure:

```sh
.
├── _drafts     # created automatically with the --blank switch
├── _includes   # not created if --blank has been input 
├── _layouts
├── _posts
├── _sass
├── css
├── .gitignore
├── _config.yml
├── about.md
├── feed.xml
└── index.html

```
Jekyll 3.2 brought in a major change to scaffolding. Creating a new site with versions >= 3.2.0, and with default switches, results in the following structure : (showing only the major directories/files)

#### (site-proper) :

```sh
.
├── _posts
├── css
├── .gitignore
├── _config.yml
├── about.md
├── feed.xml
└── index.html

```
#### (site-theme-gem) *default: 'minima'* :

```sh
.
├── _includes 
├── _layouts
├── _sass
├── Gemfile
├── LICENSE.txt
├── README.md
└── CODE_OF_CONDUCT.md

```
