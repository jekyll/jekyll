---
title: Liquid Options
permalink: "/docs/configuration/liquid/"
---
Liquid's response to errors can be configured by setting `error_mode`. The
options are

- `lax` --- Ignore all errors.
- `warn` --- Output a warning on the console for each error. (default)
- `strict` --- Output an error message and stop the build.

Within _config.yml, the default configuration is as follows:

```yaml
liquid:
  error_mode: warn
```

The above example depicts the "warn" value, which is already set by default- `error_mode: warn`. This results in any issues being called out during the build process however will continue to build if possible.

You can also configure Liquid's renderer to catch non-assigned variables and
non-existing filters by setting `strict_variables` and / or `strict_filters`
to `true` respectively. {% include docs_version_badge.html version="3.8.0" %}

Do note that while `error_mode` configures Liquid's parser, the `strict_variables`
and `strict_filters` options configure Liquid's renderer and are consequently,
mutually exclusive.

An example of setting these variables within _config.yml is as follows:

```yaml
liquid:
  error_mode: strict
  strict_variables: true
  strict_filters: true
```

Configuring as described above will stop your build/serve from happening and call out the offending error and halt. This is helpful when desiring to catch liquid-related issues by stopping the build or serve process and allowing you to deal with any issues.
