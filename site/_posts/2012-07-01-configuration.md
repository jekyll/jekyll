---
layout: docs
title: Configuration
prev_section: structure
next_section: frontmatter
---

Jekyll allows you to concoct your sites in any way you can dream up, and it’s thanks to the powerful and flexible configuration options that this is possible. These options can either be specified in a `_config.yml` file placed in your site’s root directory, or can be specified as flags for the `jekyll` executable in the terminal.

## Configuration Settings

### Global Configuration

The table below lists the available settings for Jekyll, and the various <code class="option">options</code> (specifed in the configuration file) and <code class="flag">flags</code> (specified on the command-line) that control them.

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
        <p class='name'><strong>Site Source</strong></p>
        <p class='description'>Changes the directory where Jekyll will look to transform files</p>
      </td>
      <td class="align-center">
        <p><code class="option">source: [string]</code></p>
        <p><code class="flag">--source [source]</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Site Destination</strong></p>
        <p class='description'>Changes the directory where Jekyll will write files to</p>
      </td>
      <td class="align-center">
        <p><code class="option">destination: [string]</code></p>
        <p><code class="flag">--destination</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Safe</strong></p>
        <p class='description'>Disables <a href="../plugins">custom plugins</a>.</p>
      </td>
      <td class="align-center">
        <p><code class="option">safe: [boolean]</code></p>
        <p><code class="flag">--safe</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Exclude</strong></p>
        <p class="description">A list of directories and files to exclude from the conversion</p>
      </td>
      <td class='align-center'>
        <p><code class="option">exclude: [dir1, file1, dir2]</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Include</strong></p>
        <p class="description">A list of directories and files to specifically include in the conversion. <code>.htaccess</code> is a good example since dotfiles are excluded by default.</p>
      </td>
      <td class='align-center'>
        <p><code class="option">include: [dir1, file1, dir2]</code></p>
      </td>
    </tr>
  </tbody>
</table>

### Build Command Options

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
        <p class='description'>Enables auto-regeneration of the site when files are modified. Off by default.</p>
      </td>
      <td class="align-center">
        <p><code class="flag">--watch</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>URL</strong></p>
        <p class='description'>Sets <code>site.url</code>, useful for environment switching</p>
      </td>
      <td class="align-center">
        <p><code class="option">url: [URL]</code></p>
        <p><code class="flag">--url [URL]</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Markdown</strong></p>
        <p class="description">Uses RDiscount or <code>[engine]</code> instead of Maruku.</p>
      </td>
      <td class='align-center'>
        <p><code class="option">markdown: [engine]</code></p>
        <p><code class="flag">--markdown [rdiscount|kramdown|redcarpet]</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Pygments</strong></p>
        <p class="description">Enables highlight tag with Pygments.</p>
      </td>
      <td class='align-center'>
        <p><code class="option">pygments: [boolean]</code></p>
        <p><code class="flag">--pygments</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Future</strong></p>
        <p class="description">Publishes posts with a future date</p>
      </td>
      <td class='align-center'>
        <p><code class="option">future: [boolean]</code></p>
        <p><code class="flag">--future</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>LSI</strong></p>
        <p class="description">Produces an index for related posts.</p>
      </td>
      <td class='align-center'>
        <p><code class="option">lsi: [boolean]</code></p>
        <p><code class="flag">--lsi</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Permalink</strong></p>
        <p class="description">Controls the URLs that posts are generated with. Please refer to the <a href="../permalinks">Permalinks</a> page for more info.</p>
      </td>
      <td class='align-center'>
        <p><code class="option">permalink: [style]</code></p>
        <p><code class="flag">--permalink [style]</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Pagination</strong></p>
        <p class="description">Splits your posts up over multiple subdirectories called "page2", "page3", ... "pageN"</p>
      </td>
      <td class='align-center'>
        <p><code class="option">paginate: [per_page]</code></p>
        <p><code class="flag">--paginate [per_page]</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Limit Posts</strong></p>
        <p class="description">Limits the number of posts to parse and publish</p>
      </td>
      <td class='align-center'>
        <p><code class="option">limit_posts: [max_posts]</code></p>
        <p><code class="flag">--limit_posts [max_posts]</code></p>
      </td>
    </tr>
  </tbody>
</table>

### Serve Command Options

In addition to the options below, the `serve` sub-command can accept any of the options
for the `build` sub-command, which are then applied to the site build which occurs right
before your site is served.

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
        <p class='description'>Changes the port that the Jekyll server will run on</p>
      </td>
      <td class="align-center">
        <p><code class="option">port: [integer]</code></p>
        <p><code class="flag">--port [port]</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Local Server Hostname</strong></p>
        <p class='description'>Changes the hostname that the Jekyll server will run on</p>
      </td>
      <td class="align-center">
        <p><code class="option">host: [string]</code></p>
        <p><code class="flag">--host [hostname]</code></p>
      </td>
    </tr>
    <tr class='setting'>
      <td>
        <p class='name'><strong>Base URL</strong></p>
        <p class='description'>Serve website from a given base URL</p>
      </td>
      <td class="align-center">
        <p><code class="option">baseurl: [BASE_URL]</code></p>
        <p><code class="flag">--baseurl [url]</code></p>
      </td>
    </tr>
  </tbody>
</table>

<div class="note warning">
  <h5>Do not use tabs in configuration files</h5>
  <p>This will either lead to parsing errors, or Jekyll will revert to the default settings. Use spaces instead.</p>
</div>

## Default Configuration

Jekyll runs with the following configuration options by default. Unless alternative settings for these options are explicitly specified in the configuration file or on the command-line, Jekyll will run using these options.

{% highlight yaml %}
safe:        false
watch:       false
server:      false
host:        0.0.0.0
port:        4000
baseurl:     /
url:         http://localhost:4000

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
