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
    {% for setting in site.data.config_options.build %}
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
          {% if setting.option %}<p><code class="option">{{ setting.option }}</code></p>{% endif %}
          {% if setting.flag %}<p><code class="flag">{{ setting.flag }}</code></p>{% endif %}
        </td>
      </tr>
    {% endfor %}
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
    {% for setting in site.data.config_options.serve %}
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
          {% if setting.option %}
            <p><code class="option">{{ setting.option }}</code></p>
          {% elsif setting.options %}
            <p>
              {% for option in setting.options %}
                <code class="option">{{ option }}</code><br>
              {% endfor %}
            </p>
          {% endif %}
          {% if setting.flag %}
            <p><code class="flag">{{ setting.flag }}</code></p>
          {% elsif setting.flags %}
            <p>
            {% for flag in setting.flags %}
              <code class="flag">{{ flag }}</code><br>
            {% endfor %}
            </p>
          {% endif %}
        </td>
      </tr>
    {% endfor %}
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
