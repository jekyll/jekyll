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

```sh
.
|-- about.md    # => http://example.com/about.html
|-- index.html    # => http://example.com/
└── contact.html  # => http://example.com/contact.html
```

If you have a lot of pages, you can organize them into subfolders. The same subfolders that are used to group your pages in your project's source will then exist in the `_site` folder when your site builds. However, when a page has a *different* permalink set in the front matter, the subfolder at `_site` changes accordingly.

```sh
.
|-- about.md          # => http://example.com/about.html
|-- documentation     # folder containing pages
    └── doc1.md       # => http://example.com/documentation/doc1.html
|-- design            # folder containing pages
    └── draft.md      # => http://example.com/design/draft.html
```

## Changing the output URL

You might want to have a particular folder structure for your source files that changes for the built site. With [permalinks](/docs/permalinks) you have full control of the output URL.
