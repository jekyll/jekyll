# jekyll-tags
#
# Copyright (C) 2012 Aleksey V Zapparov (http://ixti.net/)
#
# The MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the “Software”), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# stdlib
require 'ostruct'


module Jekyll
  module TagsPlugin
    class Configuration < OpenStruct
      @@defaults = {
        :dirname  => 'tags',
        :template => '_templates/tag',
        :title    => 'Articles tagged with &laquo;{tag}&raquo;'
      }

      def initialize config = {}
        super @@defaults.merge(config)

        self.dirname = self.dirname.gsub(/^\/+|\/+$/, '')
      end
    end


    module SitePatch
      def tags_config
        @tags_config ||= Configuration.new(self.config['tags'] || {})
      end
    end


    class Page
      include Convertible

      attr_reader :site, :tag, :ext
      attr_accessor :content, :data, :ext, :output

      def initialize site, tag, posts
        @site     = site
        @dirname  = site.tags_config.dirname
        @tag      = tag
        @posts    = posts.sort_by { |p| p.date }.reverse
        @ext      = '.html'

        self.read_yaml(template.parent.to_s, template.basename.to_s)
      end

      alias :name :tag

      def template
        template = site.tags_config.template
        template << '.html' if File.extname(template).empty?

        @template ||= Pathname.new(site.source).join(template)
      end

      def url
        unless @url
          @url = "/#{@dirname}/#{@tag}"
          @url << ".html" unless :pretty == site.permalink_style
        end

        @url
      end

      def destination dest
        File.join(dest, url)
      end

      def render(layouts, site_payload)
        payload = { 'page' => self.to_liquid }.deep_merge(site_payload)
        do_layout(payload, layouts)
      end

      def title
        site.tags_config.title.gsub(/\{tag\}/, @tag)
      end

      def to_liquid
        self.data.deep_merge({
          "url"       => url,
          "content"   => self.content,
          "title"     => self.title,
          "posts"     => @posts
        })
      end

      def write dest
        path = destination dest

        FileUtils.mkdir_p File.dirname(path)
        File.open(path, 'w') { |f| f.write self.output }
      end

      def html?
        true
      end

      def inspect
        "#<Jekyll:TagsPlugin:Page @tag=#{@tag.inspect}>"
      end
    end


    class Generator < Jekyll::Generator
      def generate site
        site.tags.each do |tag, posts|
          site.pages << Page.new(site, tag, posts)
        end
      end
    end


    module Filters
      LINK = '<a href="%s">%s</a>'

      def tag_link tag
        return tag.map { |t| tag_link t } if tag.is_a? Array
        LINK % [ tag_url(tag), tag ]
      end

      def tag_url tag
        site = @context.registers[:site]
        url  = "/#{site.tags_config.dirname}/#{tag}"
        site.permalink_style == :pretty ? url : url << '.html'
      end
    end
  end
end


Jekyll::Site.send :include, Jekyll::TagsPlugin::SitePatch


Liquid::Template.register_filter Jekyll::TagsPlugin::Filters
