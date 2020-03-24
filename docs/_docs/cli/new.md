---
title: New
permalink: /docs/cli/new/
---

Creates a new Jekyll site scaffold in PATH

### Usage:

    jekyll new PATH

### Options:

    --force        Force creation even if PATH already exists
    --blank        Creates scaffolding but with empty files
    --skip-bundle  Skip 'bundle install'
    -s, --source [DIR]  Source directory (defaults to ./)
    -d, --destination [DIR]  Destination directory (defaults to ./_site)
    --safe         Safe mode (defaults to false)
    -p, --plugins PLUGINS_DIR1[,PLUGINS_DIR2[,...]]  Plugins directory (defaults to ./_plugins)
    --layouts DIR  Layouts directory (defaults to ./_layouts)
    --profile      Generate a Liquid rendering profile
    -h, --help         Show this message
    -v, --version      Print the name and version
    -t, --trace        Show the full backtrace when an error occurs 
