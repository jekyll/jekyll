---
title: Liquid Options
permalink: "/docs/configuration/liquid/"
---
Liquid's response to errors can be configured by setting `error_mode`. The
options are

- `lax` --- Ignore all errors.
- `warn` --- Output a warning on the console for each error.
- `strict` --- Output an error message and stop the build.

You can also configure Liquid's renderer to catch non-assigned variables and
non-existing filters by setting `strict_variables` and / or `strict_filters`
to `true` respectively. {% include docs_version_badge.html version="3.8.0" %}

Do note that while `error_mode` configures Liquid's parser, the `strict_variables`
and `strict_filters` options configure Liquid's renderer and are consequently,
mutually exclusive.
