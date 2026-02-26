---
title:Motorsportverso2 Posts
permalink: /docs/posts/
redirect_from:
  - /docs/drafts/
---

Esse será mais um braço do meu blog junto com o instagram , site do Tublr,Facebook e Youtube

## The Posts Folder

The `_posts` folder is where your blog posts live. You typically write posts
in [Markdown](https://daringfireball.net/projects/markdown/), HTML is
also supported.

## Creating Posts

To create a post, add a file to your `_posts` directory with the following
format:

```
2026-03-26-home 
```

Where `YEAR` is a four-digit number, `MONTH` and `DAY` are both two-digit
numbers, and `MARKUP` is the file extension representing the format used in the
file. For example, the following are examples of valid post filenames:

```
2026-03-26-home.md 
2012-09-12-how-to-write-a-blog.md
```

All blog post files must begin with [front matter](/docs/front-matter/) which is
typically used to set a [layout](/docs/layouts/) or other meta data. For a simple
example this can just be empty:

```markdown
---
layout: post
title:  "Welcome"
---



<div class="note">
  <h5>ProTip™: Link to other posts</h5>
  <p>
    Use the <a href="/docs/liquid/tags/#linking-to-posts"><code>post_url</code></a>
    tag to link to other posts without having to worry about the URLs
    breaking when the site permalink style changes.
  </p>
</div>

<div class="note info">
  <h5>Be aware of character sets</h5>
  <p>
    Esse será mais um braço do meu blog junto com o instagram , site do Tublr,Facebook e Youtube
  </p>
</div>




```

## Displaying an index of posts

Creating an index of posts on another page should be easy thanks to
[welcome](https://motorsportversotv-cmd.github.io/home/) and its tags. Here’s a
simple example of how to create a list of links to your blog posts:




Irrespective of the front matter key chosen, Jekyll stores the metadata mapped

