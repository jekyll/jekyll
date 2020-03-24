---
title: Build
permalink: /docs/cli/build/
---

Build your site

### Usage:

    jekyll build [options]
    jekyll b [options]

### Options:
        --config CONFIG_FILE[,CONFIG_FILE2,...]  Custom configuration file
    -d, --destination DESTINATION  The current folder will be generated into DESTINATION
    -s, --source SOURCE  Custom source directory
        --future       Publishes posts with a future date
        --limit_posts MAX_POSTS  Limits the number of posts to parse and publish
    -w, --[no-]watch   Watch for changes and rebuild
    -b, --baseurl URL  Serve the website from the given base URL
        --force_polling  Force watch to use polling
        --lsi          Use LSI for improved related posts
    -D, --drafts       Render posts in the _drafts folder
        --unpublished  Render posts that were marked as unpublished
    -q, --quiet        Silence output.
    -V, --verbose      Print verbose output.
    -I, --incremental  Enable incremental rebuild.
        --strict_front_matter  Fail if errors are present in front matter
    -s, --source [DIR]  Source directory (defaults to ./)
    -d, --destination [DIR]  Destination directory (defaults to ./_site)
        --safe         Safe mode (defaults to false)
    -p, --plugins PLUGINS_DIR1[,PLUGINS_DIR2[,...]]  Plugins directory (defaults to ./_plugins)
        --layouts DIR  Layouts directory (defaults to ./_layouts)
        --profile      Generate a Liquid rendering profile
    -h, --help         Show this message
    -v, --version      Print the name and version
    -t, --trace        Show the full backtrace when an error occurs 

### Longer Explanation of Options

{% include build_command_options.html %}
