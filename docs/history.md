---
layout: docs
title: History
permalink: "/docs/history/"
prev_section: contributing
---

## 1.5.1 / 2014-03-27

### Bug Fixes

- Only strip the drive name if it begins the string ([#2176]({{ site.github.issues_url }}/2176))

## 1.5.0 / 2014-03-24

### Minor Enhancements

- Loosen `safe_yaml` dependency to `~> 1.0` ([#2167]({{ site.github.issues_url }}/2167))
- Bump `safe_yaml` dependency to `~> 1.0.0` ([#1942]({{ site.github.issues_url }}/1942))

### Bug Fixes

- Fix issue where filesystem traversal restriction broke Windows ([#2167]({{ site.github.issues_url }}/2167))
- Lock `maruku` at `0.7.0` ([#2167]({{ site.github.issues_url }}/2167))

### Development Fixes

- Lock `cucumber` at `1.3.11` ([#2167]({{ site.github.issues_url }}/2167))

## 1.4.3 / 2014-01-13

### Bug Fixes
- Patch show-stopping security vulnerabilities ([#1944]({{ site.github.issues_url }}/1944))

## 1.4.2 / 2013-12-16

### Bug Fixes
- Turn on Maruku fenced code blocks by default ([#1830]({{ site.github.issues_url }}/1830))

## 1.4.1 / 2013-12-09

### Bug Fixes
- Don't allow nil entries when loading posts ([#1796]({{ site.github.issues_url }}/1796))

## 1.4.0 / 2013-12-07

### Major Enhancements
- Add support for TOML config files ([#1765]({{ site.github.issues_url }}/1765))

### Minor Enhancements
- Sort plugins as a way to establish a load order ([#1682]({{ site.github.issues_url }}/1682))
- Update Maruku to 0.7.0 ([#1775]({{ site.github.issues_url }}/1775))

### Bug Fixes
- Add a space between two words in a Pagination warning message ([#1769]({{ site.github.issues_url }}/1769))
- Upgrade `toml` gem to `v0.1.0` to maintain compat with Ruby 1.8.7 ([#1778]({{ site.github.issues_url }}/1778))

### Development Fixes
- Remove some whitespace in the code ([#1755]({{ site.github.issues_url }}/1755))
- Remove some duplication in the reading of posts and drafts ([#1779]({{ site.github.issues_url }}/1779))

### Site Enhancements
- Fixed case of a word in the Jekyll v1.3.0 release post ([#1762]({{ site.github.issues_url }}/1762))
- Fixed the mime type for the favicon ([#1772]({{ site.github.issues_url }}/1772))

## 1.3.1 / 2013-11-26

### Minor Enhancements
- Add a `--prefix` option to passthrough for the importers ([#1669]({{ site.github.issues_url }}/1669))
- Push the paginator plugin lower in the plugin priority order so
    other plugins run before it ([#1759]({{ site.github.issues_url }}/1759))

### Bug Fixes
- Fix the include tag when ran in a loop ([#1726]({{ site.github.issues_url }}/1726))
- Fix errors when using `--watch` on 1.8.7 ([#1730]({{ site.github.issues_url }}/1730))
- Specify where the include is called from if an included file is
    missing ([#1746]({{ site.github.issues_url }}/1746))

### Development Fixes
- Extract `Site#filter_entries` into its own object ([#1697]({{ site.github.issues_url }}/1697))
- Enable Travis' bundle caching ([#1734]({{ site.github.issues_url }}/1734))
- Remove trailing whitespace in some files ([#1736]({{ site.github.issues_url }}/1736))
- Fix a duplicate test name ([#1754]({{ site.github.issues_url }}/1754))

### Site Enhancements
- Update link to example Rakefile to point to specific commit ([#1741]({{ site.github.issues_url }}/1741))
- Fix drafts docs to indicate that draft time is based on file modification
    time, not `Time.now` ([#1695]({{ site.github.issues_url }}/1695))
- Add `jekyll-monthly-archive-plugin` and `jekyll-category-archive-plugin` to
    list of third-party plugins ([#1693]({{ site.github.issues_url }}/1693))
- Add `jekyll-asset-path-plugin` to list of third-party plugins ([#1670]({{ site.github.issues_url }}/1670))
- Add `emoji-for-jekyll` to list of third-part plugins ([#1708]({{ site.github.issues_url }}/1708))
- Fix previous section link on plugins page to point to pagination page ([#1707]({{ site.github.issues_url }}/1707))
- Add `org-mode` converter plugin to third-party plugins ([#1711]({{ site.github.issues_url }}/1711))
- Point "Blog migrations" page to http://import.jekyllrb.com ([#1732]({{ site.github.issues_url }}/1732))
- Add docs for `post_url` when posts are in subdirectories ([#1718]({{ site.github.issues_url }}/1718))
- Update the docs to point to `example.com` ([#1448]({{ site.github.issues_url }}/1448))

## 1.3.0 / 2013-11-04

### Major Enhancements
- Add support for adding data as YAML files under a site's `_data`
    directory ([#1003]({{ site.github.issues_url }}/1003))
- Allow variables to be used with `include` tags ([#1495]({{ site.github.issues_url }}/1495))
- Allow using gems for plugin management ([#1557]({{ site.github.issues_url }}/1557))

### Minor Enhancements
- Decrease the specificity in the site template CSS ([#1574]({{ site.github.issues_url }}/1574))
- Add `encoding` configuration option ([#1449]({{ site.github.issues_url }}/1449))
- Provide better error handling for Jekyll's custom Liquid tags
    ([#1514]({{ site.github.issues_url }}/1514))
- If an included file causes a Liquid error, add the path to the
    include file that caused the error to the error message ([#1596]({{ site.github.issues_url }}/1596))
- If a layout causes a Liquid error, change the error message so that
    we know it comes from the layout ([#1601]({{ site.github.issues_url }}/1601))
- Update Kramdown dependency to `~> 1.2` ([#1610]({{ site.github.issues_url }}/1610))
- Update `safe_yaml` dependency to `~> 0.9.7` ([#1602]({{ site.github.issues_url }}/1602))
- Allow layouts to be in subfolders like includes ([#1622]({{ site.github.issues_url }}/1622))
- Switch to listen for site watching while serving ([#1589]({{ site.github.issues_url }}/1589))
- Add a `json` liquid filter to be used in sites ([#1651]({{ site.github.issues_url }}/1651))
- Point people to the migration docs when the `jekyll-import` gem is
    missing ([#1662]({{ site.github.issues_url }}/1662))

### Bug Fixes
- Fix up matching against source and destination when the two
    locations are similar ([#1556]({{ site.github.issues_url }}/1556))
- Fix the missing `pathname` require in certain cases ([#1255]({{ site.github.issues_url }}/1255))
- Use `+` instead of `Array#concat` when building `Post` attribute list ([#1571]({{ site.github.issues_url }}/1571))
- Print server address when launching a server ([#1586]({{ site.github.issues_url }}/1586))
- Downgrade to Maruku `~> 0.6.0` in order to avoid changes in rendering ([#1598]({{ site.github.issues_url }}/1598))
- Fix error with failing include tag when variable was file name ([#1613]({{ site.github.issues_url }}/1613))
- Downcase lexers before passing them to pygments ([#1615]({{ site.github.issues_url }}/1615))
- Capitalize the short verbose switch because it conflicts with the
    built-in Commander switch ([#1660]({{ site.github.issues_url }}/1660))
- Fix compatibility with 1.8.x ([#1665]({{ site.github.issues_url }}/1665))
- Fix an error with the new file watching code due to library version
    incompatibilities ([#1687]({{ site.github.issues_url }}/1687))

### Development Fixes
- Add coverage reporting with Coveralls ([#1539]({{ site.github.issues_url }}/1539))
- Refactor the Liquid `include` tag ([#1490]({{ site.github.issues_url }}/1490))
- Update launchy dependency to `~> 2.3` ([#1608]({{ site.github.issues_url }}/1608))
- Update rr dependency to `~> 1.1` ([#1604]({{ site.github.issues_url }}/1604))
- Update cucumber dependency to `~> 1.3` ([#1607]({{ site.github.issues_url }}/1607))
- Update coveralls dependency to `~> 0.7.0` ([#1606]({{ site.github.issues_url }}/1606))
- Update rake dependency to `~> 10.1` ([#1603]({{ site.github.issues_url }}/1603))
- Clean up `site.rb` comments to be more concise/uniform ([#1616]({{ site.github.issues_url }}/1616))
- Use the master branch for the build badge in the readme ([#1636]({{ site.github.issues_url }}/1636))
- Refactor Site#render ([#1638]({{ site.github.issues_url }}/1638))
- Remove duplication in command line options ([#1637]({{ site.github.issues_url }}/1637))
- Add tests for all the coderay options ([#1543]({{ site.github.issues_url }}/1543))
- Improve some of the cucumber test code ([#1493]({{ site.github.issues_url }}/1493))
- Improve comparisons of timestamps by ignoring the seconds ([#1582]({{ site.github.issues_url }}/1582))

### Site Enhancements
- Fix params for `JekyllImport::WordPress.process` arguments ([#1554]({{ site.github.issues_url }}/1554))
- Add `jekyll-suggested-tweet` to list of third-party plugins ([#1555]({{ site.github.issues_url }}/1555))
- Link to Liquid's docs for tags and filters ([#1553]({{ site.github.issues_url }}/1553))
- Add note about installing Xcode on the Mac in the Installation docs ([#1561]({{ site.github.issues_url }}/1561))
- Simplify/generalize pagination docs ([#1577]({{ site.github.issues_url }}/1577))
- Add documentation for the new data sources feature ([#1503]({{ site.github.issues_url }}/1503))
- Add more information on how to create generators ([#1590]({{ site.github.issues_url }}/1590), [#1592]({{ site.github.issues_url }}/1592))
- Improve the instructions for mimicking GitHub Flavored Markdown
    ([#1614]({{ site.github.issues_url }}/1614))
- Add `jekyll-import` warning note of missing dependencies ([#1626]({{ site.github.issues_url }}/1626))
- Fix grammar in the Usage section ([#1635]({{ site.github.issues_url }}/1635))
- Add documentation for the use of gems as plugins ([#1656]({{ site.github.issues_url }}/1656))
- Document the existence of a few additional plugins ([#1405]({{ site.github.issues_url }}/1405))
- Document that the `date_to_string` always returns a two digit day ([#1663]({{ site.github.issues_url }}/1663))
- Fix navigation in the "Working with Drafts" page ([#1667]({{ site.github.issues_url }}/1667))
- Fix an error with the data documentation ([#1691]({{ site.github.issues_url }}/1691))

## 1.2.1 / 2013-09-14

### Minor Enhancements
- Print better messages for detached server. Mute output on detach. ([#1518]({{ site.github.issues_url }}/1518))
- Disable reverse lookup when running `jekyll serve` ([#1363]({{ site.github.issues_url }}/1363))
- Upgrade RedCarpet dependency to `~> 2.3.0` ([#1515]({{ site.github.issues_url }}/1515))
- Upgrade to Liquid `>= 2.5.2, < 2.6` ([#1536]({{ site.github.issues_url }}/1536))

### Bug Fixes
- Fix file discrepancy in gemspec ([#1522]({{ site.github.issues_url }}/1522))
- Force rendering of Include tag ([#1525]({{ site.github.issues_url }}/1525))

### Development Fixes
- Add a rake task to generate a new release post ([#1404]({{ site.github.issues_url }}/1404))
- Mute LSI output in tests ([#1531]({{ site.github.issues_url }}/1531))
- Update contributor documentation ([#1537]({{ site.github.issues_url }}/1537))

### Site Enhancements
- Fix a couple of validation errors on the site ([#1511]({{ site.github.issues_url }}/1511))
- Make navigation menus reusable ([#1507]({{ site.github.issues_url }}/1507))
- Fix link to History page from Release v1.2.0 notes post.
- Fix markup in History file for command line options ([#1512]({{ site.github.issues_url }}/1512))
- Expand 1.2 release post title to 1.2.0 ([#1516]({{ site.github.issues_url }}/1516))

## 1.2.0 / 2013-09-06

### Major Enhancements
- Disable automatically-generated excerpts when `excerpt_separator` is `""`. ([#1386]({{ site.github.issues_url }}/1386))
- Add checking for URL conflicts when running `jekyll doctor` ([#1389]({{ site.github.issues_url }}/1389))

### Minor Enhancements
- Catch and fix invalid `paginate` values ([#1390]({{ site.github.issues_url }}/1390))
- Remove superfluous `div.container` from the default html template for
    `jekyll new` ([#1315]({{ site.github.issues_url }}/1315))
- Add `-D` short-form switch for the drafts option ([#1394]({{ site.github.issues_url }}/1394))
- Update the links in the site template for Twitter and GitHub ([#1400]({{ site.github.issues_url }}/1400))
- Update dummy email address to example.com domain ([#1408]({{ site.github.issues_url }}/1408))
- Update normalize.css to v2.1.2 and minify; add rake task to update
    normalize.css with greater ease. ([#1430]({{ site.github.issues_url }}/1430))
- Add the ability to detach the server ran by `jekyll serve` from it's
    controlling terminal ([#1443]({{ site.github.issues_url }}/1443))
- Improve permalink generation for URLs with special characters ([#944]({{ site.github.issues_url }}/944))
- Expose the current Jekyll version to posts and pages via a new
    `jekyll.version` variable ([#1481]({{ site.github.issues_url }}/1481))

### Bug Fixes
- Markdown extension matching matches only exact matches ([#1382]({{ site.github.issues_url }}/1382))
- Fixed NoMethodError when message passed to `Stevenson#message` is nil ([#1388]({{ site.github.issues_url }}/1388))
- Use binary mode when writing file ([#1364]({{ site.github.issues_url }}/1364))
- Fix 'undefined method `encoding` for "mailto"' errors w/ Ruby 1.8 and
    Kramdown > 0.14.0 ([#1397]({{ site.github.issues_url }}/1397))
- Do not force the permalink to be a dir if it ends on .html ([#963]({{ site.github.issues_url }}/963))
- When a Liquid Exception is caught, show the full path rel. to site source ([#1415]({{ site.github.issues_url }}/1415))
- Properly read in the config options when serving the docs locally
    ([#1444]({{ site.github.issues_url }}/1444))
- Fixed `--layouts` option for `build` and `serve` commands ([#1458]({{ site.github.issues_url }}/1458))
- Remove kramdown as a runtime dependency since it's optional ([#1498]({{ site.github.issues_url }}/1498))
- Provide proper error handling for invalid file names in the include
    tag ([#1494]({{ site.github.issues_url }}/1494))

### Development Fixes
- Remove redundant argument to
    Jekyll::Commands::New#scaffold_post_content ([#1356]({{ site.github.issues_url }}/1356))
- Add new dependencies to the README ([#1360]({{ site.github.issues_url }}/1360))
- Fix link to contributing page in README ([#1424]({{ site.github.issues_url }}/1424))
- Update TomDoc in Pager#initialize to match params ([#1441]({{ site.github.issues_url }}/1441))
- Refactor `Site#cleanup` into `Jekyll::Site::Cleaner` class ([#1429]({{ site.github.issues_url }}/1429))
- Several other small minor refactorings ([#1341]({{ site.github.issues_url }}/1341))
- Ignore `_site` in jekyllrb.com deploy ([#1480]({{ site.github.issues_url }}/1480))
- Add Gem version and dependency badge to README ([#1497]({{ site.github.issues_url }}/1497))

### Site Enhancements
- Add info about new releases ([#1353]({{ site.github.issues_url }}/1353))
- Update plugin list with jekyll-rss plugin ([#1354]({{ site.github.issues_url }}/1354))
- Update the site list page with Ruby's official site ([#1358]({{ site.github.issues_url }}/1358))
- Add `jekyll-ditaa` to list of third-party plugins ([#1370]({{ site.github.issues_url }}/1370))
- Add `postfiles` to list of third-party plugins ([#1373]({{ site.github.issues_url }}/1373))
- For internal links, use full path including trailing `/` ([#1411]({{ site.github.issues_url }}/1411))
- Use curly apostrophes in the docs ([#1419]({{ site.github.issues_url }}/1419))
- Update the docs for Redcarpet in Jekyll ([#1418]({{ site.github.issues_url }}/1418))
- Add `pluralize` and `reading_time` filters to docs ([#1439]({{ site.github.issues_url }}/1439))
- Fix markup for the Kramdown options ([#1445]({{ site.github.issues_url }}/1445))
- Fix typos in the History file ([#1454]({{ site.github.issues_url }}/1454))
- Add trailing slash to site's post URL ([#1462]({{ site.github.issues_url }}/1462))
- Clarify that `--config` will take multiple files ([#1474]({{ site.github.issues_url }}/1474))
- Fix docs/templates.md private gist example ([#1477]({{ site.github.issues_url }}/1477))
- Use `site.repository` for Jekyll's GitHub URL ([#1463]({{ site.github.issues_url }}/1463))
- Add `jekyll-pageless-redirects` to list of third-party plugins ([#1486]({{ site.github.issues_url }}/1486))
- Clarify that `date_to_xmlschema` returns an ISO 8601 string ([#1488]({{ site.github.issues_url }}/1488))
- Add `jekyll-good-include` to list of third-party plugins ([#1491]({{ site.github.issues_url }}/1491))
- XML escape the blog post title in our feed ([#1501]({{ site.github.issues_url }}/1501))
- Add `jekyll-toc-generator` to list of third-party plugins ([#1506]({{ site.github.issues_url }}/1506))

## 1.1.2 / 2013-07-25

### Bug Fixes
- Require Liquid 2.5.1 ([#1349]({{ site.github.issues_url }}/1349))

## 1.1.1 / 2013-07-24

### Minor Enhancements
- Remove superfluous `table` selector from main.css in `jekyll new` template ([#1328]({{ site.github.issues_url }}/1328))
- Abort with non-zero exit codes ([#1338]({{ site.github.issues_url }}/1338))

### Bug Fixes
- Fix up the rendering of excerpts ([#1339]({{ site.github.issues_url }}/1339))

### Site Enhancements
- Add Jekyll Image Tag to the plugins list ([#1306]({{ site.github.issues_url }}/1306))
- Remove erroneous statement that `site.pages` are sorted alphabetically.
- Add info about the `_drafts` directory to the directory structure
    docs ([#1320]({{ site.github.issues_url }}/1320))
- Improve the layout of the plugin listing by organizing it into
    categories ([#1310]({{ site.github.issues_url }}/1310))
- Add generator-jekyllrb and grunt-jekyll to plugins page ([#1330]({{ site.github.issues_url }}/1330))
- Mention Kramdown as option for markdown parser on Extras page ([#1318]({{ site.github.issues_url }}/1318))
- Update Quick-Start page to include reminder that all requirements must be installed ([#1327]({{ site.github.issues_url }}/1327))
- Change filename in `include` example to an HTML file so as not to indicate that Jekyll
    will automatically convert them. ([#1303]({{ site.github.issues_url }}/1303))
- Add an RSS feed for commits to Jekyll ([#1343]({{ site.github.issues_url }}/1343))

## 1.1.0 / 2013-07-14

### Major Enhancements
- Add `docs` subcommand to read Jekyll's docs when offline. ([#1046]({{ site.github.issues_url }}/1046))
- Support passing parameters to templates in `include` tag ([#1204]({{ site.github.issues_url }}/1204))
- Add support for Liquid tags to post excerpts ([#1302]({{ site.github.issues_url }}/1302))

### Minor Enhancements
- Search the hierarchy of pagination path up to site root to determine template page for
    pagination. ([#1198]({{ site.github.issues_url }}/1198))
- Add the ability to generate a new Jekyll site without a template ([#1171]({{ site.github.issues_url }}/1171))
- Use redcarpet as the default markdown engine in newly generated
    sites ([#1245]({{ site.github.issues_url }}/1245), [#1247]({{ site.github.issues_url }}/1247))
- Add `redcarpet` as a runtime dependency so `jekyll build` works out-of-the-box for new
    sites. ([#1247]({{ site.github.issues_url }}/1247))
- In the generated site, remove files that will be replaced by a
    directory ([#1118]({{ site.github.issues_url }}/1118))
- Fail loudly if a user-specified configuration file doesn't exist ([#1098]({{ site.github.issues_url }}/1098))
- Allow for all options for Kramdown HTML Converter ([#1201]({{ site.github.issues_url }}/1201))

### Bug Fixes
- Fix pagination in subdirectories. ([#1198]({{ site.github.issues_url }}/1198))
- Fix an issue with directories and permalinks that have a plus sign
    (+) in them ([#1215]({{ site.github.issues_url }}/1215))
- Provide better error reporting when generating sites ([#1253]({{ site.github.issues_url }}/1253))
- Latest posts first in non-LSI `related_posts` ([#1271]({{ site.github.issues_url }}/1271))

### Development Fixes
- Merge the theme and layout cucumber steps into one step ([#1151]({{ site.github.issues_url }}/1151))
- Restrict activesupport dependency to pre-4.0.0 to maintain compatibility with `<= 1.9.2`
- Include/exclude deprecation handling simplification ([#1284]({{ site.github.issues_url }}/1284))
- Convert README to Markdown. ([#1267]({{ site.github.issues_url }}/1267))
- Refactor Jekyll::Site ([#1144]({{ site.github.issues_url }}/1144))

### Site Enhancements
- Add "News" section for release notes, along with an RSS feed ([#1093]({{ site.github.issues_url }}/1093), [#1285]({{ site.github.issues_url }}/1285), [#1286]({{ site.github.issues_url }}/1286))
- Add "History" page.
- Restructured docs sections to include "Meta" section.
- Add message to "Templates" page that specifies that Python must be installed in order
    to use Pygments. ([#1182]({{ site.github.issues_url }}/1182))
- Update link to the official Maruku repo ([#1175]({{ site.github.issues_url }}/1175))
- Add documentation about `paginate_path` to "Templates" page in docs ([#1129]({{ site.github.issues_url }}/1129))
- Give the quick-start guide its own page ([#1191]({{ site.github.issues_url }}/1191))
- Update ProTip on Installation page in docs to point to all the info about Pygments and
    the 'highlight' tag. ([#1196]({{ site.github.issues_url }}/1196))
- Run `site/img` through ImageOptim (thanks [@qrush](https://github.com/qrush)!) ([#1208]({{ site.github.issues_url }}/1208))
- Added Jade Converter to `site/docs/plugins` ([#1210]({{ site.github.issues_url }}/1210))
- Fix location of docs pages in Contributing pages ([#1214]({{ site.github.issues_url }}/1214))
- Add ReadInXMinutes plugin to the plugin list ([#1222]({{ site.github.issues_url }}/1222))
- Remove plugins from the plugin list that have equivalents in Jekyll
    proper ([#1223]({{ site.github.issues_url }}/1223))
- Add jekyll-assets to the plugin list ([#1225]({{ site.github.issues_url }}/1225))
- Add jekyll-pandoc-mulitple-formats to the plugin list ([#1229]({{ site.github.issues_url }}/1229))
- Remove dead link to "Using Git to maintain your blog" ([#1227]({{ site.github.issues_url }}/1227))
- Tidy up the third-party plugins listing ([#1228]({{ site.github.issues_url }}/1228))
- Update contributor information ([#1192]({{ site.github.issues_url }}/1192))
- Update URL of article about Blogger migration ([#1242]({{ site.github.issues_url }}/1242))
- Specify that RedCarpet is the default for new Jekyll sites on Quickstart page ([#1247]({{ site.github.issues_url }}/1247))
- Added site.pages to Variables page in docs ([#1251]({{ site.github.issues_url }}/1251))
- Add Youku and Tudou Embed link on Plugins page. ([#1250]({{ site.github.issues_url }}/1250))
- Add note that `gist` tag supports private gists. ([#1248]({{ site.github.issues_url }}/1248))
- Add `jekyll-timeago` to list of third-party plugins. ([#1260]({{ site.github.issues_url }}/1260))
- Add `jekyll-swfobject` to list of third-party plugins. ([#1263]({{ site.github.issues_url }}/1263))
- Add `jekyll-picture-tag` to list of third-party plugins. ([#1280]({{ site.github.issues_url }}/1280))
- Update the GitHub Pages documentation regarding relative URLs
    ([#1291]({{ site.github.issues_url }}/1291))
- Update the S3 deployment documentation ([#1294]({{ site.github.issues_url }}/1294))
- Add suggestion for Xcode CLT install to troubleshooting page in docs ([#1296]({{ site.github.issues_url }}/1296))
- Add 'Working with drafts' page to docs ([#1289]({{ site.github.issues_url }}/1289))
- Add information about time zones to the documentation for a page's
    date ([#1304]({{ site.github.issues_url }}/1304))

## 1.0.3 / 2013-06-07

### Minor Enhancements
- Add support to gist tag for private gists. ([#1189]({{ site.github.issues_url }}/1189))
- Fail loudly when MaRuKu errors out ([#1190]({{ site.github.issues_url }}/1190))
- Move the building of related posts into their own class ([#1057]({{ site.github.issues_url }}/1057))
- Removed trailing spaces in several places throughout the code ([#1116]({{ site.github.issues_url }}/1116))
- Add a `--force` option to `jekyll new` ([#1115]({{ site.github.issues_url }}/1115))
- Convert IDs in the site template to classes ([#1170]({{ site.github.issues_url }}/1170))

### Bug Fixes
- Fix typo in Stevenson constant "ERROR". ([#1166]({{ site.github.issues_url }}/1166))
- Rename Jekyll::Logger to Jekyll::Stevenson to fix inheritance issue ([#1106]({{ site.github.issues_url }}/1106))
- Exit with a non-zero exit code when dealing with a Liquid error ([#1121]({{ site.github.issues_url }}/1121))
- Make the `exclude` and `include` options backwards compatible with
    versions of Jekyll prior to 1.0 ([#1114]({{ site.github.issues_url }}/1114))
- Fix pagination on Windows ([#1063]({{ site.github.issues_url }}/1063))
- Fix the application of Pygments' Generic Output style to Go code
    ([#1156]({{ site.github.issues_url }}/1156))

### Site Enhancements
- Add a Pro Tip to docs about front matter variables being optional ([#1147]({{ site.github.issues_url }}/1147))
- Add changelog to site as History page in /docs/ ([#1065]({{ site.github.issues_url }}/1065))
- Add note to Upgrading page about new config options in 1.0.x ([#1146]({{ site.github.issues_url }}/1146))
- Documentation for `date_to_rfc822` and `uri_escape` ([#1142]({{ site.github.issues_url }}/1142))
- Documentation highlight boxes shouldn't show scrollbars if not necessary ([#1123]({{ site.github.issues_url }}/1123))
- Add link to jekyll-minibundle in the doc's plugins list ([#1035]({{ site.github.issues_url }}/1035))
- Quick patch for importers documentation
- Fix prefix for WordpressDotCom importer in docs ([#1107]({{ site.github.issues_url }}/1107))
- Add jekyll-contentblocks plugin to docs ([#1068]({{ site.github.issues_url }}/1068))
- Make code bits in notes look more natural, more readable ([#1089]({{ site.github.issues_url }}/1089))
- Fix logic for `relative_permalinks` instructions on Upgrading page ([#1101]({{ site.github.issues_url }}/1101))
- Add docs for post excerpt ([#1072]({{ site.github.issues_url }}/1072))
- Add docs for gist tag ([#1072]({{ site.github.issues_url }}/1072))
- Add docs indicating that Pygments does not need to be installed
    separately ([#1099]({{ site.github.issues_url }}/1099), [#1119]({{ site.github.issues_url }}/1119))
- Update the migrator docs to be current ([#1136]({{ site.github.issues_url }}/1136))
- Add the Jekyll Gallery Plugin to the plugin list ([#1143]({{ site.github.issues_url }}/1143))

### Development Fixes
- Use Jekyll.logger instead of Jekyll::Stevenson to log things ([#1149]({{ site.github.issues_url }}/1149))
- Fix pesky Cucumber infinite loop ([#1139]({{ site.github.issues_url }}/1139))
- Do not write posts with timezones in Cucumber tests ([#1124]({{ site.github.issues_url }}/1124))
- Use ISO formatted dates in Cucumber features ([#1150]({{ site.github.issues_url }}/1150))

## 1.0.2 / 2013-05-12

### Major Enhancements
- Add `jekyll doctor` command to check site for any known compatibility problems ([#1081]({{ site.github.issues_url }}/1081))
- Backwards-compatibilize relative permalinks ([#1081]({{ site.github.issues_url }}/1081))

### Minor Enhancements
- Add a `data-lang="<lang>"` attribute to Redcarpet code blocks ([#1066]({{ site.github.issues_url }}/1066))
- Deprecate old config `server_port`, match to `port` if `port` isn't set ([#1084]({{ site.github.issues_url }}/1084))
- Update pygments.rb version to 0.5.0 ([#1061]({{ site.github.issues_url }}/1061))
- Update Kramdown version to 1.0.2 ([#1067]({{ site.github.issues_url }}/1067))

### Bug Fixes
- Fix issue when categories are numbers ([#1078]({{ site.github.issues_url }}/1078))
- Catching that Redcarpet gem isn't installed ([#1059]({{ site.github.issues_url }}/1059))

### Site Enhancements
- Add documentation about `relative_permalinks` ([#1081]({{ site.github.issues_url }}/1081))
- Remove pygments-installation instructions, as pygments.rb is bundled with it ([#1079]({{ site.github.issues_url }}/1079))
- Move pages to be Pages for realz ([#985]({{ site.github.issues_url }}/985))
- Updated links to Liquid documentation ([#1073]({{ site.github.issues_url }}/1073))

## 1.0.1 / 2013-05-08

### Minor Enhancements
- Do not force use of toc_token when using generate_tok in RDiscount ([#1048]({{ site.github.issues_url }}/1048))
- Add newer `language-` class name prefix to code blocks ([#1037]({{ site.github.issues_url }}/1037))
- Commander error message now preferred over process abort with incorrect args ([#1040]({{ site.github.issues_url }}/1040))

### Bug Fixes
- Make Redcarpet respect the pygments configuration option ([#1053]({{ site.github.issues_url }}/1053))
- Fix the index build with LSI ([#1045]({{ site.github.issues_url }}/1045))
- Don't print deprecation warning when no arguments are specified. ([#1041]({{ site.github.issues_url }}/1041))
- Add missing `</div>` to site template used by `new` subcommand, fixed typos in code ([#1032]({{ site.github.issues_url }}/1032))

### Site Enhancements
- Changed https to http in the GitHub Pages link ([#1051]({{ site.github.issues_url }}/1051))
- Remove CSS cruft, fix typos, fix HTML errors ([#1028]({{ site.github.issues_url }}/1028))
- Removing manual install of Pip and Distribute ([#1025]({{ site.github.issues_url }}/1025))
- Updated URL for Markdown references plugin ([#1022]({{ site.github.issues_url }}/1022))

### Development Fixes
- Markdownify history file ([#1027]({{ site.github.issues_url }}/1027))
- Update links on README to point to new jekyllrb.com ([#1018]({{ site.github.issues_url }}/1018))

## 1.0.0 / 2013-05-06

### Major Enhancements
- Add `jekyll new` subcommand: generate a jekyll scaffold ([#764]({{ site.github.issues_url }}/764))
- Refactored jekyll commands into subcommands: build, serve, and migrate. ([#690]({{ site.github.issues_url }}/690))
- Removed importers/migrators from main project, migrated to jekyll-import sub-gem ([#793]({{ site.github.issues_url }}/793))
- Added ability to render drafts in `_drafts` folder via command line ([#833]({{ site.github.issues_url }}/833))
- Add ordinal date permalink style (/:categories/:year/:y_day/:title.html) ([#928]({{ site.github.issues_url }}/928))

### Minor Enhancements
- Site template HTML5-ified ([#964]({{ site.github.issues_url }}/964))
- Use post's directory path when matching for the post_url tag ([#998]({{ site.github.issues_url }}/998))
- Loosen dependency on Pygments so it's only required when it's needed ([#1015]({{ site.github.issues_url }}/1015))
- Parse strings into Time objects for date-related Liquid filters ([#1014]({{ site.github.issues_url }}/1014))
- Tell the user if there is no subcommand specified ([#1008]({{ site.github.issues_url }}/1008))
- Freak out if the destination of `jekyll new` exists and is non-empty ([#981]({{ site.github.issues_url }}/981))
- Add `timezone` configuration option for compilation ([#957]({{ site.github.issues_url }}/957))
- Add deprecation messages for pre-1.0 CLI options ([#959]({{ site.github.issues_url }}/959))
- Refactor and colorize logging ([#959]({{ site.github.issues_url }}/959))
- Refactor Markdown parsing ([#955]({{ site.github.issues_url }}/955))
- Added application/vnd.apple.pkpass to mime.types served by WEBrick ([#907]({{ site.github.issues_url }}/907))
- Move template site to default markdown renderer ([#961]({{ site.github.issues_url }}/961))
- Expose new attribute to Liquid via `page`: `page.path` ([#951]({{ site.github.issues_url }}/951))
- Accept multiple config files from command line ([#945]({{ site.github.issues_url }}/945))
- Add page variable to liquid custom tags and blocks ([#413]({{ site.github.issues_url }}/413))
- Add paginator.previous_page_path and paginator.next_page_path ([#942]({{ site.github.issues_url }}/942))
- Backwards compatibility for 'auto' ([#821]({{ site.github.issues_url }}/821), [#934]({{ site.github.issues_url }}/934))
- Added date_to_rfc822 used on RSS feeds ([#892]({{ site.github.issues_url }}/892))
- Upgrade version of pygments.rb to 0.4.2 ([#927]({{ site.github.issues_url }}/927))
- Added short month (e.g. "Sep") to permalink style options for posts ([#890]({{ site.github.issues_url }}/890))
- Expose site.baseurl to Liquid templates ([#869]({{ site.github.issues_url }}/869))
- Adds excerpt attribute to posts which contains first paragraph of content ([#837]({{ site.github.issues_url }}/837))
- Accept custom configuration file via CLI ([#863]({{ site.github.issues_url }}/863))
- Load in GitHub Pages MIME Types on `jekyll serve` ([#847]({{ site.github.issues_url }}/847), [#871]({{ site.github.issues_url }}/871))
- Improve debugability of error message for a malformed highlight tag ([#785]({{ site.github.issues_url }}/785))
- Allow symlinked files in unsafe mode ([#824]({{ site.github.issues_url }}/824))
- Add 'gist' Liquid tag to core ([#822]({{ site.github.issues_url }}/822), [#861]({{ site.github.issues_url }}/861))
- New format of Jekyll output ([#795]({{ site.github.issues_url }}/795))
- Reinstate `--limit_posts` and `--future` switches ([#788]({{ site.github.issues_url }}/788))
- Remove ambiguity from command descriptions ([#815]({{ site.github.issues_url }}/815))
- Fix SafeYAML Warnings ([#807]({{ site.github.issues_url }}/807))
- Relaxed Kramdown version to 0.14 ([#808]({{ site.github.issues_url }}/808))
- Aliased `jekyll server` to `jekyll serve`. ([#792]({{ site.github.issues_url }}/792))
- Updated gem versions for Kramdown, Rake, Shoulda, Cucumber, and RedCarpet. ([#744]({{ site.github.issues_url }}/744))
- Refactored jekyll subcommands into Jekyll::Commands submodule, which now contains them ([#768]({{ site.github.issues_url }}/768))
- Rescue from import errors in Wordpress.com migrator ([#671]({{ site.github.issues_url }}/671))
- Massively accelerate LSI performance ([#664]({{ site.github.issues_url }}/664))
- Truncate post slugs when importing from Tumblr ([#496]({{ site.github.issues_url }}/496))
- Add glob support to include, exclude option ([#743]({{ site.github.issues_url }}/743))
- Layout of Page or Post defaults to 'page' or 'post', respectively ([#580]({{ site.github.issues_url }}/580))
    REPEALED by ([#977]({{ site.github.issues_url }}/977))
- "Keep files" feature ([#685]({{ site.github.issues_url }}/685))
- Output full path & name for files that don't parse ([#745]({{ site.github.issues_url }}/745))
- Add source and destination directory protection ([#535]({{ site.github.issues_url }}/535))
- Better YAML error message ([#718]({{ site.github.issues_url }}/718))
- Bug Fixes
- Paginate in subdirectories properly ([#1016]({{ site.github.issues_url }}/1016))
- Ensure post and page URLs have a leading slash ([#992]({{ site.github.issues_url }}/992))
- Catch all exceptions, not just StandardError descendents ([#1007]({{ site.github.issues_url }}/1007))
- Bullet-proof limit_posts option ([#1004]({{ site.github.issues_url }}/1004))
- Read in YAML as UTF-8 to accept non-ASCII chars ([#836]({{ site.github.issues_url }}/836))
- Fix the CLI option `--plugins` to actually accept dirs and files ([#993]({{ site.github.issues_url }}/993))
- Allow 'excerpt' in YAML Front-Matter to override the extracted excerpt ([#946]({{ site.github.issues_url }}/946))
- Fix cascade problem with site.baseurl, site.port and site.host. ([#935]({{ site.github.issues_url }}/935))
- Filter out directories with valid post names ([#875]({{ site.github.issues_url }}/875))
- Fix symlinked static files not being correctly built in unsafe mode ([#909]({{ site.github.issues_url }}/909))
- Fix integration with directory_watcher 1.4.x ([#916]({{ site.github.issues_url }}/916))
- Accepting strings as arguments to jekyll-import command ([#910]({{ site.github.issues_url }}/910))
- Force usage of older directory_watcher gem as 1.5 is broken ([#883]({{ site.github.issues_url }}/883))
- Ensure all Post categories are downcase ([#842]({{ site.github.issues_url }}/842), [#872]({{ site.github.issues_url }}/872))
- Force encoding of the rdiscount TOC to UTF8 to avoid conversion errors ([#555]({{ site.github.issues_url }}/555))
- Patch for multibyte URI problem with jekyll serve ([#723]({{ site.github.issues_url }}/723))
- Order plugin execution by priority ([#864]({{ site.github.issues_url }}/864))
- Fixed Page#dir and Page#url for edge cases ([#536]({{ site.github.issues_url }}/536))
- Fix broken post_url with posts with a time in their YAML Front-Matter ([#831]({{ site.github.issues_url }}/831))
- Look for plugins under the source directory ([#654]({{ site.github.issues_url }}/654))
- Tumblr Migrator: finds `_posts` dir correctly, fixes truncation of long
      post names ([#775]({{ site.github.issues_url }}/775))
- Force Categories to be Strings ([#767]({{ site.github.issues_url }}/767))
- Safe YAML plugin to prevent vulnerability ([#777]({{ site.github.issues_url }}/777))
- Add SVG support to Jekyll/WEBrick. ([#407]({{ site.github.issues_url }}/407), [#406]({{ site.github.issues_url }}/406))
- Prevent custom destination from causing continuous regen on watch ([#528]({{ site.github.issues_url }}/528), [#820]({{ site.github.issues_url }}/820), [#862]({{ site.github.issues_url }}/862))

### Site Enhancements
- Responsify ([#860]({{ site.github.issues_url }}/860))
- Fix spelling, punctuation and phrasal errors ([#989]({{ site.github.issues_url }}/989))
- Update quickstart instructions with `new` command ([#966]({{ site.github.issues_url }}/966))
- Add docs for page.excerpt ([#956]({{ site.github.issues_url }}/956))
- Add docs for page.path ([#951]({{ site.github.issues_url }}/951))
- Clean up site docs to prepare for 1.0 release ([#918]({{ site.github.issues_url }}/918))
- Bring site into master branch with better preview/deploy ([#709]({{ site.github.issues_url }}/709))
- Redesigned site ([#583]({{ site.github.issues_url }}/583))

### Development Fixes
- Exclude Cucumber 1.2.4, which causes tests to fail in 1.9.2 ([#938]({{ site.github.issues_url }}/938))
- Added "features:html" rake task for debugging purposes, cleaned up
      cucumber profiles ([#832]({{ site.github.issues_url }}/832))
- Explicitly require HTTPS rubygems source in Gemfile ([#826]({{ site.github.issues_url }}/826))
- Changed Ruby version for development to 1.9.3-p374 from p362 ([#801]({{ site.github.issues_url }}/801))
- Including a link to the GitHub Ruby style guide in CONTRIBUTING.md ([#806]({{ site.github.issues_url }}/806))
- Added script/bootstrap ([#776]({{ site.github.issues_url }}/776))
- Running Simplecov under 2 conditions: ENV(COVERAGE)=true and with Ruby version
      of greater than 1.9 ([#771]({{ site.github.issues_url }}/771))
- Switch to Simplecov for coverage report ([#765]({{ site.github.issues_url }}/765))

## 0.12.1 / 2013-02-19
### Minor Enhancements
- Update Kramdown version to 0.14.1 ([#744]({{ site.github.issues_url }}/744))
- Test Enhancements
- Update Rake version to 10.0.3 ([#744]({{ site.github.issues_url }}/744))
- Update Shoulda version to 3.3.2 ([#744]({{ site.github.issues_url }}/744))
- Update Redcarpet version to 2.2.2 ([#744]({{ site.github.issues_url }}/744))

## 0.12.0 / 2012-12-22
### Minor Enhancements
- Add ability to explicitly specify included files ([#261]({{ site.github.issues_url }}/261))
- Add --default-mimetype option ([#279]({{ site.github.issues_url }}/279))
- Allow setting of RedCloth options ([#284]({{ site.github.issues_url }}/284))
- Add post_url Liquid tag for internal post linking ([#369]({{ site.github.issues_url }}/369))
- Allow multiple plugin dirs to be specified ([#438]({{ site.github.issues_url }}/438))
- Inline TOC token support for RDiscount ([#333]({{ site.github.issues_url }}/333))
- Add the option to specify the paginated url format ([#342]({{ site.github.issues_url }}/342))
- Swap out albino for pygments.rb ([#569]({{ site.github.issues_url }}/569))
- Support Redcarpet 2 and fenced code blocks ([#619]({{ site.github.issues_url }}/619))
- Better reporting of Liquid errors ([#624]({{ site.github.issues_url }}/624))
- Bug Fixes
- Allow some special characters in highlight names
- URL escape category names in URL generation ([#360]({{ site.github.issues_url }}/360))
- Fix error with limit_posts ([#442]({{ site.github.issues_url }}/442))
- Properly select dotfile during directory scan ([#363]({{ site.github.issues_url }}/363), [#431]({{ site.github.issues_url }}/431), [#377]({{ site.github.issues_url }}/377))
- Allow setting of Kramdown smart_quotes ([#482]({{ site.github.issues_url }}/482))
- Ensure front-matter is at start of file ([#562]({{ site.github.issues_url }}/562))

## 0.11.2 / 2011-12-27
- Bug Fixes
- Fix gemspec

## 0.11.1 / 2011-12-27
- Bug Fixes
- Fix extra blank line in highlight blocks ([#409]({{ site.github.issues_url }}/409))
- Update dependencies

## 0.11.0 / 2011-07-10
### Major Enhancements
- Add command line importer functionality ([#253]({{ site.github.issues_url }}/253))
- Add Redcarpet Markdown support ([#318]({{ site.github.issues_url }}/318))
- Make markdown/textile extensions configurable ([#312]({{ site.github.issues_url }}/312))
- Add `markdownify` filter

### Minor Enhancements
- Switch to Albino gem
- Bundler support
- Use English library to avoid hoops ([#292]({{ site.github.issues_url }}/292))
- Add Posterous importer ([#254]({{ site.github.issues_url }}/254))
- Fixes for Wordpress importer ([#274]({{ site.github.issues_url }}/274), [#252]({{ site.github.issues_url }}/252), [#271]({{ site.github.issues_url }}/271))
- Better error message for invalid post date ([#291]({{ site.github.issues_url }}/291))
- Print formatted fatal exceptions to stdout on build failure
- Add Tumblr importer ([#323]({{ site.github.issues_url }}/323))
- Add Enki importer ([#320]({{ site.github.issues_url }}/320))
- Bug Fixes
- Secure additional path exploits

## 0.10.0 / 2010-12-16
- Bug Fixes
- Add --no-server option.

## 0.9.0 / 2010-12-15
### Minor Enhancements
- Use OptionParser's `[no-]` functionality for better boolean parsing.
- Add Drupal migrator ([#245]({{ site.github.issues_url }}/245))
- Complain about YAML and Liquid errors ([#249]({{ site.github.issues_url }}/249))
- Remove orphaned files during regeneration ([#247]({{ site.github.issues_url }}/247))
- Add Marley migrator ([#28]({{ site.github.issues_url }}/28))

## 0.8.0 / 2010-11-22
### Minor Enhancements
- Add wordpress.com importer ([#207]({{ site.github.issues_url }}/207))
- Add --limit-posts cli option ([#212]({{ site.github.issues_url }}/212))
- Add uri_escape filter ([#234]({{ site.github.issues_url }}/234))
- Add --base-url cli option ([#235]({{ site.github.issues_url }}/235))
- Improve MT migrator ([#238]({{ site.github.issues_url }}/238))
- Add kramdown support ([#239]({{ site.github.issues_url }}/239))
- Bug Fixes
- Fixed filename basename generation ([#208]({{ site.github.issues_url }}/208))
- Set mode to UTF8 on Sequel connections ([#237]({{ site.github.issues_url }}/237))
- Prevent `_includes` dir from being a symlink

## 0.7.0 / 2010-08-24
### Minor Enhancements
- Add support for rdiscount extensions ([#173]({{ site.github.issues_url }}/173))
- Bug Fixes
- Highlight should not be able to render local files
- The site configuration may not always provide a 'time' setting ([#184]({{ site.github.issues_url }}/184))

## 0.6.2 / 2010-06-25
- Bug Fixes
- Fix Rakefile 'release' task (tag pushing was missing origin)
- Ensure that RedCloth is loaded when textilize filter is used ([#183]({{ site.github.issues_url }}/183))
- Expand source, destination, and plugin paths ([#180]({{ site.github.issues_url }}/180))
- Fix page.url to include full relative path ([#181]({{ site.github.issues_url }}/181))

## 0.6.1 / 2010-06-24
- Bug Fixes
- Fix Markdown Pygments prefix and suffix ([#178]({{ site.github.issues_url }}/178))

## 0.6.0 / 2010-06-23
### Major Enhancements
- Proper plugin system ([#19]({{ site.github.issues_url }}/19), [#100]({{ site.github.issues_url }}/100))
- Add safe mode so unsafe converters/generators can be added
- Maruku is now the only processor dependency installed by default.
      Other processors will be lazy-loaded when necessary (and prompt the
      user to install them when necessary) ([#57]({{ site.github.issues_url }}/57))

### Minor Enhancements
- Inclusion/exclusion of future dated posts ([#59]({{ site.github.issues_url }}/59))
- Generation for a specific time ([#59]({{ site.github.issues_url }}/59))
- Allocate site.time on render not per site_payload invocation ([#59]({{ site.github.issues_url }}/59))
- Pages now present in the site payload and can be used through the
      site.pages and site.html_pages variables
- Generate phase added to site#process and pagination is now a generator
- Switch to RakeGem for build/test process
- Only regenerate static files when they have changed ([#142]({{ site.github.issues_url }}/142))
- Allow arbitrary options to Pygments ([#31]({{ site.github.issues_url }}/31))
- Allow URL to be set via command line option ([#147]({{ site.github.issues_url }}/147))
- Bug Fixes
- Render highlighted code for non markdown/textile pages ([#116]({{ site.github.issues_url }}/116))
- Fix highlighting on Ruby 1.9 ([#65]({{ site.github.issues_url }}/65))
- Fix extension munging when pretty permalinks are enabled ([#64]({{ site.github.issues_url }}/64))
- Stop sorting categories ([#33]({{ site.github.issues_url }}/33))
- Preserve generated attributes over front matter ([#119]({{ site.github.issues_url }}/119))
- Fix source directory binding using Dir.pwd ([#75]({{ site.github.issues_url }}/75))

## 0.5.7 / 2010-01-12
### Minor Enhancements
- Allow overriding of post date in the front matter ([#62]({{ site.github.issues_url }}/62), [#38]({{ site.github.issues_url }}/38))
- Bug Fixes
- Categories isn't always an array ([#73]({{ site.github.issues_url }}/73))
- Empty tags causes error in read_posts ([#84]({{ site.github.issues_url }}/84))
- Fix pagination to adhere to read/render/write paradigm
- Test Enhancement
- cucumber features no longer use site.posts.first where a better
      alternative is available

## 0.5.6 / 2010-01-08
- Bug Fixes
- Require redcloth >= 4.2.1 in tests ([#92]({{ site.github.issues_url }}/92))
- Don't break on triple dashes in yaml frontmatter ([#93]({{ site.github.issues_url }}/93))

### Minor Enhancements
- Allow .mkd as markdown extension
- Use $stdout/err instead of constants ([#99]({{ site.github.issues_url }}/99))
- Properly wrap code blocks ([#91]({{ site.github.issues_url }}/91))
- Add javascript mime type for webrick ([#98]({{ site.github.issues_url }}/98))

## 0.5.5 / 2010-01-08
- Bug Fixes
- Fix pagination % 0 bug ([#78]({{ site.github.issues_url }}/78))
- Ensure all posts are processed first ([#71]({{ site.github.issues_url }}/71))

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
