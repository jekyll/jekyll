---
title: Pages
permalink: /docs/pages/
---

Pages are the most basic building block for content. They're useful for standalone
content (content which is not date based or is not a group of content such as staff
members or recipes).

The simplest way of adding a page is to add an HTML file in the root
directory with a suitable filename. You can also write a page in Markdown using
a `.md` extension which converts to HTML on build. For a site with
a homepage, an about page, and a contact page, here’s what the root directory
and associated URLs might look like:

```
.
├── about.md    # => http://example.com/about.html
├── index.html    # => http://example.com/
└── contact.html  # => http://example.com/contact.html
```

If you have a lot of pages, you can organize them into subfolders. The same subfolders that are used to group your pages in your project's source will then exist in the `_site` folder when your site builds. However, when a page has a *different* permalink set in the front matter, the subfolder at `_site` changes accordingly.

```
.
├── about.md          # => http://example.com/about.html
├── documentation     # folder containing pages
│   └── doc1.md       # => http://example.com/documentation/doc1.html
├── design            # folder containing pages
│   └── draft.md      # => http://example.com/design/draft.html
```

## Changing the output URL

You might want to have a particular folder structure for your source files that changes for the built site. With [permalinks](/docs/permalinks) you have full control of the output URL.

## Liquid Representation

From Jekyll 4.1 onwards, there is a minor change in how instances of `Jekyll::Page` are exposed to layouts and other Liquid
templates. `Jekyll::Page` instances now use a `Liquid::Drop` instead of a `Hash`. This change results in greater performance
for a site with numerous *standlone pages not within a collection*.

### For plugin developers

While end-users do not need to take any extra action due to this change, plugin authors depending on the existing behavior *may*
need to make minor changes to their plugins.

If a `Jekyll::Page` subclass' `to_liquid` method calls `super`, it will have to be slightly modified.
```ruby
class Foo::BarPage < Jekyll::Page
  def to_liquid(*)
    payload = super        # This needs to be changed to `super.to_h`
                           # to obtain a Hash as in v4.0.0.

    do_something(payload)  # Logic specific to `Foo::BarPage` objects
  end
end
```

`Jekyll::Page` subclasses won't inherit the optimization automatically until the next major version. However, plugin authors
can opt-in to the optimization in their subclasses by wrapping the temporary `liquid_drop` method if the subclass doesn't
override the superclass method:
```ruby
class Foo::BarPage < Jekyll::Page
  def to_liquid(*)
    liquid_drop    # Returns an instance of `Jekyll::Drops::PageDrop`.
                   # Will be removed in Jekyll 5.0.
  end
end
```
