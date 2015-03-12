---
layout: docs
title: History
permalink: "/docs/history/"
---

## 2.5.3 / 2014-12-22
{: #v2-5-3}

### Bug Fixes
{: #bug-fixes-v2-5-3}

- When checking a Markdown extname, include position of the `.` ([#3147]({{ site.repository }}/issues/3147))
- Fix `jsonify` Liquid filter handling of boolean values ([#3154]({{ site.repository }}/issues/3154))
- Add comma to value of `viewport` meta tag ([#3170]({{ site.repository }}/issues/3170))
- Set the link type for the RSS feed to `application/rss+xml` ([#3176]({{ site.repository }}/issues/3176))
- Refactor `#as_liquid` ([#3158]({{ site.repository }}/issues/3158))

### Development Fixes
{: #development-fixes-v2-5-3}

- Exclude built-in bundles from being added to coverage report ([#3180]({{ site.repository }}/issues/3180))

### Site Enhancements
{: #site-enhancements-v2-5-3}

- Add `[@alfredxing](https://github.com/alfredxing)` to the `[@jekyll](https://github.com/jekyll)/core` team. :tada: ([#3218]({{ site.repository }}/issues/3218))
- Document the `-q` option for the `build` and `serve` commands ([#3149]({{ site.repository }}/issues/3149))
- Fix some minor typos/flow fixes in documentation website content ([#3165]({{ site.repository }}/issues/3165))
- Add `keep_files` to configuration documentation ([#3162]({{ site.repository }}/issues/3162))
- Repeat warning about cleaning of the `destination` directory ([#3161]({{ site.repository }}/issues/3161))
- Add jekyll-500px-embed to list of third-party plugins ([#3163]({{ site.repository }}/issues/3163))
- Simplified platform detection in Gemfile example for Windows ([#3177]({{ site.repository }}/issues/3177))
- Add the `jekyll-jalali` plugin added to the list of third-party plugins. ([#3198]({{ site.repository }}/issues/3198))
- Add Table of Contents to Troubleshooting page ([#3196]({{ site.repository }}/issues/3196))
- Add `inline_highlight` plugin to list of third-party plugins ([#3212]({{ site.repository }}/issues/3212))
- Add `jekyll-mermaid` plugin to list of third-party plugins ([#3222]({{ site.repository }}/issues/3222))


## 2.5.2 / 2014-11-17
{: #v2-5-2}

### Minor Enhancements
{: #minor-enhancements-v2-5-2}

- `post_url` should match `post.name` instead of slugs and dates ([#3058]({{ site.repository }}/issues/3058))

### Bug Fixes
{: #bug-fixes-v2-5-2}

- Fix bundle require for `:jekyll_plugins` ([#3119]({{ site.repository }}/issues/3119))
- Remove duplicate regexp phrase: `^\A` ([#3089]({{ site.repository }}/issues/3089))
- Remove duplicate `Conversion error:` message in `Convertible` ([#3088]({{ site.repository }}/issues/3088))
- Print full conversion error message in `Renderer#convert` ([#3090]({{ site.repository }}/issues/3090))

### Site Enhancements
{: #site-enhancements-v2-5-2}

- Change variable names in Google Analytics script ([#3093]({{ site.repository }}/issues/3093))
- Mention CSV files in the docs for data files ([#3101]({{ site.repository }}/issues/3101))
- Add trailing slash to `paginate_path` example. ([#3091]({{ site.repository }}/issues/3091))
- Get rid of noifniof (`excerpt_separator`) ([#3094]({{ site.repository }}/issues/3094))
- Sass improvements, around nesting mostly. ([#3123]({{ site.repository }}/issues/3123))
- Add webmentions.io plugin to the list of third-party plugins ([#3127]({{ site.repository }}/issues/3127))
- Add Sass mixins and use them. ([#2904]({{ site.repository }}/issues/2904))
- Slightly compress jekyll-sticker.jpg. ([#3133]({{ site.repository }}/issues/3133))
- Update gridism and separate out related but custom styles. ([#3132]({{ site.repository }}/issues/3132))
- Add remote-include plugin to list of third-party plugins ([#3136]({{ site.repository }}/issues/3136))


## 2.5.1 / 2014-11-09
{: #v2-5-1}

### Bug Fixes
{: #bug-fixes-v2-5-1}

- Fix path sanitation bug related to Windows drive names ([#3077]({{ site.repository }}/issues/3077))

### Development Fixes
{: #development-fixes-v2-5-1}

- Add development time dependencies on minitest and test-unit to gemspec for cygwin ([#3064]({{ site.repository }}/issues/3064))
- Use Travis's built-in caching. ([#3075]({{ site.repository }}/issues/3075))


## 2.5.0 / 2014-11-06
{: #v2-5-0}

### Minor Enhancements
{: #minor-enhancements-v2-5-0}

- Require gems in `:jekyll_plugins` Gemfile group unless `JEKYLL_NO_BUNDLER_REQUIRE` is specified in the environment. ([#2865]({{ site.repository }}/issues/2865))
- Centralize path sanitation in the `Site` object ([#2882]({{ site.repository }}/issues/2882))
- Allow placeholders in permalinks ([#3031]({{ site.repository }}/issues/3031))
- Allow users to specify the log level via `JEKYLL_LOG_LEVEL`. ([#3067]({{ site.repository }}/issues/3067))
- Fancy Indexing with WEBrick ([#3018]({{ site.repository }}/issues/3018))
- Allow Enumerables to be used with `where` filter. ([#2986]({{ site.repository }}/issues/2986))
- Meta descriptions in the site template now use `page.excerpt` if it's available ([#2964]({{ site.repository }}/issues/2964))
- Change indentation in `head.html` of site template to 2 spaces from 4 ([#2973]({{ site.repository }}/issues/2973))
- Use a `$content-width` variable instead of a fixed value in the site template CSS ([#2972]({{ site.repository }}/issues/2972))
- Strip newlines in site template `<meta>` description. ([#2982]({{ site.repository }}/issues/2982))
- Add link to atom feed in `head` of site template files ([#2996]({{ site.repository }}/issues/2996))
- Performance optimizations ([#2994]({{ site.repository }}/issues/2994))
- Use `Hash#each_key` instead of `Hash#keys.each` to speed up iteration
    over hash keys. ([#3017]({{ site.repository }}/issues/3017))
- Further minor performance enhancements. ([#3022]({{ site.repository }}/issues/3022))
- Add 'b' and 's' aliases for build and serve, respectively ([#3065]({{ site.repository }}/issues/3065))

### Bug Fixes
{: #bug-fixes-v2-5-0}

- Fix Rouge's RedCarpet plugin interface integration ([#2951]({{ site.repository }}/issues/2951))
- Remove `--watch` from the site template blog post since it defaults
    to watching in in 2.4.0 ([#2922]({{ site.repository }}/issues/2922))
- Fix code for media query mixin in site template ([#2946]({{ site.repository }}/issues/2946))
- Allow post URL's to have `.htm` extensions ([#2925]({{ site.repository }}/issues/2925))
- `Utils.slugify`: Don't create new objects when gsubbing ([#2997]({{ site.repository }}/issues/2997))
- The jsonify filter should deep-convert to Liquid when given an Array. ([#3032]({{ site.repository }}/issues/3032))
- Apply `jsonify` filter to Hashes deeply and effectively ([#3063]({{ site.repository }}/issues/3063))
- Use `127.0.0.1` as default host instead of `0.0.0.0` ([#3053]({{ site.repository }}/issues/3053))
- In the case that a Gemfile does not exist, ensure Jekyll doesn't fail on requiring the Gemfile group ([#3066]({{ site.repository }}/issues/3066))

### Development Fixes
{: #development-fixes-v2-5-0}

- Fix a typo in the doc block for `Jekyll::URL.escape_path` ([#3052]({{ site.repository }}/issues/3052))
- Add integration test for `jekyll new --blank` in TestUnit ([#2913]({{ site.repository }}/issues/2913))
- Add unit test for `jekyll new --force` logic ([#2929]({{ site.repository }}/issues/2929))
- Update outdated comment for `Convertible#transform` ([#2957]({{ site.repository }}/issues/2957))
- Add Hakiri badge to README. ([#2953]({{ site.repository }}/issues/2953))
- Add some simple benchmarking tools. ([#2993]({{ site.repository }}/issues/2993))

### Site Enhancements
{: #site-enhancements-v2-5-0}

- `NOKOGIRI_USE_SYSTEM_LIBRARIES=true` **decreases** installation time. ([#3040]({{ site.repository }}/issues/3040))
- Add FormKeep to resources as Jekyll form backend ([#3010]({{ site.repository }}/issues/3010))
- Fixing a mistake in the name of the new Liquid tag ([#2969]({{ site.repository }}/issues/2969))
- Update Font Awesome to v4.2.0. ([#2898]({{ site.repository }}/issues/2898))
- Fix link to [#2895]({{ site.repository }}/issues/2895) in 2.4.0 release post. ([#2899]({{ site.repository }}/issues/2899))
- Add Big Footnotes for Kramdown plugin to list of third-party plugins ([#2916]({{ site.repository }}/issues/2916))
- Remove warning regarding GHP use of singular types for front matter defaults ([#2919]({{ site.repository }}/issues/2919))
- Fix quote character typo in site documentation for templates ([#2917]({{ site.repository }}/issues/2917))
- Point Liquid links to Liquid’s Github wiki ([#2887]({{ site.repository }}/issues/2887))
- Add HTTP Basic Auth (.htaccess) plugin to list of third-party plugins ([#2931]({{ site.repository }}/issues/2931))
- (Minor) Grammar & `_config.yml` filename fixes ([#2911]({{ site.repository }}/issues/2911))
- Added `mathml.rb` to the list of third-party plugins. ([#2937]({{ site.repository }}/issues/2937))
- Add `--force_polling` to the list of configuration options ([#2943]({{ site.repository }}/issues/2943))
- Escape unicode characters in site CSS ([#2906]({{ site.repository }}/issues/2906))
- Add note about using the github-pages gem via pages.github.com/versions.json ([#2939]({{ site.repository }}/issues/2939))
- Update usage documentation to reflect 2.4 auto-enabling of `--watch`. ([#2954]({{ site.repository }}/issues/2954))
- Add `--skip-initial-build` to configuration docs ([#2949]({{ site.repository }}/issues/2949))
- Fix a minor typo in Templates docs page ([#2959]({{ site.repository }}/issues/2959))
- Add a ditaa-ditaa plugin under Other section on the Plugins page ([#2967]({{ site.repository }}/issues/2967))
- Add `build/serve -V` option to configuration documentation ([#2948]({{ site.repository }}/issues/2948))
- Add 'Jekyll Twitter Plugin' to list of third-party plugins ([#2979]({{ site.repository }}/issues/2979))
- Docs: Update normalize.css to v3.0.2. ([#2981]({{ site.repository }}/issues/2981))
- Fix typo in Continuous Integration documentation ([#2984]({{ site.repository }}/issues/2984))
- Clarify behavior of `:categories` in permalinks ([#3011]({{ site.repository }}/issues/3011))


## 2.4.0 / 2014-09-09
{: #v2-4-0}

### Minor Enhancements
{: #minor-enhancements-v2-4-0}

- Support a new `relative_include` tag ([#2870]({{ site.repository }}/issues/2870))
- Auto-enable watch on 'serve' ([#2858]({{ site.repository }}/issues/2858))
- Render Liquid in CoffeeScript files ([#2830]({{ site.repository }}/issues/2830))
- Array Liquid filters: `push`, `pop`, `unshift`, `shift` ([#2895]({{ site.repository }}/issues/2895))
- Add `:title` to collection URL template fillers ([#2864]({{ site.repository }}/issues/2864))
- Add support for CSV files in the `_data` directory ([#2761]({{ site.repository }}/issues/2761))
- Add the `name` variable to collection permalinks ([#2799]({{ site.repository }}/issues/2799))
- Add `inspect` liquid filter. ([#2867]({{ site.repository }}/issues/2867))
- Add a `slugify` Liquid filter ([#2880]({{ site.repository }}/issues/2880))

### Bug Fixes
{: #bug-fixes-v2-4-0}

- Use `Jekyll.sanitized_path` when adding static files to Collections ([#2849]({{ site.repository }}/issues/2849))
- Fix encoding of `main.scss` in site template ([#2771]({{ site.repository }}/issues/2771))
- Fix orientation bugs in default site template ([#2862]({{ site.repository }}/issues/2862))

### Development Fixes
{: #development-fixes-v2-4-0}

- Update simplecov gem to 0.9 ([#2748]({{ site.repository }}/issues/2748))
- Remove `docs/` dir ([#2768]({{ site.repository }}/issues/2768))
- add class `<< self` idiom to `New` command ([#2817]({{ site.repository }}/issues/2817))
- Allow Travis to 'parallelize' our tests ([#2859]({{ site.repository }}/issues/2859))
- Fix test for Liquid rendering in Sass ([#2856]({{ site.repository }}/issues/2856))
- Fixing "vertycal" typo in site template's `_base.scss` ([#2889]({{ site.repository }}/issues/2889))

### Site Enhancements
{: #site-enhancements-v2-4-0}

- Document the `name` variable for collection permalinks ([#2829]({{ site.repository }}/issues/2829))
- Adds info about installing jekyll in current dir ([#2839]({{ site.repository }}/issues/2839))
- Remove deprecated `jekyll-projectlist` plugin from list of third-party
    plugins ([#2742]({{ site.repository }}/issues/2742))
- Remove tag plugins that are built in to Jekyll ([#2751]({{ site.repository }}/issues/2751))
- Add `markdown-writer` package for Atom Editor to list of third-party
    plugins ([#2763]({{ site.repository }}/issues/2763))
- Fix typo in site documentation for collections ([#2764]({{ site.repository }}/issues/2764))
- Fix minor typo on plugins docs page ([#2765]({{ site.repository }}/issues/2765))
- Replace markdown with HTML in `sass_dir` note on assets page ([#2791]({{ site.repository }}/issues/2791))
- Fixed "bellow" typo in datafiles docs ([#2879]({{ site.repository }}/issues/2879))
- Fix code/markdown issue in documentation for variables ([#2877]({{ site.repository }}/issues/2877))
- Remove Good Include third-party plugin from plugins page ([#2881]({{ site.repository }}/issues/2881))
- Add some more docs on `include_relative` ([#2884]({{ site.repository }}/issues/2884))


## 2.3.0 / 2014-08-10
{: #v2-3-0}

### Minor Enhancements
{: #minor-enhancements-v2-3-0}

- Allow Convertibles to be converted by >= 1 converters ([#2704]({{ site.repository }}/issues/2704))
- Allow Sass files to be rendered in Liquid, but never place them in layouts. ([#2733]({{ site.repository }}/issues/2733))
- Add `jekyll help` command ([#2707]({{ site.repository }}/issues/2707))
- Use `.scss` for `site_template` styles. ([#2667]({{ site.repository }}/issues/2667))
- Don't require the `scope` key in front matter defaults ([#2659]({{ site.repository }}/issues/2659))
- No longer set `permalink: pretty` in the `_config.yml` for the site template ([#2680]({{ site.repository }}/issues/2680))
- Rework site template to utilize Sass ([#2687]({{ site.repository }}/issues/2687))
- Notify the user when auto-regeneration is disabled. ([#2696]({{ site.repository }}/issues/2696))
- Allow partial variables in include tag filename argument ([#2693]({{ site.repository }}/issues/2693))
- Move instances of `Time.parse` into a Utils method ([#2682]({{ site.repository }}/issues/2682))
- Ignore subfolders in the `_posts` folder ([#2705]({{ site.repository }}/issues/2705)) REVERTS ([#2633]({{ site.repository }}/issues/2633))
- Front Matter default types should always be pluralized ([#2732]({{ site.repository }}/issues/2732))
- Read in static files into `collection.files` as `StaticFile`s ([#2737]({{ site.repository }}/issues/2737))
- Add `sassify` and `scssify` Liquid filters ([#2739]({{ site.repository }}/issues/2739))
- Replace `classifier` gem with `classifier-reborn` ([#2721]({{ site.repository }}/issues/2721))

### Bug Fixes
{: #bug-fixes-v2-3-0}

- Use only the last extname when multiple converters exist ([#2722]({{ site.repository }}/issues/2722))
- Call `#to_liquid` before calling `#to_json` in jsonify filter ([#2729]({{ site.repository }}/issues/2729))
- Use non padded config in `strftime` to avoid parse string twice ([#2673]({{ site.repository }}/issues/2673))
- Replace deprecated Ruby methods with undeprecated ones ([#2664]({{ site.repository }}/issues/2664))
- Catch errors when parsing Post `date` front matter value & produce nice error message ([#2649]({{ site.repository }}/issues/2649))
- Allow static files in Collections ([#2615]({{ site.repository }}/issues/2615))
- Fixed typo in `Deprecator#gracefully_require` error message ([#2694]({{ site.repository }}/issues/2694))
- Remove preemptive loading of the 'classifier' gem. ([#2697]({{ site.repository }}/issues/2697))
- Use case-insensitive checking for the file extensions when loading config files ([#2718]({{ site.repository }}/issues/2718))
- When Reading Documents, Respect `encoding` Option ([#2720]({{ site.repository }}/issues/2720))
- Refactor based on jekyll-watch clean-up. ([#2716]({{ site.repository }}/issues/2716))
- `Document#to_s` should produce just the content of the document ([#2731]({{ site.repository }}/issues/2731))

### Development Fixes
{: #development-fixes-v2-3-0}

- Only include lib files in the gem ([#2671]({{ site.repository }}/issues/2671))
- Fix `git diff` command in `proof` script ([#2672]({{ site.repository }}/issues/2672))
- Make default rake task a multitask so tests run in parallel ([#2735]({{ site.repository }}/issues/2735))

### Site Enhancements
{: #site-enhancements-v2-3-0}

- Use Sass and a Docs Collection ([#2651]({{ site.repository }}/issues/2651))
- Add `latest_version.txt` file to the site ([#2740]({{ site.repository }}/issues/2740))
- Be more ambiguous about `page.content`. But more transparent. ([#2522]({{ site.repository }}/issues/2522))
- Streamlining front matter wording (instead of front-matter/frontmatter) ([#2674]({{ site.repository }}/issues/2674))
- Add note that source directory cannot be modified in GitHub Pages ([#2669]({{ site.repository }}/issues/2669))
- Fix links from [#2669]({{ site.repository }}/issues/2669) to be actual HTML. Whoops. ([#2679]({{ site.repository }}/issues/2679))
- Add link to `jekyll-slim` in list of third-party plugins ([#2689]({{ site.repository }}/issues/2689))
- Add Barry Clark's Smashing Magazine tutorial to resources page ([#2688]({{ site.repository }}/issues/2688))
- Reorganize and update default configuration settings ([#2456]({{ site.repository }}/issues/2456))
- Fixing indentation in the configuration docs about Redcarpet exts ([#2717]({{ site.repository }}/issues/2717))
- Use `null` in YAML instead of `nil` in default config list ([#2719]({{ site.repository }}/issues/2719))
- Fix typo in Continuous Integration docs ([#2708]({{ site.repository }}/issues/2708))


## 2.2.0 / 2014-07-29
{: #v2-2-0}

### Minor Enhancements
{: #minor-enhancements-v2-2-0}

- Throw a warning if the specified layout does not exist ([#2620]({{ site.repository }}/issues/2620))
- Whitelist Pygments options in safe mode ([#2642]({{ site.repository }}/issues/2642))

### Bug Fixes
{: #bug-fixes-v2-2-0}

- Remove unnecessary `Jekyll::Tags::IncludeTag#blank?` method ([#2625]({{ site.repository }}/issues/2625))
- Categories in the path are ignored ([#2633]({{ site.repository }}/issues/2633))

### Development Fixes
{: #development-fixes-v2-2-0}

- Refactoring Errors & Requires of Third-Party stuff ([#2591]({{ site.repository }}/issues/2591))
- Add further tests for categories ([#2584]({{ site.repository }}/issues/2584))
- Proof site with html-proofer on change ([#2605]({{ site.repository }}/issues/2605))
- Fix up bug in [#2605]({{ site.repository }}/issues/2605) which caused proofing the site not to function ([#2608]({{ site.repository }}/issues/2608))
- Use `bundle exec` in `script/proof` ([#2610]({{ site.repository }}/issues/2610))

### Site Enhancements
{: #site-enhancements-v2-2-0}

- Update Kramdown urls ([#2588]({{ site.repository }}/issues/2588))
- Add `Jekyll::AutolinkEmail` and `Jekyll::GitMetadata` to the list of
    third-party plugins ([#2596]({{ site.repository }}/issues/2596))
- Fix a bunch of broken links in the site ([#2601]({{ site.repository }}/issues/2601))
- Replace dead links with working links ([#2611]({{ site.repository }}/issues/2611))
- Add jekyll-hook to deployment methods ([#2617]({{ site.repository }}/issues/2617))
- Added kramdown-with-pygments plugin to the list of third-party plugins ([#2623]({{ site.repository }}/issues/2623))
- Update outdated "Extras" page and remove duplicate documentation ([#2622]({{ site.repository }}/issues/2622))
- Add co2 plugin to list of third-party plugins ([#2639]({{ site.repository }}/issues/2639))
- Attempt to clarify the way Sass imports happen ([#2642]({{ site.repository }}/issues/2642))


## 2.1.1 / 2014-07-01
{: #v2-1-1}

### Bug Fixes
{: #bug-fixes-v2-1-1}

- Patch read vulnerabilities for data & confirm none for layouts ([#2563]({{ site.repository }}/issues/2563))
- Update Maruku dependency to allow use of the latest version ([#2576]({{ site.repository }}/issues/2576))
- Remove conditional assignment from document URL to prevent stale urls ([#2575]({{ site.repository }}/issues/2575))

### Site Enhancements
{: #site-enhancements-v2-1-1}

- Add vertical margin to `highlight` to separate code blocks ([#2558]({{ site.repository }}/issues/2558))
- Add `html_pages` to Variables docs ([#2567]({{ site.repository }}/issues/2567))
- Fixed broken link to Permalinks page ([#2572]({{ site.repository }}/issues/2572))
- Update link to Windows installation guide ([#2578]({{ site.repository }}/issues/2578))


## 2.1.0 / 2014-06-28
{: #v2-1-0}

### Minor Enhancements
{: #minor-enhancements-v2-1-0}

- Bump to the latest Liquid version, 2.6.1 ([#2495]({{ site.repository }}/issues/2495))
- Add support for JSON files in the `_data` directory ([#2369]({{ site.repository }}/issues/2369))
- Allow subclasses to override `EXCERPT_ATTRIBUTES_FOR_LIQUID` ([#2408]({{ site.repository }}/issues/2408))
- Add `Jekyll.env` and `jekyll.environment` (the Liquid var) ([#2417]({{ site.repository }}/issues/2417))
- Use `_config.yaml` or `_config.yml` (`.yml` takes precedence) ([#2406]({{ site.repository }}/issues/2406))
- Override collection url template ([#2418]({{ site.repository }}/issues/2418))
- Allow subdirectories in `_data` ([#2395]({{ site.repository }}/issues/2395))
- Extract Pagination Generator into gem: `jekyll-paginate` ([#2455]({{ site.repository }}/issues/2455))
- Utilize `date_to_rfc822` filter in site template ([#2437]({{ site.repository }}/issues/2437))
- Add categories, last build datetime, and generator to site template
    feed ([#2438]({{ site.repository }}/issues/2438))
- Configurable, replaceable Logger-compliant logger ([#2444]({{ site.repository }}/issues/2444))
- Extract `gist` tag into a separate gem ([#2469]({{ site.repository }}/issues/2469))
- Add `collection` attribute to `Document#to_liquid` to access the
    document's collection label. ([#2436]({{ site.repository }}/issues/2436))
- Upgrade listen to `2.7.6 <= x < 3.0.0` ([#2492]({{ site.repository }}/issues/2492))
- Allow configuration of different Twitter and GitHub usernames in site template ([#2485]({{ site.repository }}/issues/2485))
- Bump Pygments to v0.6.0 ([#2504]({{ site.repository }}/issues/2504))
- Front matter defaults for documents in collections ([#2419]({{ site.repository }}/issues/2419))
- Include files with a url which ends in `/` in the `site.html_pages` list ([#2524]({{ site.repository }}/issues/2524))
- Make `highlight` tag use `language-` prefix in CSS class ([#2511]({{ site.repository }}/issues/2511))
- Lookup item property via `item#to_liquid` before `#data` or `#[]` in filters ([#2493]({{ site.repository }}/issues/2493))
- Skip initial build of site on serve with flag ([#2477]({{ site.repository }}/issues/2477))
- Add support for `hl_lines` in `highlight` tag ([#2532]({{ site.repository }}/issues/2532))
- Spike out `--watch` flag into a separate gem ([#2550]({{ site.repository }}/issues/2550))

### Bug Fixes
{: #bug-fixes-v2-1-0}

- Liquid `sort` filter should sort even if one of the values is `nil` ([#2345]({{ site.repository }}/issues/2345))
- Remove padding on `pre code` in the site template CSS ([#2383]({{ site.repository }}/issues/2383))
- Set `log_level` earlier to silence info level configuration output ([#2393]({{ site.repository }}/issues/2393))
- Only list pages which have `title` in site template ([#2411]({{ site.repository }}/issues/2411))
- Accept `Numeric` values for dates, not `Number` values ([#2377]({{ site.repository }}/issues/2377))
- Prevent code from overflowing container in site template ([#2429]({{ site.repository }}/issues/2429))
- Encode URLs in UTF-8 when escaping and unescaping ([#2420]({{ site.repository }}/issues/2420))
- No Layouts or Liquid for Asset Files ([#2431]({{ site.repository }}/issues/2431))
- Allow front matter defaults to set post categories ([#2373]({{ site.repository }}/issues/2373))
- Fix command in subcommand deprecation warning ([#2457]({{ site.repository }}/issues/2457))
- Keep all parent directories of files/dirs in `keep_files` ([#2458]({{ site.repository }}/issues/2458))
- When using RedCarpet and Rouge without Rouge installed, fixed erroneous
    error which stated that redcarpet was missing, not rouge. ([#2464]({{ site.repository }}/issues/2464))
- Ignore *all* directories and files that merit it on auto-generation ([#2459]({{ site.repository }}/issues/2459))
- Before copying file, explicitly remove the old one ([#2535]({{ site.repository }}/issues/2535))
- Merge file system categories with categories from YAML. ([#2531]({{ site.repository }}/issues/2531))
- Deep merge front matter defaults ([#2490]({{ site.repository }}/issues/2490))
- Ensure exclude and include arrays are arrays of strings ([#2542]({{ site.repository }}/issues/2542))
- Allow collections to have dots in their filenames ([#2552]({{ site.repository }}/issues/2552))
- Collections shouldn't try to read in directories as files ([#2552]({{ site.repository }}/issues/2552))
- Be quiet very quickly. ([#2520]({{ site.repository }}/issues/2520))

### Development Fixes
{: #development-fixes-v2-1-0}

- Test Ruby 2.1.2 instead of 2.1.1 ([#2374]({{ site.repository }}/issues/2374))
- Add test for sorting UTF-8 characters ([#2384]({{ site.repository }}/issues/2384))
- Use `https` for GitHub links in documentation ([#2470]({{ site.repository }}/issues/2470))
- Remove coverage reporting with Coveralls ([#2494]({{ site.repository }}/issues/2494))
- Fix a bit of missing TomDoc to `Jekyll::Commands::Build#build` ([#2554]({{ site.repository }}/issues/2554))

### Site Enhancements
{: #site-enhancements-v2-1-0}

- Set `timezone` to `America/Los_Angeles` ([#2394]({{ site.repository }}/issues/2394))
- Improve JavaScript in `anchor_links.html` ([#2368]({{ site.repository }}/issues/2368))
- Remove note on Quickstart page about default markdown converter ([#2387]({{ site.repository }}/issues/2387))
- Remove broken link in extras.md to a Maruku fork ([#2401]({{ site.repository }}/issues/2401))
- Update Font Awesome to v4.1.0. ([#2410]({{ site.repository }}/issues/2410))
- Fix broken link on Installation page to Templates page ([#2421]({{ site.repository }}/issues/2421))
- Prevent table from extending parent width in permalink style table ([#2424]({{ site.repository }}/issues/2424))
- Add collections to info about pagination support ([#2389]({{ site.repository }}/issues/2389))
- Add `jekyll_github_sample` plugin to list of third-party plugins ([#2463]({{ site.repository }}/issues/2463))
- Clarify documentation around front matter defaults and add details
    about defaults for collections. ([#2439]({{ site.repository }}/issues/2439))
- Add Jekyll Project Version Tag to list of third-party plugins ([#2468]({{ site.repository }}/issues/2468))
- Use `https` for GitHub links across whole site ([#2470]({{ site.repository }}/issues/2470))
- Add StickerMule + Jekyll post ([#2476]({{ site.repository }}/issues/2476))
- Add Jekyll Asset Pipeline Reborn to list of third-party plugins ([#2479]({{ site.repository }}/issues/2479))
- Add link to jekyll-compress-html to list of third-party plugins ([#2514]({{ site.repository }}/issues/2514))
- Add Piwigo Gallery to list of third-party plugins ([#2526]({{ site.repository }}/issues/2526))
- Set `show_drafts` to `false` in default configuration listing ([#2536]({{ site.repository }}/issues/2536))
- Provide an updated link for Windows installation instructions ([#2544]({{ site.repository }}/issues/2544))
- Remove `url` from configuration docs ([#2547]({{ site.repository }}/issues/2547))
- Documentation for Continuous Integration for your Jekyll Site ([#2432]({{ site.repository }}/issues/2432))


## 2.0.3 / 2014-05-08
{: #v2-0-3}

### Bug Fixes
{: #bug-fixes-v2-0-3}

- Properly prefix links in site template with URL or baseurl depending upon
    need. ([#2319]({{ site.repository }}/issues/2319))
- Update gist tag comments and error message to require username ([#2326]({{ site.repository }}/issues/2326))
- Fix `permalink` setting in site template ([#2331]({{ site.repository }}/issues/2331))
- Don't fail if any of the path objects are nil ([#2325]({{ site.repository }}/issues/2325))
- Instantiate all descendants for converters and generators, not just
    direct subclasses ([#2334]({{ site.repository }}/issues/2334))
- Replace all instances of `site.name` with `site.title` in site template ([#2324]({{ site.repository }}/issues/2324))
- `Jekyll::Filters#time` now accepts UNIX timestamps in string or number form ([#2339]({{ site.repository }}/issues/2339))
- Use `item_property` for `where` filter so it doesn't break on collections ([#2359]({{ site.repository }}/issues/2359))
- Rescue errors thrown so `--watch` doesn't fail ([#2364]({{ site.repository }}/issues/2364))

### Site Enhancements
{: #site-enhancements-v2-0-3}

- Add missing "as" to assets docs page ([#2337]({{ site.repository }}/issues/2337))
- Update docs to reflect new `baseurl` default ([#2341]({{ site.repository }}/issues/2341))
- Add links to headers who have an ID. ([#2342]({{ site.repository }}/issues/2342))
- Use symbol instead of HTML number in `upgrading.md` ([#2351]({{ site.repository }}/issues/2351))
- Fix link to front matter defaults docs ([#2353]({{ site.repository }}/issues/2353))
- Fix for `History.markdown` in order to fix history page in docs ([#2363]({{ site.repository }}/issues/2363))


## 2.0.2 / 2014-05-07
{: #v2-0-2}

### Bug Fixes
{: #bug-fixes-v2-0-2}

- Correct use of `url` and `baseurl` in the site template. ([#2317]({{ site.repository }}/issues/2317))
- Default `baseurl` to `""` ([#2317]({{ site.repository }}/issues/2317))

### Site Enhancements
{: #site-enhancements-v2-0-2}

- Correct docs for the `gist` plugin so it always includes the username. ([#2314]({{ site.repository }}/issues/2314))
- Clarify new (defaults, `where` filter) features in docs ([#2316]({{ site.repository }}/issues/2316))


## 2.0.1 / 2014-05-06
{: #v2-0-1}

### Bug Fixes
{: #bug-fixes-v2-0-1}

- Require `kramdown` gem instead of `maruku` gem


## 2.0.0 / 2014-05-06
{: #v2-0-0}

### Major Enhancements
{: #major-enhancements-v2-0-0}
- Add "Collections" feature ([#2199]({{ site.repository }}/issues/2199))
- Add gem-based plugin whitelist to safe mode ([#1657]({{ site.repository }}/issues/1657))
- Replace the commander command line parser with a more robust
    solution for our needs called `mercenary` ([#1706]({{ site.repository }}/issues/1706))
- Remove support for Ruby 1.8.x ([#1780]({{ site.repository }}/issues/1780))
- Move to jekyll/jekyll from mojombo/jekyll ([#1817]({{ site.repository }}/issues/1817))
- Allow custom markdown processors ([#1872]({{ site.repository }}/issues/1872))
- Provide support for the Rouge syntax highlighter ([#1859]({{ site.repository }}/issues/1859))
- Provide support for Sass ([#1932]({{ site.repository }}/issues/1932))
- Provide a 300% improvement when generating sites that use
    `Post#next` or `Post#previous` ([#1983]({{ site.repository }}/issues/1983))
- Provide support for CoffeeScript ([#1991]({{ site.repository }}/issues/1991))
- Replace Maruku with Kramdown as Default Markdown Processor ([#1988]({{ site.repository }}/issues/1988))
- Expose `site.static_files` to Liquid ([#2075]({{ site.repository }}/issues/2075))
- Complete redesign of the template site generated by `jekyll new` ([#2050]({{ site.repository }}/issues/2050))
- Update Listen from 1.x to 2.x ([#2097]({{ site.repository }}/issues/2097))
- Front matter defaults ([#2205]({{ site.repository }}/issues/2205))
- Deprecate `relative_permalinks` configuration option (default to `false`) ([#2307]({{ site.repository }}/issues/2307))
- Exclude files based on prefix as well as `fnmatch?` ([#2303]({{ site.repository }}/issues/2303))

### Minor Enhancements
{: #minor-enhancements-v2-0-0}
- Move the EntryFilter class into the Jekyll module to avoid polluting the
    global namespace ([#1800]({{ site.repository }}/issues/1800))
- Add `group_by` Liquid filter create lists of items grouped by a common
    property's value ([#1788]({{ site.repository }}/issues/1788))
- Add support for Maruku's `fenced_code_blocks` option ([#1799]({{ site.repository }}/issues/1799))
- Update Redcarpet dependency to ~> 3.0 ([#1815]({{ site.repository }}/issues/1815))
- Automatically sort all pages by name ([#1848]({{ site.repository }}/issues/1848))
- Better error message when time is not parseable ([#1847]({{ site.repository }}/issues/1847))
- Allow `include` tag variable arguments to use filters ([#1841]({{ site.repository }}/issues/1841))
- `post_url` tag should raise `ArgumentError` for invalid name ([#1825]({{ site.repository }}/issues/1825))
- Bump dependency `mercenary` to `~> 0.2.0` ([#1879]({{ site.repository }}/issues/1879))
- Bump dependency `safe_yaml` to `~> 1.0` ([#1886]({{ site.repository }}/issues/1886))
- Allow sorting of content by custom properties ([#1849]({{ site.repository }}/issues/1849))
- Add `--quiet` flag to silence output during build and serve ([#1898]({{ site.repository }}/issues/1898))
- Add a `where` filter to filter arrays based on a key/value pair
    ([#1875]({{ site.repository }}/issues/1875))
- Route 404 errors to a custom 404 page in development ([#1899]({{ site.repository }}/issues/1899))
- Excludes are now relative to the site source ([#1916]({{ site.repository }}/issues/1916))
- Bring MIME Types file for `jekyll serve` to complete parity with GH Pages
    servers ([#1993]({{ site.repository }}/issues/1993))
- Adding Breakpoint to make new site template more responsive ([#2038]({{ site.repository }}/issues/2038))
- Default to using the UTF-8 encoding when reading files. ([#2031]({{ site.repository }}/issues/2031))
- Update Redcarpet dependency to ~> 3.1 ([#2044]({{ site.repository }}/issues/2044))
- Remove support for Ruby 1.9.2 ([#2045]({{ site.repository }}/issues/2045))
- Add `.mkdown` as valid Markdown extension ([#2048]({{ site.repository }}/issues/2048))
- Add `index.xml` to the list of WEBrick directory index files ([#2041]({{ site.repository }}/issues/2041))
- Make the `layouts` config key relative to CWD or to source ([#2058]({{ site.repository }}/issues/2058))
- Update Kramdown to `~> 1.3` ([#1894]({{ site.repository }}/issues/1894))
- Remove unnecessary references to `self` ([#2090]({{ site.repository }}/issues/2090))
- Update to Mercenary v0.3.x ([#2085]({{ site.repository }}/issues/2085))
- Ship Sass support as a separate gem ([#2098]({{ site.repository }}/issues/2098))
- Extract core extensions into a Utils module ([#2112]({{ site.repository }}/issues/2112))
- Refactor CLI & Commands For Greater Happiness ([#2143]({{ site.repository }}/issues/2143))
- Provide useful error when Pygments returns `nil` and error out ([#2148]({{ site.repository }}/issues/2148))
- Add support for unpublished drafts ([#2164]({{ site.repository }}/issues/2164))
- Add `force_polling` option to the `serve` command ([#2165]({{ site.repository }}/issues/2165))
- Clean up the `<head>` in the site template ([#2186]({{ site.repository }}/issues/2186))
- Permit YAML blocks to end with three dots to better conform with the
    YAML spec ([#2110]({{ site.repository }}/issues/2110))
- Use `File.exist?` instead of deprecated `File.exists?` ([#2214]({{ site.repository }}/issues/2214))
- Require newline after start of YAML Front Matter header ([#2211]({{ site.repository }}/issues/2211))
- Add the ability for pages to be marked as `published: false` ([#1492]({{ site.repository }}/issues/1492))
- Add `Jekyll::LiquidExtensions` with `.lookup_variable` method for easy
    looking up of variable values in a Liquid context. ([#2253]({{ site.repository }}/issues/2253))
- Remove literal lang name from class ([#2292]({{ site.repository }}/issues/2292))
- Return `utf-8` encoding in header for webrick error page response ([#2289]({{ site.repository }}/issues/2289))
- Make template site easier to customize ([#2268]({{ site.repository }}/issues/2268))
- Add two-digit year to permalink template option ([#2301]({{ site.repository }}/issues/2301))
- Add `site.documents` to Liquid payload (list of all docs) ([#2295]({{ site.repository }}/issues/2295))
- Take into account missing values in the Liquid sort filter ([#2299]({{ site.repository }}/issues/2299))

### Bug Fixes
{: #bug-fixes-v2-0-0}
- Don't allow nil entries when loading posts ([#1796]({{ site.repository }}/issues/1796))
- Remove the scrollbar that's always displayed in new sites generated
    from the site template ([#1805]({{ site.repository }}/issues/1805))
- Add `#path` to required methods in `Jekyll::Convertible` ([#1866]({{ site.repository }}/issues/1866))
- Default Maruku fenced code blocks to ON for 2.0.0-dev ([#1831]({{ site.repository }}/issues/1831))
- Change short opts for host and port for `jekyll docs` to be consistent with
    other subcommands ([#1877]({{ site.repository }}/issues/1877))
- Fix typos ([#1910]({{ site.repository }}/issues/1910))
- Lock Maruku at 0.7.0 to prevent bugs caused by Maruku 0.7.1 ([#1958]({{ site.repository }}/issues/1958))
- Fixes full path leak to source directory when using include tag ([#1951]({{ site.repository }}/issues/1951))
- Don't generate pages that aren't being published ([#1931]({{ site.repository }}/issues/1931))
- Use `SafeYAML.load` to avoid conflicts with other projects ([#1982]({{ site.repository }}/issues/1982))
- Relative posts should never fail to build ([#1976]({{ site.repository }}/issues/1976))
- Remove executable bits of non executable files ([#2056]({{ site.repository }}/issues/2056))
- `#path` for a draft is now `_drafts` instead of `_posts` ([#2042]({{ site.repository }}/issues/2042))
- Patch a couple show-stopping security vulnerabilities ([#1946]({{ site.repository }}/issues/1946))
- Sanitize paths uniformly, in a Windows-friendly way ([#2065]({{ site.repository }}/issues/2065), [#2109]({{ site.repository }}/issues/2109))
- Update gem build steps to work correctly on Windows ([#2118]({{ site.repository }}/issues/2118))
- Remove obsolete `normalize_options` method call from `bin/jekyll` ([#2121]({{ site.repository }}/issues/2121)).
- Remove `+` characters from Pygments lexer names when adding as a CSS
    class ([#994]({{ site.repository }}/issues/994))
- Remove some code that caused Ruby interpreter warnings ([#2178]({{ site.repository }}/issues/2178))
- Only strip the drive name if it begins the string ([#2175]({{ site.repository }}/issues/2175))
- Remove default post with invalid date from site template ([#2200]({{ site.repository }}/issues/2200))
- Fix `Post#url` and `Page#url` escape ([#1568]({{ site.repository }}/issues/1568))
- Strip newlines from the {% raw %}`{% highlight %}`{% endraw %} block content ([#1823]({{ site.repository }}/issues/1823))
- Load in `rouge` only when it's been requested as the highlighter ([#2189]({{ site.repository }}/issues/2189))
- Convert input to string before XML escaping (`xml_escape` liquid filter) ([#2244]({{ site.repository }}/issues/2244))
- Modify configuration key for Collections and reset properly. ([#2238]({{ site.repository }}/issues/2238))
- Avoid duplicated output using `highlight` tag ([#2264]({{ site.repository }}/issues/2264))
- Only use Jekyll.logger for output ([#2307]({{ site.repository }}/issues/2307))
- Close the file descriptor in `has_yaml_header?` ([#2310]({{ site.repository }}/issues/2310))
- Add `output` to `Document` liquid output hash ([#2309]({{ site.repository }}/issues/2309))

### Development Fixes
{: #development-fixes-v2-0-0}
- Add a link to the site in the README.md file ([#1795]({{ site.repository }}/issues/1795))
- Add in History and site changes from `v1-stable` branch ([#1836]({{ site.repository }}/issues/1836))
- Testing additions on the Excerpt class ([#1893]({{ site.repository }}/issues/1893))
- Fix the `highlight` tag feature ([#1859]({{ site.repository }}/issues/1859))
- Test Jekyll under Ruby 2.1.0 ([#1900]({{ site.repository }}/issues/1900))
- Add script/cibuild for fun and profit ([#1912]({{ site.repository }}/issues/1912))
- Use `Forwardable` for delegation between `Excerpt` and `Post`
    ([#1927]({{ site.repository }}/issues/1927))
- Rename `read_things` to `read_content` ([#1928]({{ site.repository }}/issues/1928))
- Add `script/branding` script for ASCII art lovin' ([#1936]({{ site.repository }}/issues/1936))
- Update the README to reflect the repo move ([#1943]({{ site.repository }}/issues/1943))
- Add the project vision to the README ([#1935]({{ site.repository }}/issues/1935))
- Speed up Travis CI builds by using Rebund ([#1985]({{ site.repository }}/issues/1985))
- Use Yarp as a Gem proxy for Travis CI ([#1984]({{ site.repository }}/issues/1984))
- Remove Yarp as a Gem proxy for Travis CI ([#2004]({{ site.repository }}/issues/2004))
- Move the reading of layouts into its own class ([#2020]({{ site.repository }}/issues/2020))
- Test Sass import ([#2009]({{ site.repository }}/issues/2009))
- Switch Maruku and Kramdown in lists of Runtime vs. Development dependencies ([#2049]({{ site.repository }}/issues/2049))
- Clean up the gemspec for the project ([#2095]({{ site.repository }}/issues/2095))
- Add Japanese translation of README and CONTRIBUTING docs. ([#2081]({{ site.repository }}/issues/2081))
- Re-align the tables in Cucumber ([#2108]({{ site.repository }}/issues/2108))
- Trim trailing spaces and convert tabs to spaces ([#2122]({{ site.repository }}/issues/2122))
- Fix the failing Travis scenarios due to Cucumber issues ([#2155]({{ site.repository }}/issues/2155))
- Wrap `bundle install` in `travis_retry` to retry when RubyGems fails ([#2160]({{ site.repository }}/issues/2160))
- Refactor tags and categories ([#1639]({{ site.repository }}/issues/1639))
- Extract plugin management into its own class ([#2197]({{ site.repository }}/issues/2197))
- Add missing tests for `Command` ([#2216]({{ site.repository }}/issues/2216))
- Update `rr` link in CONTRIBUTING doc ([#2247]({{ site.repository }}/issues/2247))
- Streamline Cucumber execution of `jekyll` subcommands ([#2258]({{ site.repository }}/issues/2258))
- Refactor `Commands::Serve`. ([#2269]({{ site.repository }}/issues/2269))
- Refactor `highlight` tag ([#2154]({{ site.repository }}/issues/2154))
- Update `Util` hash functions with latest from Rails ([#2273]({{ site.repository }}/issues/2273))
- Workaround for Travis bug ([#2290]({{ site.repository }}/issues/2290))

### Site Enhancements
{: #site-enhancements-v2-0-0}
- Document Kramdown's GFM parser option ([#1791]({{ site.repository }}/issues/1791))
- Move CSS to includes & update normalize.css to v2.1.3 ([#1787]({{ site.repository }}/issues/1787))
- Minify CSS only in production ([#1803]({{ site.repository }}/issues/1803))
- Fix broken link to installation of Ruby on Mountain Lion blog post on
    Troubleshooting docs page ([#1797]({{ site.repository }}/issues/1797))
- Fix issues with 1.4.1 release blog post ([#1804]({{ site.repository }}/issues/1804))
- Add note about deploying to OpenShift ([#1812]({{ site.repository }}/issues/1812))
- Collect all Windows-related docs onto one page ([#1818]({{ site.repository }}/issues/1818))
- Fixed typo in datafiles doc page ([#1854]({{ site.repository }}/issues/1854))
- Clarify how to access `site` in docs ([#1864]({{ site.repository }}/issues/1864))
- Add closing `<code>` tag to `context.registers[:site]` note ([#1867]({{ site.repository }}/issues/1867))
- Fix link to [@mojombo](https://github.com/mojombo)'s site source ([#1897]({{ site.repository }}/issues/1897))
- Add `paginate: nil` to default configuration in docs ([#1896]({{ site.repository }}/issues/1896))
- Add link to our License in the site footer ([#1889]({{ site.repository }}/issues/1889))
- Add a charset note in "Writing Posts" doc page ([#1902]({{ site.repository }}/issues/1902))
- Disallow selection of path and prompt in bash examples
- Add jekyll-compass to the plugin list ([#1923]({{ site.repository }}/issues/1923))
- Add note in Posts docs about stripping `<p>` tags from excerpt ([#1933]({{ site.repository }}/issues/1933))
- Add additional info about the new exclude behavior ([#1938]({{ site.repository }}/issues/1938))
- Linkify 'awesome contributors' to point to the contributors graph on
    GitHub ([#1940]({{ site.repository }}/issues/1940))
- Update `docs/sites.md` link to GitHub Training materials ([#1949]({{ site.repository }}/issues/1949))
- Update `master` with the release info from 1.4.3 ([#1947]({{ site.repository }}/issues/1947))
- Define docs nav in datafile ([#1953]({{ site.repository }}/issues/1953))
- Clarify the docs around the naming convention for posts ([#1971]({{ site.repository }}/issues/1971))
- Add missing `next` and `previous` docs for post layouts and templates ([#1970]({{ site.repository }}/issues/1970))
- Add note to `Writing posts` page about how to strip html from excerpt ([#1962]({{ site.repository }}/issues/1962))
- Add `jekyll-humanize` plugin to plugin list ([#1998]({{ site.repository }}/issues/1998))
- Add `jekyll-font-awesome` plugin to plugin list ([#1999]({{ site.repository }}/issues/1999))
- Add `sublime-jekyll` to list of Editor plugins ([#2001]({{ site.repository }}/issues/2001))
- Add `vim-jekyll` to the list of Editor plugins ([#2005]({{ site.repository }}/issues/2005))
- Fix non-semantic nesting of `p` tags in `news_item` layout ([#2013]({{ site.repository }}/issues/2013))
- Document destination folder cleaning ([#2016]({{ site.repository }}/issues/2016))
- Updated instructions for NearlyFreeSpeech.NET installation ([#2015]({{ site.repository }}/issues/2015))
- Update link to rack-jekyll on "Deployment Methods" page ([#2047]({{ site.repository }}/issues/2047))
- Fix typo in /docs/configuration ([#2073]({{ site.repository }}/issues/2073))
- Fix count in docs for `site.static_files` ([#2077]({{ site.repository }}/issues/2077))
- Update configuration docs to indicate utf-8 is the default for 2.0.0
    and ASCII for 1.9.3 ([#2074]({{ site.repository }}/issues/2074))
- Add info about unreleased feature to the site ([#2061]({{ site.repository }}/issues/2061))
- Add whitespace to liquid example in GitHub Pages docs ([#2084]({{ site.repository }}/issues/2084))
- Clarify the way Sass and CoffeeScript files are read in and output ([#2067]({{ site.repository }}/issues/2067))
- Add lyche gallery tag plugin link to list of plugins ([#2094]({{ site.repository }}/issues/2094))
- Add Jekyll Pages Directory plugin to list of plugins ([#2096]({{ site.repository }}/issues/2096))
- Update Configuration docs page with new markdown extension ([#2102]({{ site.repository }}/issues/2102))
- Add `jekyll-image-set` to the list of third-party plugins ([#2105]({{ site.repository }}/issues/2105))
- Losslessly compress images ([#2128]({{ site.repository }}/issues/2128))
- Update normalize.css to 3.0.0 ([#2126]({{ site.repository }}/issues/2126))
- Update modernizr to v2.7.1 ([#2129]({{ site.repository }}/issues/2129))
- Add `jekyll-ordinal` to list of third-party plugins ([#2150]({{ site.repository }}/issues/2150))
- Add `jekyll_figure` to list of third-party plugins ([#2158]({{ site.repository }}/issues/2158))
- Clarify the documentation for safe mode ([#2163]({{ site.repository }}/issues/2163))
- Some HTML tidying ([#2130]({{ site.repository }}/issues/2130))
- Remove modernizr and use html5shiv.js directly for IE less than v9 ([#2131]({{ site.repository }}/issues/2131))
- Remove unused images ([#2187]({{ site.repository }}/issues/2187))
- Use `array_to_sentence_string` filter when outputting news item
    categories ([#2191]({{ site.repository }}/issues/2191))
- Add link to Help repo in primary navigation bar ([#2177]({{ site.repository }}/issues/2177))
- Switch to using an ico file for the shortcut icon ([#2193]({{ site.repository }}/issues/2193))
- Use numbers to specify font weights and only bring in font weights used ([#2185]({{ site.repository }}/issues/2185))
- Add a link to the list of all tz database time zones ([#1824]({{ site.repository }}/issues/1824))
- Clean-up and improve documentation `feed.xml` ([#2192]({{ site.repository }}/issues/2192))
- Remove duplicate entry in list of third-party plugins ([#2206]({{ site.repository }}/issues/2206))
- Reduce the whitespace in the favicon. ([#2213]({{ site.repository }}/issues/2213))
- Add `jekyll-page-collections` to list of third-party plugins ([#2215]({{ site.repository }}/issues/2215))
- Add a cross-reference about `post_url` ([#2243]({{ site.repository }}/issues/2243))
- Add `jekyll-live-tiles` to list of third-party plugins ([#2250]({{ site.repository }}/issues/2250))
- Fixed broken link to GitHub training material site source ([#2257]({{ site.repository }}/issues/2257))
- Update link to help repo, now called `jekyll-help` ([#2277]({{ site.repository }}/issues/2277))
- Fix capitalization of 'Jekyll' on Deployment Methods page ([#2291]({{ site.repository }}/issues/2291))
- Include plugins by sonnym in list of third-party plugins ([#2297]({{ site.repository }}/issues/2297))
- Add deprecated articles keeper filter to list of third-party plugins ([#2300]({{ site.repository }}/issues/2300))
- Simplify and improve our CSS. ([#2127]({{ site.repository }}/issues/2127))
- Use black text color for the mobile navbar ([#2306]({{ site.repository }}/issues/2306))
- Use the built in date filter and `site.time` for the copyright year. ([#2305]({{ site.repository }}/issues/2305))
- Update html5shiv to v3.7.2 ([#2304]({{ site.repository }}/issues/2304))
- Add 2.0.0 release post ([#2298]({{ site.repository }}/issues/2298))
- Add docs for custom markdown processors ([#2298]({{ site.repository }}/issues/2298))
- Add docs for `where` and `group_by` Liquid filters ([#2298]({{ site.repository }}/issues/2298))
- Remove notes in docs for unreleased features ([#2309]({{ site.repository }}/issues/2309))


## 1.5.1 / 2014-03-27
{: #v1-5-1}

### Bug Fixes
{: #bug-fixes-v1-5-1}

- Only strip the drive name if it begins the string ([#2176]({{ site.repository }}/issues/2176))


## 1.5.0 / 2014-03-24
{: #v1-5-0}

### Minor Enhancements
{: #minor-enhancements-v1-5-0}

- Loosen `safe_yaml` dependency to `~> 1.0` ([#2167]({{ site.repository }}/issues/2167))
- Bump `safe_yaml` dependency to `~> 1.0.0` ([#1942]({{ site.repository }}/issues/1942))

### Bug Fixes
{: #bug-fixes-v1-5-0}

- Fix issue where filesystem traversal restriction broke Windows ([#2167]({{ site.repository }}/issues/2167))
- Lock `maruku` at `0.7.0` ([#2167]({{ site.repository }}/issues/2167))

### Development Fixes
{: #development-fixes-v1-5-0}

- Lock `cucumber` at `1.3.11` ([#2167]({{ site.repository }}/issues/2167))


## 1.4.3 / 2014-01-13
{: #v1-4-3}

### Bug Fixes
{: #bug-fixes-v1-4-3}
- Patch show-stopping security vulnerabilities ([#1944]({{ site.repository }}/issues/1944))


## 1.4.2 / 2013-12-16
{: #v1-4-2}

### Bug Fixes
{: #bug-fixes-v1-4-2}
- Turn on Maruku fenced code blocks by default ([#1830]({{ site.repository }}/issues/1830))


## 1.4.1 / 2013-12-09
{: #v1-4-1}

### Bug Fixes
{: #bug-fixes-v1-4-1}
- Don't allow nil entries when loading posts ([#1796]({{ site.repository }}/issues/1796))


## 1.4.0 / 2013-12-07
{: #v1-4-0}

### Major Enhancements
{: #major-enhancements-v1-4-0}
- Add support for TOML config files ([#1765]({{ site.repository }}/issues/1765))

### Minor Enhancements
{: #minor-enhancements-v1-4-0}
- Sort plugins as a way to establish a load order ([#1682]({{ site.repository }}/issues/1682))
- Update Maruku to 0.7.0 ([#1775]({{ site.repository }}/issues/1775))

### Bug Fixes
{: #bug-fixes-v1-4-0}
- Add a space between two words in a Pagination warning message ([#1769]({{ site.repository }}/issues/1769))
- Upgrade `toml` gem to `v0.1.0` to maintain compat with Ruby 1.8.7 ([#1778]({{ site.repository }}/issues/1778))

### Development Fixes
{: #development-fixes-v1-4-0}
- Remove some whitespace in the code ([#1755]({{ site.repository }}/issues/1755))
- Remove some duplication in the reading of posts and drafts ([#1779]({{ site.repository }}/issues/1779))

### Site Enhancements
{: #site-enhancements-v1-4-0}
- Fixed case of a word in the Jekyll v1.3.0 release post ([#1762]({{ site.repository }}/issues/1762))
- Fixed the mime type for the favicon ([#1772]({{ site.repository }}/issues/1772))


## 1.3.1 / 2013-11-26
{: #v1-3-1}

### Minor Enhancements
{: #minor-enhancements-v1-3-1}
- Add a `--prefix` option to passthrough for the importers ([#1669]({{ site.repository }}/issues/1669))
- Push the paginator plugin lower in the plugin priority order so
    other plugins run before it ([#1759]({{ site.repository }}/issues/1759))

### Bug Fixes
{: #bug-fixes-v1-3-1}
- Fix the include tag when ran in a loop ([#1726]({{ site.repository }}/issues/1726))
- Fix errors when using `--watch` on 1.8.7 ([#1730]({{ site.repository }}/issues/1730))
- Specify where the include is called from if an included file is
    missing ([#1746]({{ site.repository }}/issues/1746))

### Development Fixes
{: #development-fixes-v1-3-1}
- Extract `Site#filter_entries` into its own object ([#1697]({{ site.repository }}/issues/1697))
- Enable Travis' bundle caching ([#1734]({{ site.repository }}/issues/1734))
- Remove trailing whitespace in some files ([#1736]({{ site.repository }}/issues/1736))
- Fix a duplicate test name ([#1754]({{ site.repository }}/issues/1754))

### Site Enhancements
{: #site-enhancements-v1-3-1}
- Update link to example Rakefile to point to specific commit ([#1741]({{ site.repository }}/issues/1741))
- Fix drafts docs to indicate that draft time is based on file modification
    time, not `Time.now` ([#1695]({{ site.repository }}/issues/1695))
- Add `jekyll-monthly-archive-plugin` and `jekyll-category-archive-plugin` to
    list of third-party plugins ([#1693]({{ site.repository }}/issues/1693))
- Add `jekyll-asset-path-plugin` to list of third-party plugins ([#1670]({{ site.repository }}/issues/1670))
- Add `emoji-for-jekyll` to list of third-part plugins ([#1708]({{ site.repository }}/issues/1708))
- Fix previous section link on plugins page to point to pagination page ([#1707]({{ site.repository }}/issues/1707))
- Add `org-mode` converter plugin to third-party plugins ([#1711]({{ site.repository }}/issues/1711))
- Point "Blog migrations" page to http://import.jekyllrb.com ([#1732]({{ site.repository }}/issues/1732))
- Add docs for `post_url` when posts are in subdirectories ([#1718]({{ site.repository }}/issues/1718))
- Update the docs to point to `example.com` ([#1448]({{ site.repository }}/issues/1448))


## 1.3.0 / 2013-11-04
{: #v1-3-0}

### Major Enhancements
{: #major-enhancements-v1-3-0}
- Add support for adding data as YAML files under a site's `_data`
    directory ([#1003]({{ site.repository }}/issues/1003))
- Allow variables to be used with `include` tags ([#1495]({{ site.repository }}/issues/1495))
- Allow using gems for plugin management ([#1557]({{ site.repository }}/issues/1557))

### Minor Enhancements
{: #minor-enhancements-v1-3-0}
- Decrease the specificity in the site template CSS ([#1574]({{ site.repository }}/issues/1574))
- Add `encoding` configuration option ([#1449]({{ site.repository }}/issues/1449))
- Provide better error handling for Jekyll's custom Liquid tags
    ([#1514]({{ site.repository }}/issues/1514))
- If an included file causes a Liquid error, add the path to the
    include file that caused the error to the error message ([#1596]({{ site.repository }}/issues/1596))
- If a layout causes a Liquid error, change the error message so that
    we know it comes from the layout ([#1601]({{ site.repository }}/issues/1601))
- Update Kramdown dependency to `~> 1.2` ([#1610]({{ site.repository }}/issues/1610))
- Update `safe_yaml` dependency to `~> 0.9.7` ([#1602]({{ site.repository }}/issues/1602))
- Allow layouts to be in subfolders like includes ([#1622]({{ site.repository }}/issues/1622))
- Switch to listen for site watching while serving ([#1589]({{ site.repository }}/issues/1589))
- Add a `json` liquid filter to be used in sites ([#1651]({{ site.repository }}/issues/1651))
- Point people to the migration docs when the `jekyll-import` gem is
    missing ([#1662]({{ site.repository }}/issues/1662))

### Bug Fixes
{: #bug-fixes-v1-3-0}
- Fix up matching against source and destination when the two
    locations are similar ([#1556]({{ site.repository }}/issues/1556))
- Fix the missing `pathname` require in certain cases ([#1255]({{ site.repository }}/issues/1255))
- Use `+` instead of `Array#concat` when building `Post` attribute list ([#1571]({{ site.repository }}/issues/1571))
- Print server address when launching a server ([#1586]({{ site.repository }}/issues/1586))
- Downgrade to Maruku `~> 0.6.0` in order to avoid changes in rendering ([#1598]({{ site.repository }}/issues/1598))
- Fix error with failing include tag when variable was file name ([#1613]({{ site.repository }}/issues/1613))
- Downcase lexers before passing them to pygments ([#1615]({{ site.repository }}/issues/1615))
- Capitalize the short verbose switch because it conflicts with the
    built-in Commander switch ([#1660]({{ site.repository }}/issues/1660))
- Fix compatibility with 1.8.x ([#1665]({{ site.repository }}/issues/1665))
- Fix an error with the new file watching code due to library version
    incompatibilities ([#1687]({{ site.repository }}/issues/1687))

### Development Fixes
{: #development-fixes-v1-3-0}
- Add coverage reporting with Coveralls ([#1539]({{ site.repository }}/issues/1539))
- Refactor the Liquid `include` tag ([#1490]({{ site.repository }}/issues/1490))
- Update launchy dependency to `~> 2.3` ([#1608]({{ site.repository }}/issues/1608))
- Update rr dependency to `~> 1.1` ([#1604]({{ site.repository }}/issues/1604))
- Update cucumber dependency to `~> 1.3` ([#1607]({{ site.repository }}/issues/1607))
- Update coveralls dependency to `~> 0.7.0` ([#1606]({{ site.repository }}/issues/1606))
- Update rake dependency to `~> 10.1` ([#1603]({{ site.repository }}/issues/1603))
- Clean up `site.rb` comments to be more concise/uniform ([#1616]({{ site.repository }}/issues/1616))
- Use the master branch for the build badge in the readme ([#1636]({{ site.repository }}/issues/1636))
- Refactor Site#render ([#1638]({{ site.repository }}/issues/1638))
- Remove duplication in command line options ([#1637]({{ site.repository }}/issues/1637))
- Add tests for all the coderay options ([#1543]({{ site.repository }}/issues/1543))
- Improve some of the Cucumber test code ([#1493]({{ site.repository }}/issues/1493))
- Improve comparisons of timestamps by ignoring the seconds ([#1582]({{ site.repository }}/issues/1582))

### Site Enhancements
{: #site-enhancements-v1-3-0}
- Fix params for `JekyllImport::WordPress.process` arguments ([#1554]({{ site.repository }}/issues/1554))
- Add `jekyll-suggested-tweet` to list of third-party plugins ([#1555]({{ site.repository }}/issues/1555))
- Link to Liquid's docs for tags and filters ([#1553]({{ site.repository }}/issues/1553))
- Add note about installing Xcode on the Mac in the Installation docs ([#1561]({{ site.repository }}/issues/1561))
- Simplify/generalize pagination docs ([#1577]({{ site.repository }}/issues/1577))
- Add documentation for the new data sources feature ([#1503]({{ site.repository }}/issues/1503))
- Add more information on how to create generators ([#1590]({{ site.repository }}/issues/1590), [#1592]({{ site.repository }}/issues/1592))
- Improve the instructions for mimicking GitHub Flavored Markdown
    ([#1614]({{ site.repository }}/issues/1614))
- Add `jekyll-import` warning note of missing dependencies ([#1626]({{ site.repository }}/issues/1626))
- Fix grammar in the Usage section ([#1635]({{ site.repository }}/issues/1635))
- Add documentation for the use of gems as plugins ([#1656]({{ site.repository }}/issues/1656))
- Document the existence of a few additional plugins ([#1405]({{ site.repository }}/issues/1405))
- Document that the `date_to_string` always returns a two digit day ([#1663]({{ site.repository }}/issues/1663))
- Fix navigation in the "Working with Drafts" page ([#1667]({{ site.repository }}/issues/1667))
- Fix an error with the data documentation ([#1691]({{ site.repository }}/issues/1691))


## 1.2.1 / 2013-09-14
{: #v1-2-1}

### Minor Enhancements
{: #minor-enhancements-v1-2-1}
- Print better messages for detached server. Mute output on detach. ([#1518]({{ site.repository }}/issues/1518))
- Disable reverse lookup when running `jekyll serve` ([#1363]({{ site.repository }}/issues/1363))
- Upgrade RedCarpet dependency to `~> 2.3.0` ([#1515]({{ site.repository }}/issues/1515))
- Upgrade to Liquid `>= 2.5.2, < 2.6` ([#1536]({{ site.repository }}/issues/1536))

### Bug Fixes
{: #bug-fixes-v1-2-1}
- Fix file discrepancy in gemspec ([#1522]({{ site.repository }}/issues/1522))
- Force rendering of Include tag ([#1525]({{ site.repository }}/issues/1525))

### Development Fixes
{: #development-fixes-v1-2-1}
- Add a rake task to generate a new release post ([#1404]({{ site.repository }}/issues/1404))
- Mute LSI output in tests ([#1531]({{ site.repository }}/issues/1531))
- Update contributor documentation ([#1537]({{ site.repository }}/issues/1537))

### Site Enhancements
{: #site-enhancements-v1-2-1}
- Fix a couple of validation errors on the site ([#1511]({{ site.repository }}/issues/1511))
- Make navigation menus reusable ([#1507]({{ site.repository }}/issues/1507))
- Fix link to History page from Release v1.2.0 notes post.
- Fix markup in History file for command line options ([#1512]({{ site.repository }}/issues/1512))
- Expand 1.2 release post title to 1.2.0 ([#1516]({{ site.repository }}/issues/1516))


## 1.2.0 / 2013-09-06
{: #v1-2-0}

### Major Enhancements
{: #major-enhancements-v1-2-0}
- Disable automatically-generated excerpts when `excerpt_separator` is `""`. ([#1386]({{ site.repository }}/issues/1386))
- Add checking for URL conflicts when running `jekyll doctor` ([#1389]({{ site.repository }}/issues/1389))

### Minor Enhancements
{: #minor-enhancements-v1-2-0}
- Catch and fix invalid `paginate` values ([#1390]({{ site.repository }}/issues/1390))
- Remove superfluous `div.container` from the default html template for
    `jekyll new` ([#1315]({{ site.repository }}/issues/1315))
- Add `-D` short-form switch for the drafts option ([#1394]({{ site.repository }}/issues/1394))
- Update the links in the site template for Twitter and GitHub ([#1400]({{ site.repository }}/issues/1400))
- Update dummy email address to example.com domain ([#1408]({{ site.repository }}/issues/1408))
- Update normalize.css to v2.1.2 and minify; add rake task to update
    normalize.css with greater ease. ([#1430]({{ site.repository }}/issues/1430))
- Add the ability to detach the server ran by `jekyll serve` from it's
    controlling terminal ([#1443]({{ site.repository }}/issues/1443))
- Improve permalink generation for URLs with special characters ([#944]({{ site.repository }}/issues/944))
- Expose the current Jekyll version to posts and pages via a new
    `jekyll.version` variable ([#1481]({{ site.repository }}/issues/1481))

### Bug Fixes
{: #bug-fixes-v1-2-0}
- Markdown extension matching matches only exact matches ([#1382]({{ site.repository }}/issues/1382))
- Fixed NoMethodError when message passed to `Stevenson#message` is nil ([#1388]({{ site.repository }}/issues/1388))
- Use binary mode when writing file ([#1364]({{ site.repository }}/issues/1364))
- Fix 'undefined method `encoding` for "mailto"' errors w/ Ruby 1.8 and
    Kramdown > 0.14.0 ([#1397]({{ site.repository }}/issues/1397))
- Do not force the permalink to be a dir if it ends on .html ([#963]({{ site.repository }}/issues/963))
- When a Liquid Exception is caught, show the full path rel. to site source ([#1415]({{ site.repository }}/issues/1415))
- Properly read in the config options when serving the docs locally
    ([#1444]({{ site.repository }}/issues/1444))
- Fixed `--layouts` option for `build` and `serve` commands ([#1458]({{ site.repository }}/issues/1458))
- Remove kramdown as a runtime dependency since it's optional ([#1498]({{ site.repository }}/issues/1498))
- Provide proper error handling for invalid file names in the include
    tag ([#1494]({{ site.repository }}/issues/1494))

### Development Fixes
{: #development-fixes-v1-2-0}
- Remove redundant argument to
    Jekyll::Commands::New#scaffold_post_content ([#1356]({{ site.repository }}/issues/1356))
- Add new dependencies to the README ([#1360]({{ site.repository }}/issues/1360))
- Fix link to contributing page in README ([#1424]({{ site.repository }}/issues/1424))
- Update TomDoc in Pager#initialize to match params ([#1441]({{ site.repository }}/issues/1441))
- Refactor `Site#cleanup` into `Jekyll::Site::Cleaner` class ([#1429]({{ site.repository }}/issues/1429))
- Several other small minor refactorings ([#1341]({{ site.repository }}/issues/1341))
- Ignore `_site` in jekyllrb.com deploy ([#1480]({{ site.repository }}/issues/1480))
- Add Gem version and dependency badge to README ([#1497]({{ site.repository }}/issues/1497))

### Site Enhancements
{: #site-enhancements-v1-2-0}
- Add info about new releases ([#1353]({{ site.repository }}/issues/1353))
- Update plugin list with jekyll-rss plugin ([#1354]({{ site.repository }}/issues/1354))
- Update the site list page with Ruby's official site ([#1358]({{ site.repository }}/issues/1358))
- Add `jekyll-ditaa` to list of third-party plugins ([#1370]({{ site.repository }}/issues/1370))
- Add `postfiles` to list of third-party plugins ([#1373]({{ site.repository }}/issues/1373))
- For internal links, use full path including trailing `/` ([#1411]({{ site.repository }}/issues/1411))
- Use curly apostrophes in the docs ([#1419]({{ site.repository }}/issues/1419))
- Update the docs for Redcarpet in Jekyll ([#1418]({{ site.repository }}/issues/1418))
- Add `pluralize` and `reading_time` filters to docs ([#1439]({{ site.repository }}/issues/1439))
- Fix markup for the Kramdown options ([#1445]({{ site.repository }}/issues/1445))
- Fix typos in the History file ([#1454]({{ site.repository }}/issues/1454))
- Add trailing slash to site's post URL ([#1462]({{ site.repository }}/issues/1462))
- Clarify that `--config` will take multiple files ([#1474]({{ site.repository }}/issues/1474))
- Fix docs/templates.md private gist example ([#1477]({{ site.repository }}/issues/1477))
- Use `site.repository` for Jekyll's GitHub URL ([#1463]({{ site.repository }}/issues/1463))
- Add `jekyll-pageless-redirects` to list of third-party plugins ([#1486]({{ site.repository }}/issues/1486))
- Clarify that `date_to_xmlschema` returns an ISO 8601 string ([#1488]({{ site.repository }}/issues/1488))
- Add `jekyll-good-include` to list of third-party plugins ([#1491]({{ site.repository }}/issues/1491))
- XML escape the blog post title in our feed ([#1501]({{ site.repository }}/issues/1501))
- Add `jekyll-toc-generator` to list of third-party plugins ([#1506]({{ site.repository }}/issues/1506))


## 1.1.2 / 2013-07-25
{: #v1-1-2}

### Bug Fixes
{: #bug-fixes-v1-1-2}
- Require Liquid 2.5.1 ([#1349]({{ site.repository }}/issues/1349))


## 1.1.1 / 2013-07-24
{: #v1-1-1}

### Minor Enhancements
{: #minor-enhancements-v1-1-1}
- Remove superfluous `table` selector from main.css in `jekyll new` template ([#1328]({{ site.repository }}/issues/1328))
- Abort with non-zero exit codes ([#1338]({{ site.repository }}/issues/1338))

### Bug Fixes
{: #bug-fixes-v1-1-1}
- Fix up the rendering of excerpts ([#1339]({{ site.repository }}/issues/1339))

### Site Enhancements
{: #site-enhancements-v1-1-1}
- Add Jekyll Image Tag to the plugins list ([#1306]({{ site.repository }}/issues/1306))
- Remove erroneous statement that `site.pages` are sorted alphabetically.
- Add info about the `_drafts` directory to the directory structure
    docs ([#1320]({{ site.repository }}/issues/1320))
- Improve the layout of the plugin listing by organizing it into
    categories ([#1310]({{ site.repository }}/issues/1310))
- Add generator-jekyllrb and grunt-jekyll to plugins page ([#1330]({{ site.repository }}/issues/1330))
- Mention Kramdown as option for markdown parser on Extras page ([#1318]({{ site.repository }}/issues/1318))
- Update Quick-Start page to include reminder that all requirements must be installed ([#1327]({{ site.repository }}/issues/1327))
- Change filename in `include` example to an HTML file so as not to indicate that Jekyll
    will automatically convert them. ([#1303]({{ site.repository }}/issues/1303))
- Add an RSS feed for commits to Jekyll ([#1343]({{ site.repository }}/issues/1343))


## 1.1.0 / 2013-07-14
{: #v1-1-0}

### Major Enhancements
{: #major-enhancements-v1-1-0}
- Add `docs` subcommand to read Jekyll's docs when offline. ([#1046]({{ site.repository }}/issues/1046))
- Support passing parameters to templates in `include` tag ([#1204]({{ site.repository }}/issues/1204))
- Add support for Liquid tags to post excerpts ([#1302]({{ site.repository }}/issues/1302))

### Minor Enhancements
{: #minor-enhancements-v1-1-0}
- Search the hierarchy of pagination path up to site root to determine template page for
    pagination. ([#1198]({{ site.repository }}/issues/1198))
- Add the ability to generate a new Jekyll site without a template ([#1171]({{ site.repository }}/issues/1171))
- Use redcarpet as the default markdown engine in newly generated
    sites ([#1245]({{ site.repository }}/issues/1245), [#1247]({{ site.repository }}/issues/1247))
- Add `redcarpet` as a runtime dependency so `jekyll build` works out-of-the-box for new
    sites. ([#1247]({{ site.repository }}/issues/1247))
- In the generated site, remove files that will be replaced by a
    directory ([#1118]({{ site.repository }}/issues/1118))
- Fail loudly if a user-specified configuration file doesn't exist ([#1098]({{ site.repository }}/issues/1098))
- Allow for all options for Kramdown HTML Converter ([#1201]({{ site.repository }}/issues/1201))

### Bug Fixes
{: #bug-fixes-v1-1-0}
- Fix pagination in subdirectories. ([#1198]({{ site.repository }}/issues/1198))
- Fix an issue with directories and permalinks that have a plus sign
    (+) in them ([#1215]({{ site.repository }}/issues/1215))
- Provide better error reporting when generating sites ([#1253]({{ site.repository }}/issues/1253))
- Latest posts first in non-LSI `related_posts` ([#1271]({{ site.repository }}/issues/1271))

### Development Fixes
{: #development-fixes-v1-1-0}
- Merge the theme and layout Cucumber steps into one step ([#1151]({{ site.repository }}/issues/1151))
- Restrict activesupport dependency to pre-4.0.0 to maintain compatibility with `<= 1.9.2`
- Include/exclude deprecation handling simplification ([#1284]({{ site.repository }}/issues/1284))
- Convert README to Markdown. ([#1267]({{ site.repository }}/issues/1267))
- Refactor Jekyll::Site ([#1144]({{ site.repository }}/issues/1144))

### Site Enhancements
{: #site-enhancements-v1-1-0}
- Add "News" section for release notes, along with an RSS feed ([#1093]({{ site.repository }}/issues/1093), [#1285]({{ site.repository }}/issues/1285), [#1286]({{ site.repository }}/issues/1286))
- Add "History" page.
- Restructured docs sections to include "Meta" section.
- Add message to "Templates" page that specifies that Python must be installed in order
    to use Pygments. ([#1182]({{ site.repository }}/issues/1182))
- Update link to the official Maruku repo ([#1175]({{ site.repository }}/issues/1175))
- Add documentation about `paginate_path` to "Templates" page in docs ([#1129]({{ site.repository }}/issues/1129))
- Give the quick-start guide its own page ([#1191]({{ site.repository }}/issues/1191))
- Update ProTip on Installation page in docs to point to all the info about Pygments and
    the 'highlight' tag. ([#1196]({{ site.repository }}/issues/1196))
- Run `site/img` through ImageOptim (thanks [@qrush](https://github.com/qrush)!) ([#1208]({{ site.repository }}/issues/1208))
- Added Jade Converter to `site/docs/plugins` ([#1210]({{ site.repository }}/issues/1210))
- Fix location of docs pages in Contributing pages ([#1214]({{ site.repository }}/issues/1214))
- Add ReadInXMinutes plugin to the plugin list ([#1222]({{ site.repository }}/issues/1222))
- Remove plugins from the plugin list that have equivalents in Jekyll
    proper ([#1223]({{ site.repository }}/issues/1223))
- Add jekyll-assets to the plugin list ([#1225]({{ site.repository }}/issues/1225))
- Add jekyll-pandoc-mulitple-formats to the plugin list ([#1229]({{ site.repository }}/issues/1229))
- Remove dead link to "Using Git to maintain your blog" ([#1227]({{ site.repository }}/issues/1227))
- Tidy up the third-party plugins listing ([#1228]({{ site.repository }}/issues/1228))
- Update contributor information ([#1192]({{ site.repository }}/issues/1192))
- Update URL of article about Blogger migration ([#1242]({{ site.repository }}/issues/1242))
- Specify that RedCarpet is the default for new Jekyll sites on Quickstart page ([#1247]({{ site.repository }}/issues/1247))
- Added `site.pages` to Variables page in docs ([#1251]({{ site.repository }}/issues/1251))
- Add Youku and Tudou Embed link on Plugins page. ([#1250]({{ site.repository }}/issues/1250))
- Add note that `gist` tag supports private gists. ([#1248]({{ site.repository }}/issues/1248))
- Add `jekyll-timeago` to list of third-party plugins. ([#1260]({{ site.repository }}/issues/1260))
- Add `jekyll-swfobject` to list of third-party plugins. ([#1263]({{ site.repository }}/issues/1263))
- Add `jekyll-picture-tag` to list of third-party plugins. ([#1280]({{ site.repository }}/issues/1280))
- Update the GitHub Pages documentation regarding relative URLs
    ([#1291]({{ site.repository }}/issues/1291))
- Update the S3 deployment documentation ([#1294]({{ site.repository }}/issues/1294))
- Add suggestion for Xcode CLT install to troubleshooting page in docs ([#1296]({{ site.repository }}/issues/1296))
- Add 'Working with drafts' page to docs ([#1289]({{ site.repository }}/issues/1289))
- Add information about time zones to the documentation for a page's
    date ([#1304]({{ site.repository }}/issues/1304))


## 1.0.3 / 2013-06-07
{: #v1-0-3}

### Minor Enhancements
{: #minor-enhancements-v1-0-3}
- Add support to gist tag for private gists. ([#1189]({{ site.repository }}/issues/1189))
- Fail loudly when Maruku errors out ([#1190]({{ site.repository }}/issues/1190))
- Move the building of related posts into their own class ([#1057]({{ site.repository }}/issues/1057))
- Removed trailing spaces in several places throughout the code ([#1116]({{ site.repository }}/issues/1116))
- Add a `--force` option to `jekyll new` ([#1115]({{ site.repository }}/issues/1115))
- Convert IDs in the site template to classes ([#1170]({{ site.repository }}/issues/1170))

### Bug Fixes
{: #bug-fixes-v1-0-3}
- Fix typo in Stevenson constant "ERROR". ([#1166]({{ site.repository }}/issues/1166))
- Rename Jekyll::Logger to Jekyll::Stevenson to fix inheritance issue ([#1106]({{ site.repository }}/issues/1106))
- Exit with a non-zero exit code when dealing with a Liquid error ([#1121]({{ site.repository }}/issues/1121))
- Make the `exclude` and `include` options backwards compatible with
    versions of Jekyll prior to 1.0 ([#1114]({{ site.repository }}/issues/1114))
- Fix pagination on Windows ([#1063]({{ site.repository }}/issues/1063))
- Fix the application of Pygments' Generic Output style to Go code
    ([#1156]({{ site.repository }}/issues/1156))

### Site Enhancements
{: #site-enhancements-v1-0-3}
- Add a Pro Tip to docs about front matter variables being optional ([#1147]({{ site.repository }}/issues/1147))
- Add changelog to site as History page in /docs/ ([#1065]({{ site.repository }}/issues/1065))
- Add note to Upgrading page about new config options in 1.0.x ([#1146]({{ site.repository }}/issues/1146))
- Documentation for `date_to_rfc822` and `uri_escape` ([#1142]({{ site.repository }}/issues/1142))
- Documentation highlight boxes shouldn't show scrollbars if not necessary ([#1123]({{ site.repository }}/issues/1123))
- Add link to jekyll-minibundle in the doc's plugins list ([#1035]({{ site.repository }}/issues/1035))
- Quick patch for importers documentation
- Fix prefix for WordpressDotCom importer in docs ([#1107]({{ site.repository }}/issues/1107))
- Add jekyll-contentblocks plugin to docs ([#1068]({{ site.repository }}/issues/1068))
- Make code bits in notes look more natural, more readable ([#1089]({{ site.repository }}/issues/1089))
- Fix logic for `relative_permalinks` instructions on Upgrading page ([#1101]({{ site.repository }}/issues/1101))
- Add docs for post excerpt ([#1072]({{ site.repository }}/issues/1072))
- Add docs for gist tag ([#1072]({{ site.repository }}/issues/1072))
- Add docs indicating that Pygments does not need to be installed
    separately ([#1099]({{ site.repository }}/issues/1099), [#1119]({{ site.repository }}/issues/1119))
- Update the migrator docs to be current ([#1136]({{ site.repository }}/issues/1136))
- Add the Jekyll Gallery Plugin to the plugin list ([#1143]({{ site.repository }}/issues/1143))

### Development Fixes
{: #development-fixes-v1-0-3}
- Use Jekyll.logger instead of Jekyll::Stevenson to log things ([#1149]({{ site.repository }}/issues/1149))
- Fix pesky Cucumber infinite loop ([#1139]({{ site.repository }}/issues/1139))
- Do not write posts with timezones in Cucumber tests ([#1124]({{ site.repository }}/issues/1124))
- Use ISO formatted dates in Cucumber features ([#1150]({{ site.repository }}/issues/1150))


## 1.0.2 / 2013-05-12
{: #v1-0-2}

### Major Enhancements
{: #major-enhancements-v1-0-2}
- Add `jekyll doctor` command to check site for any known compatibility problems ([#1081]({{ site.repository }}/issues/1081))
- Backwards-compatibilize relative permalinks ([#1081]({{ site.repository }}/issues/1081))

### Minor Enhancements
{: #minor-enhancements-v1-0-2}
- Add a `data-lang="<lang>"` attribute to Redcarpet code blocks ([#1066]({{ site.repository }}/issues/1066))
- Deprecate old config `server_port`, match to `port` if `port` isn't set ([#1084]({{ site.repository }}/issues/1084))
- Update pygments.rb version to 0.5.0 ([#1061]({{ site.repository }}/issues/1061))
- Update Kramdown version to 1.0.2 ([#1067]({{ site.repository }}/issues/1067))

### Bug Fixes
{: #bug-fixes-v1-0-2}
- Fix issue when categories are numbers ([#1078]({{ site.repository }}/issues/1078))
- Catching that Redcarpet gem isn't installed ([#1059]({{ site.repository }}/issues/1059))

### Site Enhancements
{: #site-enhancements-v1-0-2}
- Add documentation about `relative_permalinks` ([#1081]({{ site.repository }}/issues/1081))
- Remove pygments-installation instructions, as pygments.rb is bundled with it ([#1079]({{ site.repository }}/issues/1079))
- Move pages to be Pages for realz ([#985]({{ site.repository }}/issues/985))
- Updated links to Liquid documentation ([#1073]({{ site.repository }}/issues/1073))


## 1.0.1 / 2013-05-08
{: #v1-0-1}

### Minor Enhancements
{: #minor-enhancements-v1-0-1}
- Do not force use of `toc_token` when using `generate_tok` in RDiscount ([#1048]({{ site.repository }}/issues/1048))
- Add newer `language-` class name prefix to code blocks ([#1037]({{ site.repository }}/issues/1037))
- Commander error message now preferred over process abort with incorrect args ([#1040]({{ site.repository }}/issues/1040))

### Bug Fixes
{: #bug-fixes-v1-0-1}
- Make Redcarpet respect the pygments configuration option ([#1053]({{ site.repository }}/issues/1053))
- Fix the index build with LSI ([#1045]({{ site.repository }}/issues/1045))
- Don't print deprecation warning when no arguments are specified. ([#1041]({{ site.repository }}/issues/1041))
- Add missing `</div>` to site template used by `new` subcommand, fixed typos in code ([#1032]({{ site.repository }}/issues/1032))

### Site Enhancements
{: #site-enhancements-v1-0-1}
- Changed https to http in the GitHub Pages link ([#1051]({{ site.repository }}/issues/1051))
- Remove CSS cruft, fix typos, fix HTML errors ([#1028]({{ site.repository }}/issues/1028))
- Removing manual install of Pip and Distribute ([#1025]({{ site.repository }}/issues/1025))
- Updated URL for Markdown references plugin ([#1022]({{ site.repository }}/issues/1022))

### Development Fixes
{: #development-fixes-v1-0-1}
- Markdownify history file ([#1027]({{ site.repository }}/issues/1027))
- Update links on README to point to new jekyllrb.com ([#1018]({{ site.repository }}/issues/1018))


## 1.0.0 / 2013-05-06
{: #v1-0-0}

### Major Enhancements
{: #major-enhancements-v1-0-0}
- Add `jekyll new` subcommand: generate a Jekyll scaffold ([#764]({{ site.repository }}/issues/764))
- Refactored Jekyll commands into subcommands: build, serve, and migrate. ([#690]({{ site.repository }}/issues/690))
- Removed importers/migrators from main project, migrated to jekyll-import sub-gem ([#793]({{ site.repository }}/issues/793))
- Added ability to render drafts in `_drafts` folder via command line ([#833]({{ site.repository }}/issues/833))
- Add ordinal date permalink style (/:categories/:year/:y_day/:title.html) ([#928]({{ site.repository }}/issues/928))

### Minor Enhancements
{: #minor-enhancements-v1-0-0}
- Site template HTML5-ified ([#964]({{ site.repository }}/issues/964))
- Use post's directory path when matching for the `post_url` tag ([#998]({{ site.repository }}/issues/998))
- Loosen dependency on Pygments so it's only required when it's needed ([#1015]({{ site.repository }}/issues/1015))
- Parse strings into Time objects for date-related Liquid filters ([#1014]({{ site.repository }}/issues/1014))
- Tell the user if there is no subcommand specified ([#1008]({{ site.repository }}/issues/1008))
- Freak out if the destination of `jekyll new` exists and is non-empty ([#981]({{ site.repository }}/issues/981))
- Add `timezone` configuration option for compilation ([#957]({{ site.repository }}/issues/957))
- Add deprecation messages for pre-1.0 CLI options ([#959]({{ site.repository }}/issues/959))
- Refactor and colorize logging ([#959]({{ site.repository }}/issues/959))
- Refactor Markdown parsing ([#955]({{ site.repository }}/issues/955))
- Added application/vnd.apple.pkpass to mime.types served by WEBrick ([#907]({{ site.repository }}/issues/907))
- Move template site to default markdown renderer ([#961]({{ site.repository }}/issues/961))
- Expose new attribute to Liquid via `page`: `page.path` ([#951]({{ site.repository }}/issues/951))
- Accept multiple config files from command line ([#945]({{ site.repository }}/issues/945))
- Add page variable to liquid custom tags and blocks ([#413]({{ site.repository }}/issues/413))
- Add `paginator.previous_page_path` and `paginator.next_page_path` ([#942]({{ site.repository }}/issues/942))
- Backwards compatibility for 'auto' ([#821]({{ site.repository }}/issues/821), [#934]({{ site.repository }}/issues/934))
- Added date_to_rfc822 used on RSS feeds ([#892]({{ site.repository }}/issues/892))
- Upgrade version of pygments.rb to 0.4.2 ([#927]({{ site.repository }}/issues/927))
- Added short month (e.g. "Sep") to permalink style options for posts ([#890]({{ site.repository }}/issues/890))
- Expose site.baseurl to Liquid templates ([#869]({{ site.repository }}/issues/869))
- Adds excerpt attribute to posts which contains first paragraph of content ([#837]({{ site.repository }}/issues/837))
- Accept custom configuration file via CLI ([#863]({{ site.repository }}/issues/863))
- Load in GitHub Pages MIME Types on `jekyll serve` ([#847]({{ site.repository }}/issues/847), [#871]({{ site.repository }}/issues/871))
- Improve debugability of error message for a malformed highlight tag ([#785]({{ site.repository }}/issues/785))
- Allow symlinked files in unsafe mode ([#824]({{ site.repository }}/issues/824))
- Add 'gist' Liquid tag to core ([#822]({{ site.repository }}/issues/822), [#861]({{ site.repository }}/issues/861))
- New format of Jekyll output ([#795]({{ site.repository }}/issues/795))
- Reinstate `--limit_posts` and `--future` switches ([#788]({{ site.repository }}/issues/788))
- Remove ambiguity from command descriptions ([#815]({{ site.repository }}/issues/815))
- Fix SafeYAML Warnings ([#807]({{ site.repository }}/issues/807))
- Relaxed Kramdown version to 0.14 ([#808]({{ site.repository }}/issues/808))
- Aliased `jekyll server` to `jekyll serve`. ([#792]({{ site.repository }}/issues/792))
- Updated gem versions for Kramdown, Rake, Shoulda, Cucumber, and RedCarpet. ([#744]({{ site.repository }}/issues/744))
- Refactored Jekyll subcommands into Jekyll::Commands submodule, which now contains them ([#768]({{ site.repository }}/issues/768))
- Rescue from import errors in Wordpress.com migrator ([#671]({{ site.repository }}/issues/671))
- Massively accelerate LSI performance ([#664]({{ site.repository }}/issues/664))
- Truncate post slugs when importing from Tumblr ([#496]({{ site.repository }}/issues/496))
- Add glob support to include, exclude option ([#743]({{ site.repository }}/issues/743))
- Layout of Page or Post defaults to 'page' or 'post', respectively ([#580]({{ site.repository }}/issues/580))
    REPEALED by ([#977]({{ site.repository }}/issues/977))
- "Keep files" feature ([#685]({{ site.repository }}/issues/685))
- Output full path & name for files that don't parse ([#745]({{ site.repository }}/issues/745))
- Add source and destination directory protection ([#535]({{ site.repository }}/issues/535))
- Better YAML error message ([#718]({{ site.repository }}/issues/718))
- Bug Fixes
- Paginate in subdirectories properly ([#1016]({{ site.repository }}/issues/1016))
- Ensure post and page URLs have a leading slash ([#992]({{ site.repository }}/issues/992))
- Catch all exceptions, not just StandardError descendents ([#1007]({{ site.repository }}/issues/1007))
- Bullet-proof `limit_posts` option ([#1004]({{ site.repository }}/issues/1004))
- Read in YAML as UTF-8 to accept non-ASCII chars ([#836]({{ site.repository }}/issues/836))
- Fix the CLI option `--plugins` to actually accept dirs and files ([#993]({{ site.repository }}/issues/993))
- Allow 'excerpt' in YAML front matter to override the extracted excerpt ([#946]({{ site.repository }}/issues/946))
- Fix cascade problem with site.baseurl, site.port and site.host. ([#935]({{ site.repository }}/issues/935))
- Filter out directories with valid post names ([#875]({{ site.repository }}/issues/875))
- Fix symlinked static files not being correctly built in unsafe mode ([#909]({{ site.repository }}/issues/909))
- Fix integration with directory_watcher 1.4.x ([#916]({{ site.repository }}/issues/916))
- Accepting strings as arguments to jekyll-import command ([#910]({{ site.repository }}/issues/910))
- Force usage of older directory_watcher gem as 1.5 is broken ([#883]({{ site.repository }}/issues/883))
- Ensure all Post categories are downcase ([#842]({{ site.repository }}/issues/842), [#872]({{ site.repository }}/issues/872))
- Force encoding of the rdiscount TOC to UTF8 to avoid conversion errors ([#555]({{ site.repository }}/issues/555))
- Patch for multibyte URI problem with `jekyll serve` ([#723]({{ site.repository }}/issues/723))
- Order plugin execution by priority ([#864]({{ site.repository }}/issues/864))
- Fixed Page#dir and Page#url for edge cases ([#536]({{ site.repository }}/issues/536))
- Fix broken `post_url` with posts with a time in their YAML front matter ([#831]({{ site.repository }}/issues/831))
- Look for plugins under the source directory ([#654]({{ site.repository }}/issues/654))
- Tumblr Migrator: finds `_posts` dir correctly, fixes truncation of long
      post names ([#775]({{ site.repository }}/issues/775))
- Force Categories to be Strings ([#767]({{ site.repository }}/issues/767))
- Safe YAML plugin to prevent vulnerability ([#777]({{ site.repository }}/issues/777))
- Add SVG support to Jekyll/WEBrick. ([#407]({{ site.repository }}/issues/407), [#406]({{ site.repository }}/issues/406))
- Prevent custom destination from causing continuous regen on watch ([#528]({{ site.repository }}/issues/528), [#820]({{ site.repository }}/issues/820), [#862]({{ site.repository }}/issues/862))

### Site Enhancements
{: #site-enhancements-v1-0-0}
- Responsify ([#860]({{ site.repository }}/issues/860))
- Fix spelling, punctuation and phrasal errors ([#989]({{ site.repository }}/issues/989))
- Update quickstart instructions with `new` command ([#966]({{ site.repository }}/issues/966))
- Add docs for page.excerpt ([#956]({{ site.repository }}/issues/956))
- Add docs for page.path ([#951]({{ site.repository }}/issues/951))
- Clean up site docs to prepare for 1.0 release ([#918]({{ site.repository }}/issues/918))
- Bring site into master branch with better preview/deploy ([#709]({{ site.repository }}/issues/709))
- Redesigned site ([#583]({{ site.repository }}/issues/583))

### Development Fixes
{: #development-fixes-v1-0-0}
- Exclude Cucumber 1.2.4, which causes tests to fail in 1.9.2 ([#938]({{ site.repository }}/issues/938))
- Added "features:html" rake task for debugging purposes, cleaned up
      Cucumber profiles ([#832]({{ site.repository }}/issues/832))
- Explicitly require HTTPS rubygems source in Gemfile ([#826]({{ site.repository }}/issues/826))
- Changed Ruby version for development to 1.9.3-p374 from p362 ([#801]({{ site.repository }}/issues/801))
- Including a link to the GitHub Ruby style guide in CONTRIBUTING.md ([#806]({{ site.repository }}/issues/806))
- Added script/bootstrap ([#776]({{ site.repository }}/issues/776))
- Running Simplecov under 2 conditions: ENV(COVERAGE)=true and with Ruby version
      of greater than 1.9 ([#771]({{ site.repository }}/issues/771))
- Switch to Simplecov for coverage report ([#765]({{ site.repository }}/issues/765))


## 0.12.1 / 2013-02-19
{: #v0-12-1}

### Minor Enhancements
{: #minor-enhancements-v0-12-1}
- Update Kramdown version to 0.14.1 ([#744]({{ site.repository }}/issues/744))
- Test Enhancements
- Update Rake version to 10.0.3 ([#744]({{ site.repository }}/issues/744))
- Update Shoulda version to 3.3.2 ([#744]({{ site.repository }}/issues/744))
- Update Redcarpet version to 2.2.2 ([#744]({{ site.repository }}/issues/744))


## 0.12.0 / 2012-12-22
{: #v0-12-0}

### Minor Enhancements
{: #minor-enhancements-v0-12-0}
- Add ability to explicitly specify included files ([#261]({{ site.repository }}/issues/261))
- Add `--default-mimetype` option ([#279]({{ site.repository }}/issues/279))
- Allow setting of RedCloth options ([#284]({{ site.repository }}/issues/284))
- Add `post_url` Liquid tag for internal post linking ([#369]({{ site.repository }}/issues/369))
- Allow multiple plugin dirs to be specified ([#438]({{ site.repository }}/issues/438))
- Inline TOC token support for RDiscount ([#333]({{ site.repository }}/issues/333))
- Add the option to specify the paginated url format ([#342]({{ site.repository }}/issues/342))
- Swap out albino for pygments.rb ([#569]({{ site.repository }}/issues/569))
- Support Redcarpet 2 and fenced code blocks ([#619]({{ site.repository }}/issues/619))
- Better reporting of Liquid errors ([#624]({{ site.repository }}/issues/624))
- Bug Fixes
- Allow some special characters in highlight names
- URL escape category names in URL generation ([#360]({{ site.repository }}/issues/360))
- Fix error with `limit_posts` ([#442]({{ site.repository }}/issues/442))
- Properly select dotfile during directory scan ([#363]({{ site.repository }}/issues/363), [#431]({{ site.repository }}/issues/431), [#377]({{ site.repository }}/issues/377))
- Allow setting of Kramdown `smart_quotes` ([#482]({{ site.repository }}/issues/482))
- Ensure front matter is at start of file ([#562]({{ site.repository }}/issues/562))


## 0.11.2 / 2011-12-27
{: #v0-11-2}
- Bug Fixes
- Fix gemspec


## 0.11.1 / 2011-12-27
{: #v0-11-1}
- Bug Fixes
- Fix extra blank line in highlight blocks ([#409]({{ site.repository }}/issues/409))
- Update dependencies


## 0.11.0 / 2011-07-10
{: #v0-11-0}

### Major Enhancements
{: #major-enhancements-v0-11-0}
- Add command line importer functionality ([#253]({{ site.repository }}/issues/253))
- Add Redcarpet Markdown support ([#318]({{ site.repository }}/issues/318))
- Make markdown/textile extensions configurable ([#312]({{ site.repository }}/issues/312))
- Add `markdownify` filter

### Minor Enhancements
{: #minor-enhancements-v0-11-0}
- Switch to Albino gem
- Bundler support
- Use English library to avoid hoops ([#292]({{ site.repository }}/issues/292))
- Add Posterous importer ([#254]({{ site.repository }}/issues/254))
- Fixes for Wordpress importer ([#274]({{ site.repository }}/issues/274), [#252]({{ site.repository }}/issues/252), [#271]({{ site.repository }}/issues/271))
- Better error message for invalid post date ([#291]({{ site.repository }}/issues/291))
- Print formatted fatal exceptions to stdout on build failure
- Add Tumblr importer ([#323]({{ site.repository }}/issues/323))
- Add Enki importer ([#320]({{ site.repository }}/issues/320))
- Bug Fixes
- Secure additional path exploits


## 0.10.0 / 2010-12-16
{: #v0-10-0}
- Bug Fixes
- Add `--no-server` option.


## 0.9.0 / 2010-12-15
{: #v0-9-0}

### Minor Enhancements
{: #minor-enhancements-v0-9-0}
- Use OptionParser's `[no-]` functionality for better boolean parsing.
- Add Drupal migrator ([#245]({{ site.repository }}/issues/245))
- Complain about YAML and Liquid errors ([#249]({{ site.repository }}/issues/249))
- Remove orphaned files during regeneration ([#247]({{ site.repository }}/issues/247))
- Add Marley migrator ([#28]({{ site.repository }}/issues/28))


## 0.8.0 / 2010-11-22
{: #v0-8-0}

### Minor Enhancements
{: #minor-enhancements-v0-8-0}
- Add wordpress.com importer ([#207]({{ site.repository }}/issues/207))
- Add `--limit-posts` cli option ([#212]({{ site.repository }}/issues/212))
- Add `uri_escape` filter ([#234]({{ site.repository }}/issues/234))
- Add `--base-url` cli option ([#235]({{ site.repository }}/issues/235))
- Improve MT migrator ([#238]({{ site.repository }}/issues/238))
- Add kramdown support ([#239]({{ site.repository }}/issues/239))
- Bug Fixes
- Fixed filename basename generation ([#208]({{ site.repository }}/issues/208))
- Set mode to UTF8 on Sequel connections ([#237]({{ site.repository }}/issues/237))
- Prevent `_includes` dir from being a symlink


## 0.7.0 / 2010-08-24
{: #v0-7-0}

### Minor Enhancements
{: #minor-enhancements-v0-7-0}
- Add support for rdiscount extensions ([#173]({{ site.repository }}/issues/173))
- Bug Fixes
- Highlight should not be able to render local files
- The site configuration may not always provide a 'time' setting ([#184]({{ site.repository }}/issues/184))


## 0.6.2 / 2010-06-25
{: #v0-6-2}
- Bug Fixes
- Fix Rakefile 'release' task (tag pushing was missing origin)
- Ensure that RedCloth is loaded when textilize filter is used ([#183]({{ site.repository }}/issues/183))
- Expand source, destination, and plugin paths ([#180]({{ site.repository }}/issues/180))
- Fix `page.url` to include full relative path ([#181]({{ site.repository }}/issues/181))


## 0.6.1 / 2010-06-24
{: #v0-6-1}
- Bug Fixes
- Fix Markdown Pygments prefix and suffix ([#178]({{ site.repository }}/issues/178))


## 0.6.0 / 2010-06-23
{: #v0-6-0}

### Major Enhancements
{: #major-enhancements-v0-6-0}
- Proper plugin system ([#19]({{ site.repository }}/issues/19), [#100]({{ site.repository }}/issues/100))
- Add safe mode so unsafe converters/generators can be added
- Maruku is now the only processor dependency installed by default.
      Other processors will be lazy-loaded when necessary (and prompt the
      user to install them when necessary) ([#57]({{ site.repository }}/issues/57))

### Minor Enhancements
{: #minor-enhancements-v0-6-0}
- Inclusion/exclusion of future dated posts ([#59]({{ site.repository }}/issues/59))
- Generation for a specific time ([#59]({{ site.repository }}/issues/59))
- Allocate `site.time` on render not per site_payload invocation ([#59]({{ site.repository }}/issues/59))
- Pages now present in the site payload and can be used through the
      `site.pages` and `site.html_pages` variables
- Generate phase added to site#process and pagination is now a generator
- Switch to RakeGem for build/test process
- Only regenerate static files when they have changed ([#142]({{ site.repository }}/issues/142))
- Allow arbitrary options to Pygments ([#31]({{ site.repository }}/issues/31))
- Allow URL to be set via command line option ([#147]({{ site.repository }}/issues/147))
- Bug Fixes
- Render highlighted code for non markdown/textile pages ([#116]({{ site.repository }}/issues/116))
- Fix highlighting on Ruby 1.9 ([#65]({{ site.repository }}/issues/65))
- Fix extension munging when pretty permalinks are enabled ([#64]({{ site.repository }}/issues/64))
- Stop sorting categories ([#33]({{ site.repository }}/issues/33))
- Preserve generated attributes over front matter ([#119]({{ site.repository }}/issues/119))
- Fix source directory binding using `Dir.pwd` ([#75]({{ site.repository }}/issues/75))


## 0.5.7 / 2010-01-12
{: #v0-5-7}

### Minor Enhancements
{: #minor-enhancements-v0-5-7}
- Allow overriding of post date in the front matter ([#62]({{ site.repository }}/issues/62), [#38]({{ site.repository }}/issues/38))
- Bug Fixes
- Categories isn't always an array ([#73]({{ site.repository }}/issues/73))
- Empty tags causes error in read_posts ([#84]({{ site.repository }}/issues/84))
- Fix pagination to adhere to read/render/write paradigm
- Test Enhancement
- Cucumber features no longer use site.posts.first where a better
      alternative is available


## 0.5.6 / 2010-01-08
{: #v0-5-6}
- Bug Fixes
- Require redcloth >= 4.2.1 in tests ([#92]({{ site.repository }}/issues/92))
- Don't break on triple dashes in yaml front matter ([#93]({{ site.repository }}/issues/93))

### Minor Enhancements
{: #minor-enhancements-v0-5-6}
- Allow .mkd as markdown extension
- Use $stdout/err instead of constants ([#99]({{ site.repository }}/issues/99))
- Properly wrap code blocks ([#91]({{ site.repository }}/issues/91))
- Add javascript mime type for webrick ([#98]({{ site.repository }}/issues/98))


## 0.5.5 / 2010-01-08
{: #v0-5-5}
- Bug Fixes
- Fix pagination % 0 bug ([#78]({{ site.repository }}/issues/78))
- Ensure all posts are processed first ([#71]({{ site.repository }}/issues/71))


## NOTE
- After this point I will no longer be giving credit in the history;
    that is what the commit log is for.


## 0.5.4 / 2009-08-23
{: #v0-5-4}
- Bug Fixes
- Do not allow symlinks (security vulnerability)


## 0.5.3 / 2009-07-14
{: #v0-5-3}
- Bug Fixes
- Solving the permalink bug where non-html files wouldn't work
      ([@jeffrydegrande](https://github.com/jeffrydegrande))


## 0.5.2 / 2009-06-24
{: #v0-5-2}
- Enhancements
- Added --paginate option to the executable along with a paginator object
      for the payload ([@calavera](https://github.com/calavera))
- Upgraded RedCloth to 4.2.1, which makes `<notextile>` tags work once
      again.
- Configuration options set in config.yml are now available through the
      site payload ([@vilcans](https://github.com/vilcans))
- Posts can now have an empty YAML front matter or none at all
      (@ bahuvrihi)
- Bug Fixes
- Fixing Ruby 1.9 issue that requires `#to_s` on the err object
      ([@Chrononaut](https://github.com/Chrononaut))
- Fixes for pagination and ordering posts on the same day ([@ujh](https://github.com/ujh))
- Made pages respect permalinks style and permalinks in yml front matter
      ([@eugenebolshakov](https://github.com/eugenebolshakov))
- Index.html file should always have index.html permalink
      ([@eugenebolshakov](https://github.com/eugenebolshakov))
- Added trailing slash to pretty permalink style so Apache is happy
      ([@eugenebolshakov](https://github.com/eugenebolshakov))
- Bad markdown processor in config fails sooner and with better message
      (@ gcnovus)
- Allow CRLFs in yaml front matter ([@juretta](https://github.com/juretta))
- Added Date#xmlschema for Ruby versions < 1.9


## 0.5.1 / 2009-05-06
{: #v0-5-1}

### Major Enhancements
{: #major-enhancements-v0-5-1}
- Next/previous posts in site payload ([@pantulis](https://github.com/pantulis), [@tomo](https://github.com/tomo))
- Permalink templating system
- Moved most of the README out to the GitHub wiki
- Exclude option in configuration so specified files won't be brought over
      with generated site ([@duritong](https://github.com/duritong))
- Bug Fixes
- Making sure config.yaml references are all gone, using only config.yml
- Fixed syntax highlighting breaking for UTF-8 code ([@henrik](https://github.com/henrik))
- Worked around RDiscount bug that prevents Markdown from getting parsed
      after highlight ([@henrik](https://github.com/henrik))
- CGI escaped post titles ([@Chrononaut](https://github.com/Chrononaut))


## 0.5.0 / 2009-04-07
{: #v0-5-0}

### Minor Enhancements
{: #minor-enhancements-v0-5-0}
- Ability to set post categories via YAML ([@qrush](https://github.com/qrush))
- Ability to set prevent a post from publishing via YAML ([@qrush](https://github.com/qrush))
- Add textilize filter ([@willcodeforfoo](https://github.com/willcodeforfoo))
- Add 'pretty' permalink style for wordpress-like urls ([@dysinger](https://github.com/dysinger))
- Made it possible to enter categories from YAML as an array ([@Chrononaut](https://github.com/Chrononaut))
- Ignore Emacs autosave files ([@Chrononaut](https://github.com/Chrononaut))
- Bug Fixes
- Use block syntax of popen4 to ensure that subprocesses are properly disposed ([@jqr](https://github.com/jqr))
- Close open4 streams to prevent zombies ([@rtomayko](https://github.com/rtomayko))
- Only query required fields from the WP Database ([@ariejan](https://github.com/ariejan))
- Prevent `_posts` from being copied to the destination directory ([@bdimcheff](https://github.com/bdimcheff))
- Refactors
- Factored the filtering code into a method ([@Chrononaut](https://github.com/Chrononaut))
- Fix tests and convert to Shoulda ([@qrush](https://github.com/qrush), [@technicalpickles](https://github.com/technicalpickles))
- Add Cucumber acceptance test suite ([@qrush](https://github.com/qrush), [@technicalpickles](https://github.com/technicalpickles))


## 0.4.1

### Minor Enhancements
{: #minor-enhancements-v--}
- Changed date format on wordpress converter (zeropadding) ([@dysinger](https://github.com/dysinger))
- Bug Fixes
- Add Jekyll binary as executable to gemspec ([@dysinger](https://github.com/dysinger))


## 0.4.0 / 2009-02-03
{: #v0-4-0}

### Major Enhancements
{: #major-enhancements-v0-4-0}
- Switch to Jeweler for packaging tasks

### Minor Enhancements
{: #minor-enhancements-v0-4-0}
- Type importer ([@codeslinger](https://github.com/codeslinger))
- `site.topics` accessor ([@baz](https://github.com/baz))
- Add `array_to_sentence_string` filter ([@mchung](https://github.com/mchung))
- Add a converter for textpattern ([@PerfectlyNormal](https://github.com/PerfectlyNormal))
- Add a working Mephisto / MySQL converter ([@ivey](https://github.com/ivey))
- Allowing .htaccess files to be copied over into the generated site ([@briandoll](https://github.com/briandoll))
- Add option to not put file date in permalink URL ([@mreid](https://github.com/mreid))
- Add line number capabilities to highlight blocks ([@jcon](https://github.com/jcon))
- Bug Fixes
- Fix permalink behavior ([@cavalle](https://github.com/cavalle))
- Fixed an issue with pygments, markdown, and newlines ([@zpinter](https://github.com/zpinter))
- Ampersands need to be escaped ([@pufuwozu](https://github.com/pufuwozu), [@ap](https://github.com/ap))
- Test and fix the site.categories hash ([@zzot](https://github.com/zzot))
- Fix site payload available to files ([@matrix9180](https://github.com/matrix9180))


## 0.3.0 / 2008-12-24
{: #v0-3-0}

### Major Enhancements
{: #major-enhancements-v0-3-0}
- Added `--server` option to start a simple WEBrick server on destination
      directory ([@johnreilly](https://github.com/johnreilly) and [@mchung](https://github.com/mchung))

### Minor Enhancements
{: #minor-enhancements-v0-3-0}
- Added post categories based on directories containing `_posts` ([@mreid](https://github.com/mreid))
- Added post topics based on directories underneath `_posts`
- Added new date filter that shows the full month name ([@mreid](https://github.com/mreid))
- Merge Post's YAML front matter into its to_liquid payload ([@remi](https://github.com/remi))
- Restrict includes to regular files underneath `_includes`
- Bug Fixes
- Change YAML delimiter matcher so as to not chew up 2nd level markdown
      headers ([@mreid](https://github.com/mreid))
- Fix bug that meant page data (such as the date) was not available in
      templates ([@mreid](https://github.com/mreid))
- Properly reject directories in `_layouts`


## 0.2.1 / 2008-12-15
{: #v0-2-1}
- Major Changes
- Use Maruku (pure Ruby) for Markdown by default ([@mreid](https://github.com/mreid))
- Allow use of RDiscount with `--rdiscount` flag

### Minor Enhancements
{: #minor-enhancements-v0-2-1}
- Don't load directory_watcher unless it's needed ([@pjhyett](https://github.com/pjhyett))


## 0.2.0 / 2008-12-14
{: #v0-2-0}
- Major Changes
- related_posts is now found in `site.related_posts`


## 0.1.6 / 2008-12-13
{: #v0-1-6}
- Major Features
- Include files in `_includes` with {% raw %}`{% include x.textile %}`{% endraw %}


## 0.1.5 / 2008-12-12
{: #v0-1-5}

### Major Enhancements
{: #major-enhancements-v0-1-5}
- Code highlighting with Pygments if `--pygments` is specified
- Disable true LSI by default, enable with `--lsi`

### Minor Enhancements
{: #minor-enhancements-v0-1-5}
- Output informative message if RDiscount is not available ([@JackDanger](https://github.com/JackDanger))
- Bug Fixes
- Prevent Jekyll from picking up the output directory as a source ([@JackDanger](https://github.com/JackDanger))
- Skip `related_posts` when there is only one post ([@JackDanger](https://github.com/JackDanger))


## 0.1.4 / 2008-12-08
{: #v0-1-4}
- Bug Fixes
- DATA does not work properly with rubygems


## 0.1.3 / 2008-12-06
{: #v0-1-3}
- Major Features
- Markdown support ([@vanpelt](https://github.com/vanpelt))
- Mephisto and CSV converters ([@vanpelt](https://github.com/vanpelt))
- Code hilighting ([@vanpelt](https://github.com/vanpelt))
- Autobuild
- Bug Fixes
- Accept both `\r\n` and `\n` in YAML header ([@vanpelt](https://github.com/vanpelt))


## 0.1.2 / 2008-11-22
{: #v0-1-2}
- Major Features
- Add a real "related posts" implementation using Classifier
- Command Line Changes
- Allow cli to be called with 0, 1, or 2 args intuiting dir paths
      if they are omitted


## 0.1.1 / 2008-11-22
{: #v0-1-1}
- Minor Additions
- Posts now support introspectional data e.g. {% raw %}`{{ page.url }}`{% endraw %}


## 0.1.0 / 2008-11-05
{: #v0-1-0}
- First release
- Converts posts written in Textile
- Converts regular site pages
- Simple copy of binary files


## 0.0.0 / 2008-10-19
{: #v0-0-0}
- Birthday!
