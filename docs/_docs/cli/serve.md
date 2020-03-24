---
title: Serve
permalink: /docs/cli/serve/
---

Serve your site locally

### Usage:

    jekyll serve [options]
    jekyll server [options]
    jekyll s [options]

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
        --ssl-cert [CERT]  X.509 (SSL) certificate.
    -H, --host [HOST]  Host to bind to
    -o, --open-url     Launch your site in a browser
    -B, --detach       Run the server in the background
        --ssl-key [KEY]  X.509 (SSL) Private Key.
    -P, --port [PORT]  Port to listen on
        --show-dir-listing  Show a directory listing instead of loading your index file.
        --skip-initial-build  Skips the initial site build which occurs before the server is started.
    -l, --livereload   Use LiveReload to automatically refresh browsers
        --livereload-ignore ignore GLOB1[,GLOB2[,...]]  Files for LiveReload to ignore. Remember to quote the values so your shell won't expand them
        --livereload-min-delay [SECONDS]  Minimum reload delay
        --livereload-max-delay [SECONDS]  Maximum reload delay
        --livereload-port [PORT]  Port for LiveReload to listen on
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

In addition to the options below, the `serve` sub-command can accept any of the options for the [`build`](/docs/cli/build/) sub-command, which are then applied to the site build which occurs right before your site is served.


{% include serve_command_options.html %}
