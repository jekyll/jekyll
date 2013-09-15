---
layout: docs
title: History
permalink: /docs/history/
prev_section: contributing
---

## 1.2.1 / 2013-09-14

### Minor Enhancements
- Print better messages for detached server. Mute output on detach. ([#1518]({{ site.repository }}/issues/1518))
- Disable reverse lookup when running `jekyll serve` ([#1363]({{ site.repository }}/issues/1363))
- Upgrade RedCarpet dependency to `~> 2.3.0` ([#1515]({{ site.repository }}/issues/1515))
- Upgrade to Liquid `>= 2.5.2, < 2.6` ([#1536]({{ site.repository }}/issues/1536))

### Bug Fixes
- Fix file discrepancy in gemspec ([#1522]({{ site.repository }}/issues/1522))
- Force rendering of Include tag ([#1525]({{ site.repository }}/issues/1525))

### Development Fixes
- Add a rake task to generate a new release post ([#1404]({{ site.repository }}/issues/1404))
- Mute LSI output in tests ([#1531]({{ site.repository }}/issues/1531))
- Update contributor documentation ([#1537]({{ site.repository }}/issues/1537))

### Site Enhancements
- Fix a couple of validation errors on the site ([#1511]({{ site.repository }}/issues/1511))
- Make navigation menus reusable ([#1507]({{ site.repository }}/issues/1507))
- Fix link to History page from Release v1.2.0 notes post.
- Fix markup in History file for command line options ([#1512]({{ site.repository }}/issues/1512))
- Expand 1.2 release post title to 1.2.0 ([#1516]({{ site.repository }}/issues/1516))

## 1.2.0 / 2013-09-06

### Major Enhancements
- Disable automatically-generated excerpts when `excerpt_separator` is `""`. ([#1386]({{ site.repository }}/issues/1386))
- Add checking for URL conflicts when running `jekyll doctor` ([#1389]({{ site.repository }}/issues/1389))

### Minor Enhancements
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

### Bug Fixes
- Require Liquid 2.5.1 ([#1349]({{ site.repository }}/issues/1349))

## 1.1.1 / 2013-07-24

### Minor Enhancements
- Remove superfluous `table` selector from main.css in `jekyll new` template ([#1328]({{ site.repository }}/issues/1328))
- Abort with non-zero exit codes ([#1338]({{ site.repository }}/issues/1338))

### Bug Fixes
- Fix up the rendering of excerpts ([#1339]({{ site.repository }}/issues/1339))

### Site Enhancements
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

### Major Enhancements
- Add `docs` subcommand to read Jekyll's docs when offline. ([#1046]({{ site.repository }}/issues/1046))
- Support passing parameters to templates in `include` tag ([#1204]({{ site.repository }}/issues/1204))
- Add support for Liquid tags to post excerpts ([#1302]({{ site.repository }}/issues/1302))

### Minor Enhancements
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
- Fix pagination in subdirectories. ([#1198]({{ site.repository }}/issues/1198))
- Fix an issue with directories and permalinks that have a plus sign
    (+) in them ([#1215]({{ site.repository }}/issues/1215))
- Provide better error reporting when generating sites ([#1253]({{ site.repository }}/issues/1253))
- Latest posts first in non-LSI `related_posts` ([#1271]({{ site.repository }}/issues/1271))

### Development Fixes
- Merge the theme and layout cucumber steps into one step ([#1151]({{ site.repository }}/issues/1151))
- Restrict activesupport dependency to pre-4.0.0 to maintain compatibility with `<= 1.9.2`
- Include/exclude deprecation handling simplification ([#1284]({{ site.repository }}/issues/1284))
- Convert README to Markdown. ([#1267]({{ site.repository }}/issues/1267))
- Refactor Jekyll::Site ([#1144]({{ site.repository }}/issues/1144))

### Site Enhancements
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
- Added site.pages to Variables page in docs ([#1251]({{ site.repository }}/issues/1251))
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

### Minor Enhancements
- Add support to gist tag for private gists. ([#1189]({{ site.repository }}/issues/1189))
- Fail loudly when MaRuKu errors out ([#1190]({{ site.repository }}/issues/1190))
- Move the building of related posts into their own class ([#1057]({{ site.repository }}/issues/1057))
- Removed trailing spaces in several places throughout the code ([#1116]({{ site.repository }}/issues/1116))
- Add a `--force` option to `jekyll new` ([#1115]({{ site.repository }}/issues/1115))
- Convert IDs in the site template to classes ([#1170]({{ site.repository }}/issues/1170))

### Bug Fixes
- Fix typo in Stevenson constant "ERROR". ([#1166]({{ site.repository }}/issues/1166))
- Rename Jekyll::Logger to Jekyll::Stevenson to fix inheritance issue ([#1106]({{ site.repository }}/issues/1106))
- Exit with a non-zero exit code when dealing with a Liquid error ([#1121]({{ site.repository }}/issues/1121))
- Make the `exclude` and `include` options backwards compatible with
    versions of Jekyll prior to 1.0 ([#1114]({{ site.repository }}/issues/1114))
- Fix pagination on Windows ([#1063]({{ site.repository }}/issues/1063))
- Fix the application of Pygments' Generic Output style to Go code
    ([#1156]({{ site.repository }}/issues/1156))

### Site Enhancements
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
- Use Jekyll.logger instead of Jekyll::Stevenson to log things ([#1149]({{ site.repository }}/issues/1149))
- Fix pesky Cucumber infinite loop ([#1139]({{ site.repository }}/issues/1139))
- Do not write posts with timezones in Cucumber tests ([#1124]({{ site.repository }}/issues/1124))
- Use ISO formatted dates in Cucumber features ([#1150]({{ site.repository }}/issues/1150))

## 1.0.2 / 2013-05-12

### Major Enhancements
- Add `jekyll doctor` command to check site for any known compatibility problems ([#1081]({{ site.repository }}/issues/1081))
- Backwards-compatibilize relative permalinks ([#1081]({{ site.repository }}/issues/1081))

### Minor Enhancements
- Add a `data-lang="<lang>"` attribute to Redcarpet code blocks ([#1066]({{ site.repository }}/issues/1066))
- Deprecate old config `server_port`, match to `port` if `port` isn't set ([#1084]({{ site.repository }}/issues/1084))
- Update pygments.rb version to 0.5.0 ([#1061]({{ site.repository }}/issues/1061))
- Update Kramdown version to 1.0.2 ([#1067]({{ site.repository }}/issues/1067))

### Bug Fixes
- Fix issue when categories are numbers ([#1078]({{ site.repository }}/issues/1078))
- Catching that Redcarpet gem isn't installed ([#1059]({{ site.repository }}/issues/1059))

### Site Enhancements
- Add documentation about `relative_permalinks` ([#1081]({{ site.repository }}/issues/1081))
- Remove pygments-installation instructions, as pygments.rb is bundled with it ([#1079]({{ site.repository }}/issues/1079))
- Move pages to be Pages for realz ([#985]({{ site.repository }}/issues/985))
- Updated links to Liquid documentation ([#1073]({{ site.repository }}/issues/1073))

## 1.0.1 / 2013-05-08

### Minor Enhancements
- Do not force use of toc_token when using generate_tok in RDiscount ([#1048]({{ site.repository }}/issues/1048))
- Add newer `language-` class name prefix to code blocks ([#1037]({{ site.repository }}/issues/1037))
- Commander error message now preferred over process abort with incorrect args ([#1040]({{ site.repository }}/issues/1040))

### Bug Fixes
- Make Redcarpet respect the pygments configuration option ([#1053]({{ site.repository }}/issues/1053))
- Fix the index build with LSI ([#1045]({{ site.repository }}/issues/1045))
- Don't print deprecation warning when no arguments are specified. ([#1041]({{ site.repository }}/issues/1041))
- Add missing `</div>` to site template used by `new` subcommand, fixed typos in code ([#1032]({{ site.repository }}/issues/1032))

### Site Enhancements
- Changed https to http in the GitHub Pages link ([#1051]({{ site.repository }}/issues/1051))
- Remove CSS cruft, fix typos, fix HTML errors ([#1028]({{ site.repository }}/issues/1028))
- Removing manual install of Pip and Distribute ([#1025]({{ site.repository }}/issues/1025))
- Updated URL for Markdown references plugin ([#1022]({{ site.repository }}/issues/1022))

### Development Fixes
- Markdownify history file ([#1027]({{ site.repository }}/issues/1027))
- Update links on README to point to new jekyllrb.com ([#1018]({{ site.repository }}/issues/1018))

## 1.0.0 / 2013-05-06

### Major Enhancements
- Add `jekyll new` subcommand: generate a jekyll scaffold ([#764]({{ site.repository }}/issues/764))
- Refactored jekyll commands into subcommands: build, serve, and migrate. ([#690]({{ site.repository }}/issues/690))
- Removed importers/migrators from main project, migrated to jekyll-import sub-gem ([#793]({{ site.repository }}/issues/793))
- Added ability to render drafts in `_drafts` folder via command line ([#833]({{ site.repository }}/issues/833))
- Add ordinal date permalink style (/:categories/:year/:y_day/:title.html) ([#928]({{ site.repository }}/issues/928))

### Minor Enhancements
- Site template HTML5-ified ([#964]({{ site.repository }}/issues/964))
- Use post's directory path when matching for the post_url tag ([#998]({{ site.repository }}/issues/998))
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
- Add paginator.previous_page_path and paginator.next_page_path ([#942]({{ site.repository }}/issues/942))
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
- Refactored jekyll subcommands into Jekyll::Commands submodule, which now contains them ([#768]({{ site.repository }}/issues/768))
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
- Bullet-proof limit_posts option ([#1004]({{ site.repository }}/issues/1004))
- Read in YAML as UTF-8 to accept non-ASCII chars ([#836]({{ site.repository }}/issues/836))
- Fix the CLI option `--plugins` to actually accept dirs and files ([#993]({{ site.repository }}/issues/993))
- Allow 'excerpt' in YAML Front-Matter to override the extracted excerpt ([#946]({{ site.repository }}/issues/946))
- Fix cascade problem with site.baseurl, site.port and site.host. ([#935]({{ site.repository }}/issues/935))
- Filter out directories with valid post names ([#875]({{ site.repository }}/issues/875))
- Fix symlinked static files not being correctly built in unsafe mode ([#909]({{ site.repository }}/issues/909))
- Fix integration with directory_watcher 1.4.x ([#916]({{ site.repository }}/issues/916))
- Accepting strings as arguments to jekyll-import command ([#910]({{ site.repository }}/issues/910))
- Force usage of older directory_watcher gem as 1.5 is broken ([#883]({{ site.repository }}/issues/883))
- Ensure all Post categories are downcase ([#842]({{ site.repository }}/issues/842), [#872]({{ site.repository }}/issues/872))
- Force encoding of the rdiscount TOC to UTF8 to avoid conversion errors ([#555]({{ site.repository }}/issues/555))
- Patch for multibyte URI problem with jekyll serve ([#723]({{ site.repository }}/issues/723))
- Order plugin execution by priority ([#864]({{ site.repository }}/issues/864))
- Fixed Page#dir and Page#url for edge cases ([#536]({{ site.repository }}/issues/536))
- Fix broken post_url with posts with a time in their YAML Front-Matter ([#831]({{ site.repository }}/issues/831))
- Look for plugins under the source directory ([#654]({{ site.repository }}/issues/654))
- Tumblr Migrator: finds `_posts` dir correctly, fixes truncation of long
      post names ([#775]({{ site.repository }}/issues/775))
- Force Categories to be Strings ([#767]({{ site.repository }}/issues/767))
- Safe YAML plugin to prevent vulnerability ([#777]({{ site.repository }}/issues/777))
- Add SVG support to Jekyll/WEBrick. ([#407]({{ site.repository }}/issues/407), [#406]({{ site.repository }}/issues/406))
- Prevent custom destination from causing continuous regen on watch ([#528]({{ site.repository }}/issues/528), [#820]({{ site.repository }}/issues/820), [#862]({{ site.repository }}/issues/862))

### Site Enhancements
- Responsify ([#860]({{ site.repository }}/issues/860))
- Fix spelling, punctuation and phrasal errors ([#989]({{ site.repository }}/issues/989))
- Update quickstart instructions with `new` command ([#966]({{ site.repository }}/issues/966))
- Add docs for page.excerpt ([#956]({{ site.repository }}/issues/956))
- Add docs for page.path ([#951]({{ site.repository }}/issues/951))
- Clean up site docs to prepare for 1.0 release ([#918]({{ site.repository }}/issues/918))
- Bring site into master branch with better preview/deploy ([#709]({{ site.repository }}/issues/709))
- Redesigned site ([#583]({{ site.repository }}/issues/583))

### Development Fixes
- Exclude Cucumber 1.2.4, which causes tests to fail in 1.9.2 ([#938]({{ site.repository }}/issues/938))
- Added "features:html" rake task for debugging purposes, cleaned up
      cucumber profiles ([#832]({{ site.repository }}/issues/832))
- Explicitly require HTTPS rubygems source in Gemfile ([#826]({{ site.repository }}/issues/826))
- Changed Ruby version for development to 1.9.3-p374 from p362 ([#801]({{ site.repository }}/issues/801))
- Including a link to the GitHub Ruby style guide in CONTRIBUTING.md ([#806]({{ site.repository }}/issues/806))
- Added script/bootstrap ([#776]({{ site.repository }}/issues/776))
- Running Simplecov under 2 conditions: ENV(COVERAGE)=true and with Ruby version
      of greater than 1.9 ([#771]({{ site.repository }}/issues/771))
- Switch to Simplecov for coverage report ([#765]({{ site.repository }}/issues/765))

## 0.12.1 / 2013-02-19
### Minor Enhancements
- Update Kramdown version to 0.14.1 ([#744]({{ site.repository }}/issues/744))
- Test Enhancements
- Update Rake version to 10.0.3 ([#744]({{ site.repository }}/issues/744))
- Update Shoulda version to 3.3.2 ([#744]({{ site.repository }}/issues/744))
- Update Redcarpet version to 2.2.2 ([#744]({{ site.repository }}/issues/744))

## 0.12.0 / 2012-12-22
### Minor Enhancements
- Add ability to explicitly specify included files ([#261]({{ site.repository }}/issues/261))
- Add --default-mimetype option ([#279]({{ site.repository }}/issues/279))
- Allow setting of RedCloth options ([#284]({{ site.repository }}/issues/284))
- Add post_url Liquid tag for internal post linking ([#369]({{ site.repository }}/issues/369))
- Allow multiple plugin dirs to be specified ([#438]({{ site.repository }}/issues/438))
- Inline TOC token support for RDiscount ([#333]({{ site.repository }}/issues/333))
- Add the option to specify the paginated url format ([#342]({{ site.repository }}/issues/342))
- Swap out albino for pygments.rb ([#569]({{ site.repository }}/issues/569))
- Support Redcarpet 2 and fenced code blocks ([#619]({{ site.repository }}/issues/619))
- Better reporting of Liquid errors ([#624]({{ site.repository }}/issues/624))
- Bug Fixes
- Allow some special characters in highlight names
- URL escape category names in URL generation ([#360]({{ site.repository }}/issues/360))
- Fix error with limit_posts ([#442]({{ site.repository }}/issues/442))
- Properly select dotfile during directory scan ([#363]({{ site.repository }}/issues/363), [#431]({{ site.repository }}/issues/431), [#377]({{ site.repository }}/issues/377))
- Allow setting of Kramdown smart_quotes ([#482]({{ site.repository }}/issues/482))
- Ensure front-matter is at start of file ([#562]({{ site.repository }}/issues/562))

## 0.11.2 / 2011-12-27
- Bug Fixes
- Fix gemspec

## 0.11.1 / 2011-12-27
- Bug Fixes
- Fix extra blank line in highlight blocks ([#409]({{ site.repository }}/issues/409))
- Update dependencies

## 0.11.0 / 2011-07-10
### Major Enhancements
- Add command line importer functionality ([#253]({{ site.repository }}/issues/253))
- Add Redcarpet Markdown support ([#318]({{ site.repository }}/issues/318))
- Make markdown/textile extensions configurable ([#312]({{ site.repository }}/issues/312))
- Add `markdownify` filter

### Minor Enhancements
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
- Bug Fixes
- Add --no-server option.

## 0.9.0 / 2010-12-15
### Minor Enhancements
- Use OptionParser's `[no-]` functionality for better boolean parsing.
- Add Drupal migrator ([#245]({{ site.repository }}/issues/245))
- Complain about YAML and Liquid errors ([#249]({{ site.repository }}/issues/249))
- Remove orphaned files during regeneration ([#247]({{ site.repository }}/issues/247))
- Add Marley migrator ([#28]({{ site.repository }}/issues/28))

## 0.8.0 / 2010-11-22
### Minor Enhancements
- Add wordpress.com importer ([#207]({{ site.repository }}/issues/207))
- Add --limit-posts cli option ([#212]({{ site.repository }}/issues/212))
- Add uri_escape filter ([#234]({{ site.repository }}/issues/234))
- Add --base-url cli option ([#235]({{ site.repository }}/issues/235))
- Improve MT migrator ([#238]({{ site.repository }}/issues/238))
- Add kramdown support ([#239]({{ site.repository }}/issues/239))
- Bug Fixes
- Fixed filename basename generation ([#208]({{ site.repository }}/issues/208))
- Set mode to UTF8 on Sequel connections ([#237]({{ site.repository }}/issues/237))
- Prevent `_includes` dir from being a symlink

## 0.7.0 / 2010-08-24
### Minor Enhancements
- Add support for rdiscount extensions ([#173]({{ site.repository }}/issues/173))
- Bug Fixes
- Highlight should not be able to render local files
- The site configuration may not always provide a 'time' setting ([#184]({{ site.repository }}/issues/184))

## 0.6.2 / 2010-06-25
- Bug Fixes
- Fix Rakefile 'release' task (tag pushing was missing origin)
- Ensure that RedCloth is loaded when textilize filter is used ([#183]({{ site.repository }}/issues/183))
- Expand source, destination, and plugin paths ([#180]({{ site.repository }}/issues/180))
- Fix page.url to include full relative path ([#181]({{ site.repository }}/issues/181))

## 0.6.1 / 2010-06-24
- Bug Fixes
- Fix Markdown Pygments prefix and suffix ([#178]({{ site.repository }}/issues/178))

## 0.6.0 / 2010-06-23
### Major Enhancements
- Proper plugin system ([#19]({{ site.repository }}/issues/19), [#100]({{ site.repository }}/issues/100))
- Add safe mode so unsafe converters/generators can be added
- Maruku is now the only processor dependency installed by default.
      Other processors will be lazy-loaded when necessary (and prompt the
      user to install them when necessary) ([#57]({{ site.repository }}/issues/57))

### Minor Enhancements
- Inclusion/exclusion of future dated posts ([#59]({{ site.repository }}/issues/59))
- Generation for a specific time ([#59]({{ site.repository }}/issues/59))
- Allocate site.time on render not per site_payload invocation ([#59]({{ site.repository }}/issues/59))
- Pages now present in the site payload and can be used through the
      site.pages and site.html_pages variables
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
- Fix source directory binding using Dir.pwd ([#75]({{ site.repository }}/issues/75))

## 0.5.7 / 2010-01-12
### Minor Enhancements
- Allow overriding of post date in the front matter ([#62]({{ site.repository }}/issues/62), [#38]({{ site.repository }}/issues/38))
- Bug Fixes
- Categories isn't always an array ([#73]({{ site.repository }}/issues/73))
- Empty tags causes error in read_posts ([#84]({{ site.repository }}/issues/84))
- Fix pagination to adhere to read/render/write paradigm
- Test Enhancement
- cucumber features no longer use site.posts.first where a better
      alternative is available

## 0.5.6 / 2010-01-08
- Bug Fixes
- Require redcloth >= 4.2.1 in tests ([#92]({{ site.repository }}/issues/92))
- Don't break on triple dashes in yaml frontmatter ([#93]({{ site.repository }}/issues/93))

### Minor Enhancements
- Allow .mkd as markdown extension
- Use $stdout/err instead of constants ([#99]({{ site.repository }}/issues/99))
- Properly wrap code blocks ([#91]({{ site.repository }}/issues/91))
- Add javascript mime type for webrick ([#98]({{ site.repository }}/issues/98))

## 0.5.5 / 2010-01-08
- Bug Fixes
- Fix pagination % 0 bug ([#78]({{ site.repository }}/issues/78))
- Ensure all posts are processed first ([#71]({{ site.repository }}/issues/71))

## NOTE
- After this point I will no longer be giving credit in the history;
    that is what the commit log is for.

## 0.5.4 / 2009-08-23
- Bug Fixes
- Do not allow symlinks (security vulnerability)

## 0.5.3 / 2009-07-14
- Bug Fixes
- Solving the permalink bug where non-html files wouldn't work
      ([@jeffrydegrande](https://github.com/jeffrydegrande))

## 0.5.2 / 2009-06-24
- Enhancements
- Added --paginate option to the executable along with a paginator object
      for the payload ([@calavera](https://github.com/calavera))
- Upgraded RedCloth to 4.2.1, which makes `<notextile>` tags work once
      again.
- Configuration options set in config.yml are now available through the
      site payload ([@vilcans](https://github.com/vilcans))
- Posts can now have an empty YAML front matter or none at all
      ([@bahuvrihi](https://github.com/bahuvrihi))
- Bug Fixes
- Fixing Ruby 1.9 issue that requires to_s on the err object
      ([@Chrononaut](https://github.com/Chrononaut))
- Fixes for pagination and ordering posts on the same day ([@ujh](https://github.com/ujh))
- Made pages respect permalinks style and permalinks in yml front matter
      ([@eugenebolshakov](https://github.com/eugenebolshakov))
- Index.html file should always have index.html permalink
      ([@eugenebolshakov](https://github.com/eugenebolshakov))
- Added trailing slash to pretty permalink style so Apache is happy
      ([@eugenebolshakov](https://github.com/eugenebolshakov))
- Bad markdown processor in config fails sooner and with better message
      ([@gcnovus](https://github.com/gcnovus))
- Allow CRLFs in yaml frontmatter ([@juretta](https://github.com/juretta))
- Added Date#xmlschema for Ruby versions < 1.9

## 0.5.1 / 2009-05-06
### Major Enhancements
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
### Minor Enhancements
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
- Changed date format on wordpress converter (zeropadding) ([@dysinger](https://github.com/dysinger))
- Bug Fixes
- Add jekyll binary as executable to gemspec ([@dysinger](https://github.com/dysinger))

## 0.4.0 / 2009-02-03
### Major Enhancements
- Switch to Jeweler for packaging tasks

### Minor Enhancements
- Type importer ([@codeslinger](https://github.com/codeslinger))
- site.topics accessor ([@baz](https://github.com/baz))
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
### Major Enhancements
- Added --server option to start a simple WEBrick server on destination
      directory ([@johnreilly](https://github.com/johnreilly) and [@mchung](https://github.com/mchung))

### Minor Enhancements
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
- Major Changes
- Use Maruku (pure Ruby) for Markdown by default ([@mreid](https://github.com/mreid))
- Allow use of RDiscount with --rdiscount flag

### Minor Enhancements
- Don't load directory_watcher unless it's needed ([@pjhyett](https://github.com/pjhyett))

## 0.2.0 / 2008-12-14
- Major Changes
- related_posts is now found in site.related_posts

## 0.1.6 / 2008-12-13
- Major Features
- Include files in `_includes` with {% raw %}`{% include x.textile %}`{% endraw %}

## 0.1.5 / 2008-12-12
### Major Enhancements
- Code highlighting with Pygments if --pygments is specified
- Disable true LSI by default, enable with --lsi

### Minor Enhancements
- Output informative message if RDiscount is not available ([@JackDanger](https://github.com/JackDanger))
- Bug Fixes
- Prevent Jekyll from picking up the output directory as a source ([@JackDanger](https://github.com/JackDanger))
- Skip `related_posts` when there is only one post ([@JackDanger](https://github.com/JackDanger))

## 0.1.4 / 2008-12-08
- Bug Fixes
- DATA does not work properly with rubygems

## 0.1.3 / 2008-12-06
- Major Features
- Markdown support ([@vanpelt](https://github.com/vanpelt))
- Mephisto and CSV converters ([@vanpelt](https://github.com/vanpelt))
- Code hilighting ([@vanpelt](https://github.com/vanpelt))
- Autobuild
- Bug Fixes
- Accept both \r\n and \n in YAML header ([@vanpelt](https://github.com/vanpelt))

## 0.1.2 / 2008-11-22
- Major Features
- Add a real "related posts" implementation using Classifier
- Command Line Changes
- Allow cli to be called with 0, 1, or 2 args intuiting dir paths
      if they are omitted

## 0.1.1 / 2008-11-22
- Minor Additions
- Posts now support introspectional data e.g. {% raw %}`{{ page.url }}`{% endraw %}

## 0.1.0 / 2008-11-05
- First release
- Converts posts written in Textile
- Converts regular site pages
- Simple copy of binary files

## 0.0.0 / 2008-10-19
- Birthday!
