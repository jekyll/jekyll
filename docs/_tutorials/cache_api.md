---
layout: tutorials
permalink: /tutorials/cache-api/
title: Cache API
published: false
---

Jekyll includes a caching API, which is used both internally as well as exposed
for plugins, which can be used to cache the output of deterministic functions to
speed up site generation. This cache will be persistent across builds, but
cleared when Jekyll detects any changes to `_config.yml`.

## Jekyll::Cache.new(name) → new_cache

If there has already been a cache created with `name`, this will return a
reference to that existing Cache. Otherwise, create a new Cache called `name`.

If this Cache will be used by a Gem-packaged plugin, `name` should either be the
name of the Gem, or prefixed with the name of the Gem followed by `::` (if a
plugin expects to use multiple Caches). If this Cache will be used internally by
Jekyll, `name` should be the name of the class that is using the Cache (ie:
`"Jekyll::Converters::Markdown"`).

Cached objects are shared between all Caches created with the same `name`, but
are _not_ shared between Caches with different names. There can be an object
stored with key `1` in `Jekyll::Cache.new("a")` and an object stored with key
`1` in `Jekyll::Cache.new("b")` and these will not point to the same cached
object. This way, you do not need to ensure that keys are globally unique.

## getset(key) {block}

This is the most common way to utilize the Cache.

`block` is a bit of code that takes a lot of time to compute, but always
generates the same output given a particular input (like converting Markdown to
HTML). `key` is a `String` (or an object with `to_s`) that uniquely identifies
the input to the function.

If `key` already exists in the Cache, it will be returned and `block` will never
be executed. If `key` does not exist in the Cache, `block` will be executed and
the result will be added to the Cache and returned.

```ruby
def cache
  @@cache ||= Jekyll::Cache.new("ConvertMarkdown")
end

def convert_markdown_to_html(markdown)
  cache.getset(markdown) do
    expensive_conversion_method(markdown)
  end
end
```

In the above example, `expensive_conversion_method` will only be called once for
any given `markdown` input. If `convert_markdown_to_html` is called a second
time with the same input, the cached output will be returned.

Because posts will frequently remain unchanged from one build to the next, this
is an effective way to avoid performing the same computations each time the site
is built.

## clear

This will clear all cached objects from a particular Cache. The Cache will be
empty, both in memory and on disk.


### The following methods will probably only be used in special circumstances

## cache[key] → value

Fetches `key` from Cache and returns its `value`. Raises if `key` does not exist
in Cache.

## cache[key] = value

Adds `value` to Cache under `key`.
Returns nothing.

## key?(key) → true or false

Returns `true` if `key` already exists in Cache. False otherwise.

## delete(key)

Removes `key` from Cache.
Returns nothing.
