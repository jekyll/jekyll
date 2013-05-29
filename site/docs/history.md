---
layout: docs
title: History
permalink: /docs/history/
---

## HEAD
### Major Enhancements

### Minor Enhancements
- Move the building of related posts into their own class ([#1057](https://github.com/mojombo/jekyll/issues/1057))
- Removed trailing spaces in several places throughout the code ([#1116](https://github.com/mojombo/jekyll/issues/1116))
- Add a `--force` option to `jekyll new` ([#1115](https://github.com/mojombo/jekyll/issues/1115))

### Bug Fixes
- Rename Jekyll::Logger to Jekyll::Stevenson to fix inheritance issue ([#1106](https://github.com/mojombo/jekyll/issues/1106))
- Exit with a non-zero exit code when dealing with a Liquid error ([#1121](https://github.com/mojombo/jekyll/issues/1121))
- Make the `exclude` and `include` options backwards compatible with
    versions of Jekyll prior to 1.0 ([#1114](https://github.com/mojombo/jekyll/issues/1114))
- Fix pagination on Windows ([#1063](https://github.com/mojombo/jekyll/issues/1063))
- Fix the application of Pygments' Generic Output style to Go code
    ([#1156](https://github.com/mojombo/jekyll/issues/1156))

### Site Enhancements
- Documentation for `date_to_rfc822` and `uri_escape` ([#1142](https://github.com/mojombo/jekyll/issues/1142))
- Documentation highlight boxes shouldn't show scrollbars if not necessary ([#1123](https://github.com/mojombo/jekyll/issues/1123))
- Add link to jekyll-minibundle in the doc's plugins list ([#1035](https://github.com/mojombo/jekyll/issues/1035))
- Quick patch for importers documentation
- Fix prefix for WordpressDotCom importer in docs ([#1107](https://github.com/mojombo/jekyll/issues/1107))
- Add jekyll-contentblocks plugin to docs ([#1068](https://github.com/mojombo/jekyll/issues/1068))
- Make code bits in notes look more natural, more readable ([#1089](https://github.com/mojombo/jekyll/issues/1089))
- Fix logic for `relative_permalinks` instructions on Upgrading page ([#1101](https://github.com/mojombo/jekyll/issues/1101))
- Add docs for post excerpt ([#1072](https://github.com/mojombo/jekyll/issues/1072))
- Add docs for gist tag ([#1072](https://github.com/mojombo/jekyll/issues/1072))
- Add docs indicating that Pygments does not need to be installed
    separately ([#1099](https://github.com/mojombo/jekyll/issues/1099), [#1119](https://github.com/mojombo/jekyll/issues/1119))
- Update the migrator docs to be current ([#1136](https://github.com/mojombo/jekyll/issues/1136))
- Add the Jekyll Gallery Plugin to the plugin list ([#1143](https://github.com/mojombo/jekyll/issues/1143))

### Development Fixes
- Fix pesky Cucumber infinite loop ([#1139](https://github.com/mojombo/jekyll/issues/1139))
- Do not write posts with timezones in Cucumber tests ([#1124](https://github.com/mojombo/jekyll/issues/1124))

## 1.0.2 / 2013-05-12

### Major Enhancements
- Add `jekyll doctor` command to check site for any known compatibility problems ([#1081](https://github.com/mojombo/jekyll/issues/1081))
- Backwards-compatibilize relative permalinks ([#1081](https://github.com/mojombo/jekyll/issues/1081))

### Minor Enhancements
- Add a `data-lang="<lang>"` attribute to Redcarpet code blocks ([#1066](https://github.com/mojombo/jekyll/issues/1066))
- Deprecate old config `server_port`, match to `port` if `port` isn't set ([#1084](https://github.com/mojombo/jekyll/issues/1084))
- Update pygments.rb version to 0.5.0 ([#1061](https://github.com/mojombo/jekyll/issues/1061))
- Update Kramdown version to 1.0.2 ([#1067](https://github.com/mojombo/jekyll/issues/1067))

### Bug Fixes
- Fix issue when categories are numbers ([#1078](https://github.com/mojombo/jekyll/issues/1078))
- Catching that Redcarpet gem isn't installed ([#1059](https://github.com/mojombo/jekyll/issues/1059))

### Site Enhancements
- Add documentation about `relative_permalinks` ([#1081](https://github.com/mojombo/jekyll/issues/1081))
- Remove pygments-installation instructions, as pygments.rb is bundled with it ([#1079](https://github.com/mojombo/jekyll/issues/1079))
- Move pages to be Pages for realz ([#985](https://github.com/mojombo/jekyll/issues/985))
- Updated links to Liquid documentation ([#1073](https://github.com/mojombo/jekyll/issues/1073))

## 1.0.1 / 2013-05-08

### Minor Enhancements
- Do not force use of toc_token when using generate_tok in RDiscount ([#1048](https://github.com/mojombo/jekyll/issues/1048))
- Add newer `language-` class name prefix to code blocks ([#1037](https://github.com/mojombo/jekyll/issues/1037))
- Commander error message now preferred over process abort with incorrect args ([#1040](https://github.com/mojombo/jekyll/issues/1040))

### Bug Fixes
- Make Redcarpet respect the pygments configuration option ([#1053](https://github.com/mojombo/jekyll/issues/1053))
- Fix the index build with LSI ([#1045](https://github.com/mojombo/jekyll/issues/1045))
- Don't print deprecation warning when no arguments are specified. ([#1041](https://github.com/mojombo/jekyll/issues/1041))
- Add missing `</div>` to site template used by `new` subcommand, fixed typos in code ([#1032](https://github.com/mojombo/jekyll/issues/1032))

### Site Enhancements
- Changed https to http in the GitHub Pages link ([#1051](https://github.com/mojombo/jekyll/issues/1051))
- Remove CSS cruft, fix typos, fix HTML errors ([#1028](https://github.com/mojombo/jekyll/issues/1028))
- Removing manual install of Pip and Distribute ([#1025](https://github.com/mojombo/jekyll/issues/1025))
- Updated URL for Markdown references plugin ([#1022](https://github.com/mojombo/jekyll/issues/1022))

### Development Fixes
- Markdownify history file ([#1027](https://github.com/mojombo/jekyll/issues/1027))
- Update links on README to point to new jekyllrb.com ([#1018](https://github.com/mojombo/jekyll/issues/1018))

## 1.0.0 / 2013-05-06

### Major Enhancements
- Add `jekyll new` subcommand: generate a jekyll scaffold ([#764](https://github.com/mojombo/jekyll/issues/764))
- Refactored jekyll commands into subcommands: build, serve, and migrate. ([#690](https://github.com/mojombo/jekyll/issues/690))
- Removed importers/migrators from main project, migrated to jekyll-import sub-gem ([#793](https://github.com/mojombo/jekyll/issues/793))
- Added ability to render drafts in `_drafts` folder via command line ([#833](https://github.com/mojombo/jekyll/issues/833))
- Add ordinal date permalink style (/:categories/:year/:y_day/:title.html) ([#928](https://github.com/mojombo/jekyll/issues/928))

### Minor Enhancements
- Site template HTML5-ified ([#964](https://github.com/mojombo/jekyll/issues/964))
- Use post's directory path when matching for the post_url tag ([#998](https://github.com/mojombo/jekyll/issues/998))
- Loosen dependency on Pygments so it's only required when it's needed ([#1015](https://github.com/mojombo/jekyll/issues/1015))
- Parse strings into Time objects for date-related Liquid filters ([#1014](https://github.com/mojombo/jekyll/issues/1014))
- Tell the user if there is no subcommand specified ([#1008](https://github.com/mojombo/jekyll/issues/1008))
- Freak out if the destination of `jekyll new` exists and is non-empty ([#981](https://github.com/mojombo/jekyll/issues/981))
- Add `timezone` configuration option for compilation ([#957](https://github.com/mojombo/jekyll/issues/957))
- Add deprecation messages for pre-1.0 CLI options ([#959](https://github.com/mojombo/jekyll/issues/959))
- Refactor and colorize logging ([#959](https://github.com/mojombo/jekyll/issues/959))
- Refactor Markdown parsing ([#955](https://github.com/mojombo/jekyll/issues/955))
- Added application/vnd.apple.pkpass to mime.types served by WEBrick ([#907](https://github.com/mojombo/jekyll/issues/907))
- Move template site to default markdown renderer ([#961](https://github.com/mojombo/jekyll/issues/961))
- Expose new attribute to Liquid via `page`: `page.path` ([#951](https://github.com/mojombo/jekyll/issues/951))
- Accept multiple config files from command line ([#945](https://github.com/mojombo/jekyll/issues/945))
- Add page variable to liquid custom tags and blocks ([#413](https://github.com/mojombo/jekyll/issues/413))
- Add paginator.previous_page_path and paginator.next_page_path ([#942](https://github.com/mojombo/jekyll/issues/942))
- Backwards compatibility for 'auto' ([#821](https://github.com/mojombo/jekyll/issues/821), [#934](https://github.com/mojombo/jekyll/issues/934))
- Added date_to_rfc822 used on RSS feeds ([#892](https://github.com/mojombo/jekyll/issues/892))
- Upgrade version of pygments.rb to 0.4.2 ([#927](https://github.com/mojombo/jekyll/issues/927))
- Added short month (e.g. "Sep") to permalink style options for posts ([#890](https://github.com/mojombo/jekyll/issues/890))
- Expose site.baseurl to Liquid templates ([#869](https://github.com/mojombo/jekyll/issues/869))
- Adds excerpt attribute to posts which contains first paragraph of content ([#837](https://github.com/mojombo/jekyll/issues/837))
- Accept custom configuration file via CLI ([#863](https://github.com/mojombo/jekyll/issues/863))
- Load in GitHub Pages MIME Types on `jekyll serve` ([#847](https://github.com/mojombo/jekyll/issues/847), [#871](https://github.com/mojombo/jekyll/issues/871))
- Improve debugability of error message for a malformed highlight tag ([#785](https://github.com/mojombo/jekyll/issues/785))
- Allow symlinked files in unsafe mode ([#824](https://github.com/mojombo/jekyll/issues/824))
- Add 'gist' Liquid tag to core ([#822](https://github.com/mojombo/jekyll/issues/822), [#861](https://github.com/mojombo/jekyll/issues/861))
- New format of Jekyll output ([#795](https://github.com/mojombo/jekyll/issues/795))
- Reinstate --limit_posts and --future switches ([#788](https://github.com/mojombo/jekyll/issues/788))
- Remove ambiguity from command descriptions ([#815](https://github.com/mojombo/jekyll/issues/815))
- Fix SafeYAML Warnings ([#807](https://github.com/mojombo/jekyll/issues/807))
- Relaxed Kramdown version to 0.14 ([#808](https://github.com/mojombo/jekyll/issues/808))
- Aliased `jekyll server` to `jekyll serve`. ([#792](https://github.com/mojombo/jekyll/issues/792))
- Updated gem versions for Kramdown, Rake, Shoulda, Cucumber, and RedCarpet. ([#744](https://github.com/mojombo/jekyll/issues/744))
- Refactored jekyll subcommands into Jekyll::Commands submodule, which now contains them ([#768](https://github.com/mojombo/jekyll/issues/768))
- Rescue from import errors in Wordpress.com migrator ([#671](https://github.com/mojombo/jekyll/issues/671))
- Massively accelerate LSI performance ([#664](https://github.com/mojombo/jekyll/issues/664))
- Truncate post slugs when importing from Tumblr ([#496](https://github.com/mojombo/jekyll/issues/496))
- Add glob support to include, exclude option ([#743](https://github.com/mojombo/jekyll/issues/743))
- Layout of Page or Post defaults to 'page' or 'post', respectively ([#580](https://github.com/mojombo/jekyll/issues/580))
    REPEALED by ([#977](https://github.com/mojombo/jekyll/issues/977))
- "Keep files" feature ([#685](https://github.com/mojombo/jekyll/issues/685))
- Output full path & name for files that don't parse ([#745](https://github.com/mojombo/jekyll/issues/745))
- Add source and destination directory protection ([#535](https://github.com/mojombo/jekyll/issues/535))
- Better YAML error message ([#718](https://github.com/mojombo/jekyll/issues/718))
- Bug Fixes
- Paginate in subdirectories properly ([#1016](https://github.com/mojombo/jekyll/issues/1016))
- Ensure post and page URLs have a leading slash ([#992](https://github.com/mojombo/jekyll/issues/992))
- Catch all exceptions, not just StandardError descendents ([#1007](https://github.com/mojombo/jekyll/issues/1007))
- Bullet-proof limit_posts option ([#1004](https://github.com/mojombo/jekyll/issues/1004))
- Read in YAML as UTF-8 to accept non-ASCII chars ([#836](https://github.com/mojombo/jekyll/issues/836))
- Fix the CLI option --plugins to actually accept dirs and files ([#993](https://github.com/mojombo/jekyll/issues/993))
- Allow 'excerpt' in YAML Front-Matter to override the extracted excerpt ([#946](https://github.com/mojombo/jekyll/issues/946))
- Fix cascade problem with site.baseurl, site.port and site.host. ([#935](https://github.com/mojombo/jekyll/issues/935))
- Filter out directories with valid post names ([#875](https://github.com/mojombo/jekyll/issues/875))
- Fix symlinked static files not being correctly built in unsafe mode ([#909](https://github.com/mojombo/jekyll/issues/909))
- Fix integration with directory_watcher 1.4.x ([#916](https://github.com/mojombo/jekyll/issues/916))
- Accepting strings as arguments to jekyll-import command ([#910](https://github.com/mojombo/jekyll/issues/910))
- Force usage of older directory_watcher gem as 1.5 is broken ([#883](https://github.com/mojombo/jekyll/issues/883))
- Ensure all Post categories are downcase ([#842](https://github.com/mojombo/jekyll/issues/842), [#872](https://github.com/mojombo/jekyll/issues/872))
- Force encoding of the rdiscount TOC to UTF8 to avoid conversion errors ([#555](https://github.com/mojombo/jekyll/issues/555))
- Patch for multibyte URI problem with jekyll serve ([#723](https://github.com/mojombo/jekyll/issues/723))
- Order plugin execution by priority ([#864](https://github.com/mojombo/jekyll/issues/864))
- Fixed Page#dir and Page#url for edge cases ([#536](https://github.com/mojombo/jekyll/issues/536))
- Fix broken post_url with posts with a time in their YAML Front-Matter ([#831](https://github.com/mojombo/jekyll/issues/831))
- Look for plugins under the source directory ([#654](https://github.com/mojombo/jekyll/issues/654))
- Tumblr Migrator: finds _posts dir correctly, fixes truncation of long
      post names ([#775](https://github.com/mojombo/jekyll/issues/775))
- Force Categories to be Strings ([#767](https://github.com/mojombo/jekyll/issues/767))
- Safe YAML plugin to prevent vulnerability ([#777](https://github.com/mojombo/jekyll/issues/777))
- Add SVG support to Jekyll/WEBrick. ([#407](https://github.com/mojombo/jekyll/issues/407), [#406](https://github.com/mojombo/jekyll/issues/406))
- Prevent custom destination from causing continuous regen on watch ([#528](https://github.com/mojombo/jekyll/issues/528), [#820](https://github.com/mojombo/jekyll/issues/820), [#862](https://github.com/mojombo/jekyll/issues/862))

### Site Enhancements
- Responsify ([#860](https://github.com/mojombo/jekyll/issues/860))
- Fix spelling, punctuation and phrasal errors ([#989](https://github.com/mojombo/jekyll/issues/989))
- Update quickstart instructions with `new` command ([#966](https://github.com/mojombo/jekyll/issues/966))
- Add docs for page.excerpt ([#956](https://github.com/mojombo/jekyll/issues/956))
- Add docs for page.path ([#951](https://github.com/mojombo/jekyll/issues/951))
- Clean up site docs to prepare for 1.0 release ([#918](https://github.com/mojombo/jekyll/issues/918))
- Bring site into master branch with better preview/deploy ([#709](https://github.com/mojombo/jekyll/issues/709))
- Redesigned site ([#583](https://github.com/mojombo/jekyll/issues/583))

### Development Fixes
- Exclude Cucumber 1.2.4, which causes tests to fail in 1.9.2 ([#938](https://github.com/mojombo/jekyll/issues/938))
- Added "features:html" rake task for debugging purposes, cleaned up
      cucumber profiles ([#832](https://github.com/mojombo/jekyll/issues/832))
- Explicitly require HTTPS rubygems source in Gemfile ([#826](https://github.com/mojombo/jekyll/issues/826))
- Changed Ruby version for development to 1.9.3-p374 from p362 ([#801](https://github.com/mojombo/jekyll/issues/801))
- Including a link to the GitHub Ruby style guide in CONTRIBUTING.md ([#806](https://github.com/mojombo/jekyll/issues/806))
- Added script/bootstrap ([#776](https://github.com/mojombo/jekyll/issues/776))
- Running Simplecov under 2 conditions: ENV(COVERAGE)=true and with Ruby version
      of greater than 1.9 ([#771](https://github.com/mojombo/jekyll/issues/771))
- Switch to Simplecov for coverage report ([#765](https://github.com/mojombo/jekyll/issues/765))

## 0.12.1 / 2013-02-19
### Minor Enhancements
- Update Kramdown version to 0.14.1 ([#744](https://github.com/mojombo/jekyll/issues/744))
- Test Enhancements
- Update Rake version to 10.0.3 ([#744](https://github.com/mojombo/jekyll/issues/744))
- Update Shoulda version to 3.3.2 ([#744](https://github.com/mojombo/jekyll/issues/744))
- Update Redcarpet version to 2.2.2 ([#744](https://github.com/mojombo/jekyll/issues/744))

## 0.12.0 / 2012-12-22
### Minor Enhancements
- Add ability to explicitly specify included files ([#261](https://github.com/mojombo/jekyll/issues/261))
- Add --default-mimetype option ([#279](https://github.com/mojombo/jekyll/issues/279))
- Allow setting of RedCloth options ([#284](https://github.com/mojombo/jekyll/issues/284))
- Add post_url Liquid tag for internal post linking ([#369](https://github.com/mojombo/jekyll/issues/369))
- Allow multiple plugin dirs to be specified ([#438](https://github.com/mojombo/jekyll/issues/438))
- Inline TOC token support for RDiscount ([#333](https://github.com/mojombo/jekyll/issues/333))
- Add the option to specify the paginated url format ([#342](https://github.com/mojombo/jekyll/issues/342))
- Swap out albino for pygments.rb ([#569](https://github.com/mojombo/jekyll/issues/569))
- Support Redcarpet 2 and fenced code blocks ([#619](https://github.com/mojombo/jekyll/issues/619))
- Better reporting of Liquid errors ([#624](https://github.com/mojombo/jekyll/issues/624))
- Bug Fixes
- Allow some special characters in highlight names
- URL escape category names in URL generation ([#360](https://github.com/mojombo/jekyll/issues/360))
- Fix error with limit_posts ([#442](https://github.com/mojombo/jekyll/issues/442))
- Properly select dotfile during directory scan ([#363](https://github.com/mojombo/jekyll/issues/363), [#431](https://github.com/mojombo/jekyll/issues/431), [#377](https://github.com/mojombo/jekyll/issues/377))
- Allow setting of Kramdown smart_quotes ([#482](https://github.com/mojombo/jekyll/issues/482))
- Ensure front-matter is at start of file ([#562](https://github.com/mojombo/jekyll/issues/562))

## 0.11.2 / 2011-12-27
- Bug Fixes
- Fix gemspec

## 0.11.1 / 2011-12-27
- Bug Fixes
- Fix extra blank line in highlight blocks ([#409](https://github.com/mojombo/jekyll/issues/409))
- Update dependencies

## 0.11.0 / 2011-07-10
### Major Enhancements
- Add command line importer functionality ([#253](https://github.com/mojombo/jekyll/issues/253))
- Add Redcarpet Markdown support ([#318](https://github.com/mojombo/jekyll/issues/318))
- Make markdown/textile extensions configurable ([#312](https://github.com/mojombo/jekyll/issues/312))
- Add `markdownify` filter

### Minor Enhancements
- Switch to Albino gem
- Bundler support
- Use English library to avoid hoops ([#292](https://github.com/mojombo/jekyll/issues/292))
- Add Posterous importer ([#254](https://github.com/mojombo/jekyll/issues/254))
- Fixes for Wordpress importer ([#274](https://github.com/mojombo/jekyll/issues/274), [#252](https://github.com/mojombo/jekyll/issues/252), [#271](https://github.com/mojombo/jekyll/issues/271))
- Better error message for invalid post date ([#291](https://github.com/mojombo/jekyll/issues/291))
- Print formatted fatal exceptions to stdout on build failure
- Add Tumblr importer ([#323](https://github.com/mojombo/jekyll/issues/323))
- Add Enki importer ([#320](https://github.com/mojombo/jekyll/issues/320))
- Bug Fixes
- Secure additional path exploits

## 0.10.0 / 2010-12-16
- Bug Fixes
- Add --no-server option.

## 0.9.0 / 2010-12-15
### Minor Enhancements
- Use OptionParser's [no-] functionality for better boolean parsing.
- Add Drupal migrator ([#245](https://github.com/mojombo/jekyll/issues/245))
- Complain about YAML and Liquid errors ([#249](https://github.com/mojombo/jekyll/issues/249))
- Remove orphaned files during regeneration ([#247](https://github.com/mojombo/jekyll/issues/247))
- Add Marley migrator ([#28](https://github.com/mojombo/jekyll/issues/28))

## 0.8.0 / 2010-11-22
### Minor Enhancements
- Add wordpress.com importer ([#207](https://github.com/mojombo/jekyll/issues/207))
- Add --limit-posts cli option ([#212](https://github.com/mojombo/jekyll/issues/212))
- Add uri_escape filter ([#234](https://github.com/mojombo/jekyll/issues/234))
- Add --base-url cli option ([#235](https://github.com/mojombo/jekyll/issues/235))
- Improve MT migrator ([#238](https://github.com/mojombo/jekyll/issues/238))
- Add kramdown support ([#239](https://github.com/mojombo/jekyll/issues/239))
- Bug Fixes
- Fixed filename basename generation ([#208](https://github.com/mojombo/jekyll/issues/208))
- Set mode to UTF8 on Sequel connections ([#237](https://github.com/mojombo/jekyll/issues/237))
- Prevent _includes dir from being a symlink

## 0.7.0 / 2010-08-24
### Minor Enhancements
- Add support for rdiscount extensions ([#173](https://github.com/mojombo/jekyll/issues/173))
- Bug Fixes
- Highlight should not be able to render local files
- The site configuration may not always provide a 'time' setting ([#184](https://github.com/mojombo/jekyll/issues/184))

## 0.6.2 / 2010-06-25
- Bug Fixes
- Fix Rakefile 'release' task (tag pushing was missing origin)
- Ensure that RedCloth is loaded when textilize filter is used ([#183](https://github.com/mojombo/jekyll/issues/183))
- Expand source, destination, and plugin paths ([#180](https://github.com/mojombo/jekyll/issues/180))
- Fix page.url to include full relative path ([#181](https://github.com/mojombo/jekyll/issues/181))

## 0.6.1 / 2010-06-24
- Bug Fixes
- Fix Markdown Pygments prefix and suffix ([#178](https://github.com/mojombo/jekyll/issues/178))

## 0.6.0 / 2010-06-23
### Major Enhancements
- Proper plugin system ([#19](https://github.com/mojombo/jekyll/issues/19), [#100](https://github.com/mojombo/jekyll/issues/100))
- Add safe mode so unsafe converters/generators can be added
- Maruku is now the only processor dependency installed by default.
      Other processors will be lazy-loaded when necessary (and prompt the
      user to install them when necessary) ([#57](https://github.com/mojombo/jekyll/issues/57))

### Minor Enhancements
- Inclusion/exclusion of future dated posts ([#59](https://github.com/mojombo/jekyll/issues/59))
- Generation for a specific time ([#59](https://github.com/mojombo/jekyll/issues/59))
- Allocate site.time on render not per site_payload invocation ([#59](https://github.com/mojombo/jekyll/issues/59))
- Pages now present in the site payload and can be used through the
      site.pages and site.html_pages variables
- Generate phase added to site#process and pagination is now a generator
- Switch to RakeGem for build/test process
- Only regenerate static files when they have changed ([#142](https://github.com/mojombo/jekyll/issues/142))
- Allow arbitrary options to Pygments ([#31](https://github.com/mojombo/jekyll/issues/31))
- Allow URL to be set via command line option ([#147](https://github.com/mojombo/jekyll/issues/147))
- Bug Fixes
- Render highlighted code for non markdown/textile pages ([#116](https://github.com/mojombo/jekyll/issues/116))
- Fix highlighting on Ruby 1.9 ([#65](https://github.com/mojombo/jekyll/issues/65))
- Fix extension munging when pretty permalinks are enabled ([#64](https://github.com/mojombo/jekyll/issues/64))
- Stop sorting categories ([#33](https://github.com/mojombo/jekyll/issues/33))
- Preserve generated attributes over front matter ([#119](https://github.com/mojombo/jekyll/issues/119))
- Fix source directory binding using Dir.pwd ([#75](https://github.com/mojombo/jekyll/issues/75))

## 0.5.7 / 2010-01-12
### Minor Enhancements
- Allow overriding of post date in the front matter ([#62](https://github.com/mojombo/jekyll/issues/62), [#38](https://github.com/mojombo/jekyll/issues/38))
- Bug Fixes
- Categories isn't always an array ([#73](https://github.com/mojombo/jekyll/issues/73))
- Empty tags causes error in read_posts ([#84](https://github.com/mojombo/jekyll/issues/84))
- Fix pagination to adhere to read/render/write paradigm
- Test Enhancement
- cucumber features no longer use site.posts.first where a better
      alternative is available

## 0.5.6 / 2010-01-08
- Bug Fixes
- Require redcloth >= 4.2.1 in tests ([#92](https://github.com/mojombo/jekyll/issues/92))
- Don't break on triple dashes in yaml frontmatter ([#93](https://github.com/mojombo/jekyll/issues/93))

### Minor Enhancements
- Allow .mkd as markdown extension
- Use $stdout/err instead of constants ([#99](https://github.com/mojombo/jekyll/issues/99))
- Properly wrap code blocks ([#91](https://github.com/mojombo/jekyll/issues/91))
- Add javascript mime type for webrick ([#98](https://github.com/mojombo/jekyll/issues/98))

## 0.5.5 / 2010-01-08
- Bug Fixes
- Fix pagination % 0 bug ([#78](https://github.com/mojombo/jekyll/issues/78))
- Ensure all posts are processed first ([#71](https://github.com/mojombo/jekyll/issues/71))

## NOTE
- After this point I will no longer be giving credit in the history;
    that is what the commit log is for.

## 0.5.4 / 2009-08-23
- Bug Fixes
- Do not allow symlinks (security vulnerability)

## 0.5.3 / 2009-07-14
- Bug Fixes
- Solving the permalink bug where non-html files wouldn't work
      [github.com/jeffrydegrande]

## 0.5.2 / 2009-06-24
- Enhancements
- Added --paginate option to the executable along with a paginator object
      for the payload [github.com/calavera]
- Upgraded RedCloth to 4.2.1, which makes <notextile> tags work once
      again.
- Configuration options set in config.yml are now available through the
      site payload [github.com/vilcans]
- Posts can now have an empty YAML front matter or none at all
      [github.com/bahuvrihi]
- Bug Fixes
- Fixing Ruby 1.9 issue that requires to_s on the err object
      [github.com/Chrononaut]
- Fixes for pagination and ordering posts on the same day [github.com/ujh]
- Made pages respect permalinks style and permalinks in yml front matter
      [github.com/eugenebolshakov]
- Index.html file should always have index.html permalink
      [github.com/eugenebolshakov]
- Added trailing slash to pretty permalink style so Apache is happy
      [github.com/eugenebolshakov]
- Bad markdown processor in config fails sooner and with better message
      [github.com/gcnovus]
- Allow CRLFs in yaml frontmatter [github.com/juretta]
- Added Date#xmlschema for Ruby versions < 1.9

## 0.5.1 / 2009-05-06
### Major Enhancements
- Next/previous posts in site payload [github.com/pantulis,
      github.com/tomo]
- Permalink templating system
- Moved most of the README out to the GitHub wiki
- Exclude option in configuration so specified files won't be brought over
      with generated site [github.com/duritong]
- Bug Fixes
- Making sure config.yaml references are all gone, using only config.yml
- Fixed syntax highlighting breaking for UTF-8 code [github.com/henrik]
- Worked around RDiscount bug that prevents Markdown from getting parsed
      after highlight [github.com/henrik]
- CGI escaped post titles [github.com/Chrononaut]

## 0.5.0 / 2009-04-07
### Minor Enhancements
- Ability to set post categories via YAML [github.com/qrush]
- Ability to set prevent a post from publishing via YAML
      [github.com/qrush]
- Add textilize filter [github.com/willcodeforfoo]
- Add 'pretty' permalink style for wordpress-like urls
      [github.com/dysinger]
- Made it possible to enter categories from YAML as an array
      [github.com/Chrononaut]
- Ignore Emacs autosave files [github.com/Chrononaut]
- Bug Fixes
- Use block syntax of popen4 to ensure that subprocesses are properly
      disposed [github.com/jqr]
- Close open4 streams to prevent zombies [github.com/rtomayko]
- Only query required fields from the WP Database [github.com/ariejan]
- Prevent _posts from being copied to the destination directory
      [github.com/bdimcheff]
- Refactors
- Factored the filtering code into a method [github.com/Chrononaut]
- Fix tests and convert to Shoulda [github.com/qrush,
      github.com/technicalpickles]
- Add Cucumber acceptance test suite [github.com/qrush,
      github.com/technicalpickles]

## 0.4.1
### Minor Enhancements
- Changed date format on wordpress converter (zeropadding)
      [github.com/dysinger]
- Bug Fixes
- Add jekyll binary as executable to gemspec [github.com/dysinger]

## 0.4.0 / 2009-02-03
### Major Enhancements
- Switch to Jeweler for packaging tasks

### Minor Enhancements
- Type importer [github.com/codeslinger]
- site.topics accessor [github.com/baz]
- Add array_to_sentence_string filter [github.com/mchung]
- Add a converter for textpattern [github.com/PerfectlyNormal]
- Add a working Mephisto / MySQL converter [github.com/ivey]
- Allowing .htaccess files to be copied over into the generated site
      [github.com/briandoll]
- Add option to not put file date in permalink URL [github.com/mreid]
- Add line number capabilities to highlight blocks [github.com/jcon]
- Bug Fixes
- Fix permalink behavior [github.com/cavalle]
- Fixed an issue with pygments, markdown, and newlines
      [github.com/zpinter]
- Ampersands need to be escaped [github.com/pufuwozu, github.com/ap]
- Test and fix the site.categories hash [github.com/zzot]
- Fix site payload available to files [github.com/matrix9180]

## 0.3.0 / 2008-12-24
### Major Enhancements
- Added --server option to start a simple WEBrick server on destination
      directory [github.com/johnreilly and github.com/mchung]

### Minor Enhancements
- Added post categories based on directories containing _posts
      [github.com/mreid]
- Added post topics based on directories underneath _posts
- Added new date filter that shows the full month name [github.com/mreid]
- Merge Post's YAML front matter into its to_liquid payload
      [github.com/remi]
- Restrict includes to regular files underneath _includes
- Bug Fixes
- Change YAML delimiter matcher so as to not chew up 2nd level markdown
      headers [github.com/mreid]
- Fix bug that meant page data (such as the date) was not available in
      templates [github.com/mreid]
- Properly reject directories in _layouts

## 0.2.1 / 2008-12-15
- Major Changes
- Use Maruku (pure Ruby) for Markdown by default [github.com/mreid]
- Allow use of RDiscount with --rdiscount flag

### Minor Enhancements
- Don't load directory_watcher unless it's needed [github.com/pjhyett]

## 0.2.0 / 2008-12-14
- Major Changes
- related_posts is now found in site.related_posts

## 0.1.6 / 2008-12-13
- Major Features
- Include files in _includes with {% include x.textile %}

## 0.1.5 / 2008-12-12
### Major Enhancements
- Code highlighting with Pygments if --pygments is specified
- Disable true LSI by default, enable with --lsi

### Minor Enhancements
- Output informative message if RDiscount is not available
      [github.com/JackDanger]
- Bug Fixes
- Prevent Jekyll from picking up the output directory as a source
      [github.com/JackDanger]
- Skip related_posts when there is only one post [github.com/JackDanger]

## 0.1.4 / 2008-12-08
- Bug Fixes
- DATA does not work properly with rubygems

## 0.1.3 / 2008-12-06
- Major Features
- Markdown support [github.com/vanpelt]
- Mephisto and CSV converters [github.com/vanpelt]
- Code hilighting [github.com/vanpelt]
- Autobuild
- Bug Fixes
- Accept both \r\n and \n in YAML header [github.com/vanpelt]

## 0.1.2 / 2008-11-22
- Major Features
- Add a real "related posts" implementation using Classifier
- Command Line Changes
- Allow cli to be called with 0, 1, or 2 args intuiting dir paths
      if they are omitted

## 0.1.1 / 2008-11-22
- Minor Additions
- Posts now support introspectional data e.g. {{ page.url }}

## 0.1.0 / 2008-11-05
- First release
- Converts posts written in Textile
- Converts regular site pages
- Simple copy of binary files

## 0.0.0 / 2008-10-19
- Birthday!
