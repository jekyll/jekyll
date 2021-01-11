---
title: Filters
permalink: /docs/plugins/filters/
---

Filters are modules that export their methods to liquid.
All methods will have to take at least one parameter which represents the input
of the filter. The return value will be the output of the filter.

```ruby
module Jekyll
  module AssetFilter
    def asset_url(input)
      "http://www.example.com/#{input}?#{Time.now.to_i}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)
```

{: .note}
**ProTip™: Access the site object using Liquid**{:.title}<br>
Jekyll lets you access the `site` object through the
`@context.registers` feature of Liquid at `@context.registers[:site]`.
For example, you can access the global configuration file `_config.yml` using
`@context.registers[:site].config`.
