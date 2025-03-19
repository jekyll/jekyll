# SEO Optimization Framework for Jekyll

The Jekyll SEO Optimization Framework provides a comprehensive set of tools to enhance the SEO of your Jekyll site. It includes content analysis, structured data generation, social media optimization, and enhanced sitemap generation.

## Features

- **Content Analysis**: Analyzes your content for readability, keyword usage, and SEO best practices.
- **Structured Data**: Automatically generates JSON-LD structured data for various content types.
- **Social Media**: Generates meta tags for Open Graph, Twitter Cards, and other social media platforms.
- **Sitemap**: Enhanced XML sitemap generation with customizable change frequency and priority settings.
- **Robots.txt**: Automatic generation of robots.txt file with configurable settings.

## Getting Started

### Basic Setup

No additional setup is required to use the basic features of the SEO Optimization Framework. It's enabled by default and will automatically generate sitemaps and analyze your content.

### Configuration

Add the following configuration to your `_config.yml` file to customize the SEO framework:

```yaml
# SEO Configuration
seo:
  # General settings
  auto_analyze: true     # Set to false to disable automatic content analysis
  generate_sitemap: true # Set to false to disable sitemap generation
  generate_robots: true  # Set to false to disable robots.txt generation

  # Sitemap settings
  sitemap:
    include_images: true          # Include images in the sitemap
    default_changefreq: "monthly" # Default change frequency
    static_files_changefreq: "monthly"
    static_files_priority: "0.3"
    exclude_extensions:  # Exclude files with these extensions
      - css
      - js
      - json
      - xml
      - scss
      - sass
    exclude_layouts:  # Exclude pages with these layouts
      - redirect
      - sitemap
      - feed

  # Robots.txt settings
  robots:
    include_sitemap: true
    disallow:  # Paths to disallow
      - /private/
      - /admin/

  # Social media settings
  twitter:
    username: "your_twitter_username"
  facebook:
    app_id: "your_facebook_app_id"
  pinterest:
    verification: "your_verification_code"
  linkedin:
    article_publisher: "your_linkedin_publisher_url"

  # Publisher information for structured data
  publisher:
    name: "Your Site Name"
    logo: "/assets/images/logo.png"
```

## Page Front Matter

You can control SEO settings at the page level using front matter:

```yaml
---
title: "Your Page Title"
description: "Your page description for SEO"
image: "/path/to/image.jpg"  # Featured image for social sharing
image_alt: "Image description for accessibility"
keywords:
  - keyword1
  - keyword2
  - keyword3
twitter_large_card: true  # Use large Twitter card
author: "Author Name"
author_twitter: "author_twitter_handle"
last_modified_at: 2023-01-01T12:00:00Z

# Schema.org type
schema_type: "Article"  # Overrides auto-detection of schema type

# Open Graph type
og_type: "article"  # Overrides auto-detection of OG type

# Sitemap settings
sitemap:
  changefreq: "weekly"
  priority: 0.8
  lastmod: 2023-01-01T12:00:00Z  # Manually set last modified date
---
```

## Using Liquid Tags

### Structured Data

Add structured data to your templates:

```liquid
{% structured_data %}
```

You can specify the schema type:

```liquid
{% structured_data BlogPosting %}
```

### Social Media Tags

Add social media tags to your templates:

```liquid
{% social_media_tags %}
```

### SEO Analysis

Display SEO analysis (useful in development or admin areas):

```liquid
{% seo_analysis %}
```

### Content Analysis

Display content analysis:

```liquid
{% content_analysis %}
```

### Sitemap Preview

Show a preview of your sitemap:

```liquid
{% sitemap_preview %}
```

### Sitemap URL

Get the URL to your sitemap:

```liquid
{% sitemap_url %}
```

## Using Liquid Filters

### Structured Data Generation

```liquid
{{ page | structured_data }}
```

### Social Media Tags

```liquid
{{ page | social_media_tags }}
```

### Readability Score

```liquid
{{ content | readability_score }}
```

### Extract Keywords

```liquid
{{ content | extract_keywords: 10 }}
```

### SEO-friendly Slugify

```liquid
{{ "Your String" | seo_slugify }}
```

## Advanced Schema Types

The SEO framework supports various schema.org types:

- **BlogPosting**: For blog posts
- **Article**: For general articles
- **WebPage**: For generic pages
- **ItemList**: For collection index pages
- **CollectionPage**: For collection pages
- **Person**: For person profiles
- **Organization**: For organization profiles
- **Product**: For product pages
- **FAQ**: For FAQ pages
- **HowTo**: For how-to guides

### Product Schema Example

```yaml
---
title: "Product Name"
layout: product
product:
  name: "Product Name"
  description: "Product description"
  price: 19.99
  currency: "USD"
  availability: "https://schema.org/InStock"
  sku: "SKU123"
  mpn: "MPN123"
  brand: "Brand Name"
  rating: 4.5
  review_count: 100
---
```

### FAQ Schema Example

```yaml
---
title: "Frequently Asked Questions"
layout: faq
faq:
  - question: "What is Jekyll?"
    answer: "Jekyll is a static site generator written in Ruby."
  - question: "What is SEO?"
    answer: "SEO, or Search Engine Optimization, is the process of improving your site to increase its visibility in search results."
---
```

### HowTo Schema Example

```yaml
---
title: "How to Build a Jekyll Site"
layout: howto
howto:
  name: "How to Build a Jekyll Site"
  description: "Learn how to build a Jekyll site from scratch"
  total_time: "PT1H30M"
  estimated_cost:
    currency: "USD"
    value: "0"
  supplies:
    - "Computer"
    - "Internet connection"
  tools:
    - "Text editor"
    - "Command line interface"
  steps:
    - name: "Install Ruby"
      text: "First, install Ruby on your computer"
    - name: "Install Jekyll"
      text: "Run 'gem install jekyll bundler' to install Jekyll"
    - name: "Create a new site"
      text: "Run 'jekyll new my-site' to create a new site"
---
```

## Testing Your SEO

You can test your SEO setup by running your site and checking:

1. View the source code to verify meta tags and structured data
2. Use [Google's Structured Data Testing Tool](https://search.google.com/structured-data/testing-tool)
3. Use [Google's Rich Results Test](https://search.google.com/test/rich-results)
4. Use [Facebook's Sharing Debugger](https://developers.facebook.com/tools/debug/)
5. Use [Twitter's Card Validator](https://cards-dev.twitter.com/validator)

## Best Practices

1. **Always provide meta descriptions**: They influence click-through rates in search results.
2. **Use featured images**: They improve social sharing appearance.
3. **Structure content with headings**: Use H1, H2, etc. to structure your content logically.
4. **Use keywords naturally**: Include relevant keywords but avoid keyword stuffing.
5. **Add alt text to images**: Improves accessibility and SEO.
6. **Create logical internal linking**: Connect related pages on your site.
7. **Update content regularly**: Fresh content signals to search engines that your site is active.

## Support

For more information about SEO optimization:

- [Google's SEO Starter Guide](https://developers.google.com/search/docs/beginner/seo-starter-guide)
- [Schema.org Documentation](https://schema.org/docs/gs.html)
- [Open Graph Protocol](https://ogp.me/)
- [Twitter Cards Documentation](https://developer.twitter.com/en/docs/twitter-for-websites/cards/overview/abouts-cards)
