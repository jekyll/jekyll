# jekyll-categories
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
  module CategoriesPlugin
    class Configuration < OpenStruct
      @@defaults = {
        :dirname  => 'categories',
        :template => '_templates/category',
        :title    => 'Articles under &laquo;{category}&raquo; category'
      }

      def initialize config = {}
        super @@defaults.merge(config)

        self.dirname = self.dirname.gsub(/^\/+|\/+$/, '')
      end
    end


    module SitePatch
      def categories_config
        @categories_config ||= Configuration.new(self.config['categories'] || {})
      end
    end


    module PostPatch
      def self.included base
        # and then provide our own
        base.send :include, InstanceMethods

        base.class_eval do
          alias_method :categories_without_better_autoguess, :categories
          alias_method :categories, :categories_with_better_autoguess

          alias_method :to_liquid_without_category, :to_liquid

          def to_liquid
            to_liquid_without_category.deep_merge({
              'category' => categories.first
            })
          end
        end
      end

      module InstanceMethods
        def categories_with_better_autoguess
          @categories ||= []

          @categories = get_categories_from_data if @categories.empty?
          @categories = get_categories_from_name if @categories.empty?

          @categories
        end

        protected

        def get_categories_from_data
          self.data.pluralized_array('category', 'categories')
        end

        def get_categories_from_name
          [ @name.split('/')[0...-1].reject{ |x| x.empty? }.join('/') ]
        end
      end
    end


    class Page
      include Convertible

      attr_reader :site, :category, :ext
      attr_accessor :content, :data, :ext, :output

      def initialize site, category, posts
        @site     = site
        @dirname  = site.categories_config.dirname
        @category = category
        @posts    = posts.sort_by { |p| p.date }.reverse
        @ext      = '.html'

        # make sure categoy is a String
        @category = @category.join '/' if @category.is_a? Array

        self.read_yaml(template.parent.to_s, template.basename.to_s)
      end

      alias :name :category

      def template
        template = site.categories_config.template
        template << '.html' if File.extname(template).empty?

        @template ||= Pathname.new(site.source).join(template)
      end

      def url
        unless @url
          @url = "/#{@dirname}/#{@category}"
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
        site.categories_config.title.gsub(/\{category\}/, @category)
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
        "#<Jekyll:CategoriesPlugin:Page @category=#{@category.inspect}>"
      end
    end


    class Generator < Jekyll::Generator
      def generate site
        site.categories.each do |category, posts|
          site.pages << Page.new(site, category, posts)
        end
      end
    end


    module Filters
      LINK = '<a href="%s">%s</a>'

      def category_link category
        return category.map { |t| category_link t } if category.is_a? Array
        LINK % [ category_url(category), category ]
      end

      def category_url category
        site = @context.registers[:site]
        url  = "/#{site.categories_config.dirname}/#{category}"
        site.permalink_style == :pretty ? url : url << '.html'
      end
    end
  end
end


Jekyll::Site.send :include, Jekyll::CategoriesPlugin::SitePatch
Jekyll::Post.send :include, Jekyll::CategoriesPlugin::PostPatch


Liquid::Template.register_filter Jekyll::CategoriesPlugin::Filters
