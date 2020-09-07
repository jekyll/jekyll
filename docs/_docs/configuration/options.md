---
title: Configuration Options
permalink: "/docs/configuration/options/"
---

The tables below list the available settings for Jekyll, and the various <code
class="option">options</code> (specified in the configuration file) and <code
class="flag">flags</code> (specified on the command-line) that control them.

### Global Configuration

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
    {% for setting in site.data.config_options.global %}
      <tr class="setting">
        <td>
          <p class="name">
            <strong>{{ setting.name }}</strong>
            {% if setting.version-badge %}
              <span class="version-badge" title="Introduced in v{{ setting.version-badge }}">{{ setting.version-badge }}</span>
            {% endif %}
          </p> 
          <p class="description">{{ setting.description }}</p>
        </td> 
        <td class="align-center">
          <p><code class="option">{{ setting.option }}</code></p>
          {% if setting.flag %}
            <p><code class="flag">{{ setting.flag }}</code></p>
          {% endif %}
        </td>
      </tr>
    {% endfor %}
    <tr>
      <td>
        <p class='name'><strong>Defaults</strong></p>
        <p class='description'>
            Set defaults for <a href="{{ '/docs/front-matter/' | relative_url }}" title="front matter">front matter</a>
            variables.
        </p>
      </td>
      <td class='align-center'>
        <p>see <a href="{{ '/docs/configuration/front-matter-defaults/' | relative_url }}" title="details">below</a></p>
      </td>
    </tr>
  </tbody>
</table>
</div>

<div class="note warning">
  <h5>Destination folders are cleaned on site builds</h5>
  <p>
    The contents of <code>&lt;destination&gt;</code> are automatically
    cleaned, by default, when the site is built. Files or folders that are not
    created by your site will be removed. Some files could be retained
    by specifying them within the <code>&lt;keep_files&gt;</code> configuration directive.
  </p>
  <p>
    Do not use an important location for <code>&lt;destination&gt;</code>; instead, use it as
    a staging area and copy files from there to your web server.
  </p>
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
    <tr class="setting">
      <td>
        <p class="name"><strong>Regeneration</strong></p>
        <p class="description">Enable auto-regeneration of the site when files are modified.</p>
      </td>
      <td class="align-center">
        <p><code class="flag">-w, --[no-]watch</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Configuration</strong></p>
        <p class="description">Specify config files instead of using <code>_config.yml</code> automatically. Settings in later files override settings in earlier files.</p>
      </td>
      <td class="align-center">
        <p><code class="flag">--config FILE1[,FILE2,...]</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Plugins</strong></p>
        <p class="description">Specify plugin directories instead of using <code>_plugins/</code> automatically.</p>
      </td>
      <td class="align-center">
        <p><code class="option">plugins_dir: [ DIR1,... ]</code></p>
        <p><code class="flag">-p, --plugins DIR1[,DIR2,...]</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Layouts</strong></p>
        <p class="description">Specify layout directory instead of using <code>_layouts/</code> automatically.</p>
      </td>
      <td class="align-center">
        <p><code class="option">layout_dir: DIR</code></p>
        <p><code class="flag">--layouts DIR</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Drafts</strong></p>
        <p class="description">Process and render draft posts.</p>
      </td>
      <td class="align-center">
        <p><code class="option">show_drafts: BOOL</code></p>
        <p><code class="flag">-D, --drafts</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Environment</strong></p>
        <p class="description">Use a specific environment value in the build.</p>
      </td>
      <td class="align-center">
        <p><code class="flag">JEKYLL_ENV=production</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Future</strong></p>
        <p class="description">Publish posts or collection documents with a future date.</p>
      </td>
      <td class="align-center">
        <p><code class="option">future: BOOL</code></p>
        <p><code class="flag">--future</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Unpublished</strong></p>
        <p class="description">Render posts that were marked as unpublished.</p>
      </td>
      <td class="align-center">
        <p><code class="option">unpublished: BOOL</code></p>
        <p><code class="flag">--unpublished</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>LSI</strong></p>
        <p class="description">Produce an index for related posts. Requires the
          <a href="https://jekyll.github.io/classifier-reborn/">classifier-reborn</a> plugin.</p>
      </td>
      <td class="align-center">
        <p><code class="option">lsi: BOOL</code></p>
        <p><code class="flag">--lsi</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Limit Posts</strong></p>
        <p class="description">Limit the number of posts to parse and publish.</p>
      </td>
      <td class="align-center">
        <p><code class="option">limit_posts: NUM</code></p>
        <p><code class="flag">--limit_posts NUM</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Force polling</strong></p>
        <p class="description">Force watch to use polling.</p>
      </td>
      <td class="align-center">
        <p><code class="option">force_polling: BOOL</code></p>
        <p><code class="flag">--force_polling</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Verbose output</strong></p>
        <p class="description">Print verbose output.</p>
      </td>
      <td class="align-center">
        <p><code class="flag">-V, --verbose</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Silence Output</strong></p>
        <p class="description">Silence the normal output from Jekyll
        during a build</p>
      </td>
      <td class="align-center">
        <p><code class="flag">-q, --quiet</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Incremental build</strong></p>
        <p class="description">
            Enable the experimental incremental build feature. Incremental build only
            re-builds posts and pages that have changed, resulting in significant performance
            improvements for large sites, but may also break site generation in certain
            cases.
        </p>
      </td>
      <td class="align-center">
        <p><code class="option">incremental: BOOL</code></p>
        <p><code class="flag">-I, --incremental</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Liquid profiler</strong></p>
        <p class="description">
            Generate a Liquid rendering profile to help you identify performance bottlenecks.
        </p>
      </td>
      <td class="align-center">
        <p><code class="option">profile: BOOL</code></p>
        <p><code class="flag">--profile</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Strict Front Matter</strong></p>
        <p class="description">
            Cause a build to fail if there is a YAML syntax error in a page's front matter.
        </p>
      </td>
      <td class="align-center">
        <p><code class="option">strict_front_matter: BOOL</code></p>
        <p><code class="flag">--strict_front_matter</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Base URL</strong></p>
        <p class="description">Serve the website from the given base URL.</p>
      </td>
      <td class="align-center">
        <p><code class="option">baseurl: URL</code></p>
        <p><code class="flag">-b, --baseurl URL</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Trace</strong></p>
        <p class="description">Show the full backtrace when an error occurs.</p>
      </td>
      <td class="align-center">
        <p><code class="flag">-t, --trace</code></p>
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
    <tr class="setting">
      <td>
        <p class="name"><strong>Local Server Port</strong></p>
        <p class="description">Listen on the given port.</p>
      </td>
      <td class="align-center">
        <p><code class="option">port: PORT</code></p>
        <p><code class="flag">-P, --port PORT</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Local Server Hostname</strong></p>
        <p class="description">Listen at the given hostname.</p>
      </td>
      <td class="align-center">
        <p><code class="option">host: HOSTNAME</code></p>
        <p><code class="flag">-H, --host HOSTNAME</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Live Reload</strong></p>
        <p class="description">Reload a page automatically on the browser when its content is edited.</p>
      </td>
      <td class="align-center">
        <p><code class="option">livereload: BOOL</code></p>
        <p><code class="flag">-l, --livereload</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Live Reload Ignore</strong></p>
        <p class="description">File glob patterns for LiveReload to ignore.</p>
      </td>
      <td class="align-center">
        <p><code class="option">livereload_ignore: [ GLOB1,... ]</code></p>
        <p><code class="flag">--livereload-ignore GLOB1[,GLOB2,...]</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Live Reload Min/Max Delay</strong></p>
        <p class="description">Minimum/Maximum delay before automatically reloading page.</p>
      </td>
      <td class="align-center">
        <p><code class="option">livereload_min_delay: SECONDS</code><br>
        <code class="option">livereload_max_delay: SECONDS</code></p>
        <p><code class="flag">--livereload-min-delay SECONDS</code><br>
        <code class="flag">--livereload-max-delay SECONDS</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Live Reload Port</strong></p>
        <p class="description">Port for LiveReload to listen on.</p>
      </td>
      <td class="align-center">
        <p><code class="flag">--livereload-port PORT</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Open URL</strong></p>
        <p class="description">Open the site's URL in the browser.</p>
      </td>
      <td class="align-center">
        <p><code class="option">open_url: BOOL</code></p>
        <p><code class="flag">-o, --open-url</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Detach</strong></p>
        <p class="description">Detach the server from the terminal.</p>
      </td>
      <td class="align-center">
        <p><code class="option">detach: BOOL</code></p>
        <p><code class="flag">-B, --detach</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>Skips the initial site build</strong></p>
        <p class="description">Skips the initial site build which occurs before the server is started.</p>
      </td>
      <td class="align-center">
        <p><code class="option">skip_initial_build: BOOL</code></p>
        <p><code class="flag">--skip-initial-build</code></p>
      </td>
    </tr>
        <tr class="setting">
      <td>
        <p class="name"><strong>Show Directory Listing</strong></p>
        <p class="description">Show a directory listing instead of loading your index file.</p>
      </td>
      <td class="align-center">
        <p><code class="option">show_dir_listing: BOOL</code></p>
        <p><code class="flag">--show-dir-listing</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>X.509 (SSL) Private Key</strong></p>
        <p class="description">SSL Private Key, stored or symlinked in the site source.</p>
      </td>
      <td class="align-center">
        <p><code class="flag">--ssl-key</code></p>
      </td>
    </tr>
    <tr class="setting">
      <td>
        <p class="name"><strong>X.509 (SSL) Certificate</strong></p>
        <p class="description">SSL Public certificate, stored or symlinked in the site source.</p>
      </td>
      <td class="align-center">
        <p><code class="flag">--ssl-cert</code></p>
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
