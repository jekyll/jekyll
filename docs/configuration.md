---
layout: docs
title: Configuration
prev_section: structure
next_section: frontmatter
permalink: /docs/configuration/
---

Jekyll allows you to concoct your sites in any way you can dream up, and it’s
thanks to the powerful and flexible configuration options that this is possible.
These options can either be specified in a `_config.yml` file placed in your
site’s root directory, or can be specified as flags for the `jekyll` executable
in the terminal.

## Configuration Settings

### Global Configuration

The table below lists the available settings for Jekyll, and the various <code
class="option">options</code> (specified in the configuration file) and <code
class="flag">flags</code> (specified on the command-line) that control them.

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Setting</th>
      <th>
        <span class="option">Options</span> and <span class="flag">Flags</span>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Site Source</strong></p>
        <p class='description'>Change the directory where Jekyll will read files</p>
      </td>
      <td class="align-center">
        <p><code class="option">source: DIR</code></p>
        <p><code class="flag">-s, --source DIR</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Site Destination</strong></p>
        <p class='description'>Change the directory where Jekyll will write files</p>
      </td>
      <td class="align-center">
        <p><code class="option">destination: DIR</code></p>
        <p><code class="flag">-d, --destination DIR</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Safe</strong></p>
        <p class='description'>Disable <a href="../plugins">custom plugins</a>.</p>
      </td>
      <td class="align-center">
        <p><code class="option">safe: BOOL</code></p>
        <p><code class="flag">--safe</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Exclude</strong></p>
        <p class="description">Exclude directories and/or files from the conversion</p>
      </td>
      <td class='align-center'>
        <p><code class="option">exclude: [DIR, FILE, ...]</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Include</strong></p>
        <p class="description">
          Force inclusion of directories and/or files in the conversion.
          <code>.htaccess</code> is a good example since dotfiles are excluded
          by default.
        </p>
      </td>
      <td class='align-center'>
        <p><code class="option">include: [DIR, FILE, ...]</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Time Zone</strong></p>
        <p class="description">
            Set the time zone for site generation. This sets the <code>TZ</code>
            environment variable, which Ruby uses to handle time and date
            creation and manipulation. Any entry from the
            <a href="http://en.wikipedia.org/wiki/List_of_tz_database_time_zones">IANA Time Zone
            Database</a> is valid, e.g. <code>America/New_York</code>. The default
            is the local time zone, as set by your operating system.
        </p>
      </td>
      <td class='align-center'>
        <p><code class="option">timezone: TIMEZONE</code></p>
      </td>
    </tr>
  </tbody>
</table>
</div>

### Build Command Options

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Setting</th>
      <th><span class="option">Options</span> and <span class="flag">Flags</span></th>
    </tr>
  </thead>
  <tbody>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Regeneration</strong></p>
        <p class='description'>Enable auto-regeneration of the site when files are modified.</p>
      </td>
      <td class="align-center">
        <p><code class="flag">-w, --watch</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Configuration</strong></p>
        <p class="description">Specify a config file. Overrides settings in <code>_config.yml</code></p>
      </td>
      <td class='align-center'>
        <p><code class="flag">--config FILE</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Drafts</strong></p>
        <p class="description">Process and render draft posts.</p>
      </td>
      <td class='align-center'>
        <p><code class="flag">--drafts</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Future</strong></p>
        <p class="description">Publish posts with a future date.</p>
      </td>
      <td class='align-center'>
        <p><code class="option">future: BOOL</code></p>
        <p><code class="flag">--future</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>LSI</strong></p>
        <p class="description">Produce an index for related posts.</p>
      </td>
      <td class='align-center'>
        <p><code class="option">lsi: BOOL</code></p>
        <p><code class="flag">--lsi</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Limit Posts</strong></p>
        <p class="description">Limit the number of posts to parse and publish.</p>
      </td>
      <td class='align-center'>
        <p><code class="option">limit_posts: NUM</code></p>
        <p><code class="flag">--limit_posts NUM</code></p>
      </td>
    </tr>
  </tbody>
</table>
</div>

### Serve Command Options

In addition to the options below, the `serve` sub-command can accept any of the options
for the `build` sub-command, which are then applied to the site build which occurs right
before your site is served.

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Setting</th>
      <th><span class="option">Options</span> and <span class="flag">Flags</span></th>
    </tr>
  </thead>
  <tbody>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Local Server Port</strong></p>
        <p class='description'>Listen on the given port.</p>
      </td>
      <td class="align-center">
        <p><code class="option">port: PORT</code></p>
        <p><code class="flag">--port PORT</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Local Server Hostname</strong></p>
        <p class='description'>Listen at the given hostname.</p>
      </td>
      <td class="align-center">
        <p><code class="option">host: HOSTNAME</code></p>
        <p><code class="flag">--host HOSTNAME</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Base URL</strong></p>
        <p class='description'>Serve the website from the given base URL</p>
      </td>
      <td class="align-center">
        <p><code class="option">baseurl: URL</code></p>
        <p><code class="flag">--baseurl URL</code></p>
      </td>
    </tr>
  </tbody>
</table>
</div>

<div class="note warning">
  <h5>Do not use tabs in configuration files</h5>
  <p>
    This will either lead to parsing errors, or Jekyll will revert to the
    default settings. Use spaces instead.
  </p>
</div>

## Default Configuration

Jekyll runs with the following configuration options by default. Unless
alternative settings for these options are explicitly specified in the
configuration file or on the command-line, Jekyll will run using these options.

{% highlight yaml %}
source:      .
destination: ./_site
plugins:     ./_plugins
layouts:     ./_layouts
include:     ['.htaccess']
exclude:     []
keep_files:  ['.git','.svn']
timezone:    nil

future:      true
show_drafts: nil
limit_posts: 0
pygments:    true

relative_permalinks: true

permalink:     date
paginate_path: 'page:num'

markdown:      maruku
markdown_ext:  markdown,mkd,mkdn,md
textile_ext:   textile

excerpt_separator: "\n\n"

safe:        false
watch:       false    # deprecated
server:      false    # deprecated
host:        0.0.0.0
port:        4000
baseurl:     /
url:         http://localhost:4000
lsi:         false

maruku:
  use_tex:    false
  use_divs:   false
  png_engine: blahtex
  png_dir:    images/latex
  png_url:    /images/latex

rdiscount:
  extensions: []

redcarpet:
  extensions: []

kramdown:
  auto_ids: true
  footnote_nr: 1
  entity_output: as_char
  toc_levels: 1..6
  smart_quotes: lsquo,rsquo,ldquo,rdquo
  use_coderay: false

  coderay:
    coderay_wrap: div
    coderay_line_numbers: inline
    coderay_line_numbers_start: 1
    coderay_tab_width: 4
    coderay_bold_every: 10
    coderay_css: style

redcloth:
  hard_breaks: true
{% endhighlight %}
