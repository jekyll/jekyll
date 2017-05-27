# jekyll-archives
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
  module ArchivesPlugin
    class Configuration < OpenStruct
      @@defaults = {
        :dirname  => 'archives',
        :template => '_templates/archive',
        :title    => 'Archives of &laquo;{year}&raquo; year'
      }

      def initialize config = {}
        super @@defaults.merge(config)

        self.dirname = self.dirname.gsub(/^\/+|\/+$/, '')
      end
    end


    module SitePatch
      def self.included base
        base.send :include, InstanceMethods

        base.class_eval do
          alias_method :site_payload_without_archive_years, :site_payload

          def site_payload
            years = posts.map{ |p| p.date.year }.uniq.sort.reverse
            site_payload_without_archive_years.deep_merge({
              'site' => { 'archive_years' => years }
            })
          end
        end
      end

      module InstanceMethods
        def archives_config
          @archives_config ||= Configuration.new(self.config['archives'] || {})
        end
      end
    end


    class Page
      include Convertible

      attr_reader :site, :year, :ext
      attr_accessor :content, :data, :ext, :output

      def initialize site, year, posts
        @site     = site
        @dirname  = site.archives_config.dirname
        @year     = year
        @posts    = posts.sort_by { |p| p.date }.reverse
        @ext      = '.html'

        self.read_yaml(template.parent.to_s, template.basename.to_s)
      end

      alias :name :year

      def template
        template = site.archives_config.template
        template << '.html' if File.extname(template).empty?

        @template ||= Pathname.new(site.source).join(template)
      end

      def url
        unless @url
          @url = "/#{@dirname}/#{@year}"
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
        site.archives_config.title.gsub(/\{year\}/, @year.to_s)
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
        "#<Jekyll:ArchivesPlugin:Page @year=#{@year.inspect}>"
      end
    end


    class Generator < Jekyll::Generator
      def generate site
        archives = Hash.new{ |h,k| h[k] = [] }

        site.posts.each do |post|
          archives[post.date.year] << post
        end

        archives.each do |year, posts|
          site.pages << Page.new(site, year, posts)
        end
      end
    end


    module Filters
      LINK = '<a href="%s">%s</a>'

      def archive_link archive
        return archive.map { |t| archive_link t } if archive.is_a? Array
        LINK % [ archive_url(archive), archive ]
      end

      def archive_url archive
        site = @context.registers[:site]
        url  = "/#{site.archives_config.dirname}/#{archive}"
        site.permalink_style == :pretty ? url : url << '.html'
      end
    end
  end
end


Jekyll::Site.send :include, Jekyll::ArchivesPlugin::SitePatch


Liquid::Template.register_filter Jekyll::ArchivesPlugin::Filters
