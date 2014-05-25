# [Jekyll](http://jekyllrb.com/)

[![Gem Version](https://badge.fury.io/rb/jekyll.png)](http://badge.fury.io/rb/jekyll)

[![Build Status](https://secure.travis-ci.org/jekyll/jekyll.png?branch=master)](https://travis-ci.org/jekyll/jekyll)
[![Code Climate](https://codeclimate.com/github/jekyll/jekyll.png)](https://codeclimate.com/github/jekyll/jekyll)
[![Dependency Status](https://gemnasium.com/jekyll/jekyll.png)](https://gemnasium.com/jekyll/jekyll)
[![Coverage Status](https://coveralls.io/repos/jekyll/jekyll/badge.png)](https://coveralls.io/r/jekyll/jekyll)

Tom Preston-Werner, Nick Quaranto や多くの[素晴らしいコントリビュータ](https://github.com/jekyll/jekyll/graphs/contributors)によって作成されています！

Jekyll は個人プロジェクトや組織のサイトに最適な、シンプルで、ブログを意識した静的サイトジェネレータです。
複雑さを排除したファイルベースのCMSのようなものと考えてください。
Jekyll はコンテンツを受け取り、 Markdown や Liquid テンプレート をレンダリングし、
Apache や Nginx やその他の Web サーバに提供する準備ができた静的な Web サイトを完全に出力してくれます。
Jekyll は [GitHub Pages](http://pages.github.com) の背後にあるエンジンなので、
あなたの GitHub リポジトリからサイトをホストするために使用する事ができます。

## 原理

Jekyll あなたがするように伝えたことをします ― それ以上でもそれ以下でもありません。
それは、大胆な仮定によってユーザの裏をかこうとせず、
また、不必要な複雑さや設定をユーザに負担しません。
簡単に言えば、 Jekyll はあなたの道を開け、
真に重要なもの: コンテンツに集中することができます。

## 開始方法

* gem を[インストール](http://jekyllrb.com/docs/installation/)します
* [使用方法](http://jekyllrb.com/docs/usage/) と [設定方法](http://jekyllrb.com/docs/configuration/) を読みます
* 既存の [Jekyll で作られたサイト](http://wiki.github.com/jekyll/jekyll/sites) をチラッと見ます
* Fork し、あなたの変更を [コントリビュート](http://jekyllrb.com/docs/contributing/) します
* 質問があったら？ irc.freenode.net の `#jekyll` チャンネルをチェックしてください

## より深く

* 以前のシステムからの[移行](http://jekyllrb.com/docs/migrations/)
* [YAML Front Matter](http://jekyllrb.com/docs/frontmatter/) がどのように働くかを学ぶ
* [変数](http://jekyllrb.com/docs/variables/)を使ってサイトに情報を表示する
* posts が生成される時の[パーマリンク](http://jekyllrb.com/docs/permalinks/)をカスタマイズ
* 人生を容易にするために、組み込みの [Liquid 拡張](http://jekyllrb.com/docs/templates/)を使用する
* あなたのサイト固有のコンテンツを生成するために、カスタム[プラグイン](http://jekyllrb.com/docs/plugins/)を使用する

## 実行時の依存関係

* Commander: コマンドラインインターフェース構築 (Ruby)
* Colorator: コマンドライン出力に色付け (Ruby)
* Classifier: posts の関連を生成 (Ruby)
* Directory Watcher: サイトの自動再生成 (Ruby)
* Kramdown: デフォルトの Markdown エンジン (Ruby)
* Liquid: テンプレートシステム (Ruby)
* Pygments.rb: シンタックスハイライト (Ruby/Python)
* RedCarpet: Markdown エンジン (Ruby)
* Safe YAML: セキュリティのために構築された YAML パーサ (Ruby)

## 開発時の依存関係

* Launchy: クロスプラットフォーム ファイルランチャ (Ruby)
* Maruku: Markdown スーパーセット インタプリタ (Ruby)
* RDiscount: Discount Markdown プロセッサ (Ruby)
* RedCloth: Textile サポート (Ruby)
* RedGreen: よりよいテスト出力 (Ruby)
* RR: モック (Ruby)
* Shoulda: テストフレームワーク (Ruby)
* SimpleCov: カバレッジフレームワーク (Ruby)

## ライセンス

[ライセンス](https://github.com/jekyll/jekyll/blob/master/LICENSE)を見てください。
