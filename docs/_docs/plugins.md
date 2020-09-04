---
title: Plugins
permalink: /docs/plugins/
---

Jekyll has a plugin system with hooks that allow you to create custom generated
content specific to your site. You can run custom code for your site without
having to modify the Jekyll source itself.

{: .note .info}
You can add specific plugins to the `whitelist` key in `_config.yml` to allow them to run in safe mode.

* [Installation]({{ '/docs/plugins/installation/' | relative_url }}) - How to install plugins
* [Your first plugin]({{ '/docs/plugins/your-first-plugin/' | relative_url }}) - How to write plugins
* [Generators]({{ '/docs/plugins/generators/' | relative_url }}) - Create additional content on your site
* [Converters]({{ '/docs/plugins/converters/' | relative_url }}) - Change a markup language into another format
* [Commands]({{ '/docs/plugins/commands/' | relative_url }}) - Extend the `jekyll` executable with subcommands
* [Tags]({{ '/docs/plugins/tags/' | relative_url }}) - Create custom Liquid tags
* [Filters]({{ '/docs/plugins/filters/' | relative_url }}) - Create custom Liquid filters
* [Hooks]({{ '/docs/plugins/hooks/' | relative_url }}) - Fine-grained control to extend the build process
