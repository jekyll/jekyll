---
layout: docs
title: jekyll build
permalink: /docs/commands/build/
---


This command builds your site.

  syntax  : `jekyll build [options]`  
  alias   : `b`  
  options :
  
  alias | option-name | parameters | description
  ----- | ----------- | ---------- | -----------
        | `--config`  | FILE1[FILE2,FILE3,..] | Specify a config file instead of the default *_config.yml*
   `-s` | `--source`  | SOURCE | Change the directory where Jekyll will read files. <br> **Default:** `current_folder`
   `-d` | `--destination` | DESTINATION | Change the directory where Jekyll will write files. <br> **Default:** `current_folder/_site`
   `-w` | `--watch` <br> `--no-watch` |  | watch for changes and rebuild <br> or disable watch
        | `--force_polling` |  | Force watch to use polling
   `-b` | `--baseurl` | URL | Serve the website from the given base URL

