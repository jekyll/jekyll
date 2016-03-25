#!/usr/bin/env ruby
require 'benchmark/ips'

# For this pull request, which changes Page#dir
# https://github.com/jekyll/jekyll/pull/4403

CONTENT_CONTAINING = <<-HTML.freeze
<!DOCTYPE HTML>
<html lang="en-US">
  <head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <title>Jemoji</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="/css/screen.css">
  </head>
  <body class="wrap">
    <p><img class="emoji" title=":+1:" alt=":+1:" src="https://assets.github.com/images/icons/emoji/unicode/1f44d.png" height="20" width="20" align="absmiddle"></p>

  </body>
</html>
HTML
CONTENT_NOT_CONTAINING = <<-HTML.freeze
<!DOCTYPE HTML>
<html lang="en-US">
  <head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <title>Jemoji</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="/css/screen.css">
  </head>
  <body class="wrap">
    <p><img class="emoji" title=":+1:" alt=":+1:" src="https://assets.github.com/images/icons/emoji/unicode/1f44d.png" height="20" width="20" align="absmiddle"></p>

  </body>
</html>
HTML

Benchmark.ips do |x|
  x.report("no body include?") { CONTENT_NOT_CONTAINING.include?('<body') }
  x.report("no body regexp")   { CONTENT_NOT_CONTAINING =~ /<\s*body/ }
  x.compare!
end

# No trailing slash
Benchmark.ips do |x|
  x.report("with body include?") { CONTENT_CONTAINING.include?('<body') }
  x.report("with body regexp")   { CONTENT_CONTAINING =~ /<\s*body/ }
  x.compare!
end
