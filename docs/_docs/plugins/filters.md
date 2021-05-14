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

For more details on creating custom Liquid Filters, head to the [Liquid docs](https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers#create-your-own-filters).

<div class="note">
  <h5>ProTip™: Access the site object using Liquid</h5>
  <p>
    Jekyll lets you access the <code>site</code> object through the
    <code>@context.registers</code> feature of Liquid at <code>@context.registers[:site]</code>. For example, you can
    access the global configuration file <code>_config.yml</code> using
    <code>@context.registers[:site].config</code>.
  </p>
</div>
