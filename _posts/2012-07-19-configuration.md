---
layout: docs
title: Configuration
prev_section: structure
next_section: frontmatter
---

Jekyll allows you to concoct your sites in any way you can dream up. The
following is a list of the currently supported configuration options.
These can all be specified by creating a `_config.yml` file in your
site’s root directory. There are also flags for the `jekyll` executable
which are described below next to their respective configuration
options. The order of precedence for conflicting settings is this:

1.  Command-line flags
2.  Configuration file settings
3.  Defaults

## Configuration Settings

**Setting**         **Config**                                    **Flag**                                         **Description**


Default Configuration
---------------------

**Note** &mdash; You cannot use tabs in configuration files. This will
either lead to parsing errors, or Jekyll will use the default settings.

{% highlight yaml %}
safe:        false
auto:        false
server:      false
server_port: 4000
baseurl:    /
url: http://localhost:4000

source:      .
destination: ./_site
plugins:     ./_plugins

future:      true
lsi:         false
pygments:    false
markdown:    maruku
permalink:   date

maruku:
  use_tex:    false
  use_divs:   false
  png_engine: blahtex
  png_dir:    images/latex
  png_url:    /images/latex

rdiscount:
  extensions: []

kramdown:
  auto_ids: true,
  footnote_nr: 1
  entity_output: as_char
  toc_levels: 1..6
  use_coderay: false

  coderay:
    coderay_wrap: div
    coderay_line_numbers: inline
    coderay_line_numbers_start: 1
    coderay_tab_width: 4
    coderay_bold_every: 10
    coderay_css: style

{% endhighlight %}
