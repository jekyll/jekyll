require "jekyll_test_plugin/version"
require "jekyll"

module JekyllTestPlugin
  class TestPage < Jekyll::Page
    def initialize(site, collection, name)
      @site = site
      @base = base
      @dir  = dir
      @name = name
      self.process(name)
      self.content = "this is a test"
      self.data = {}
    end
  end

  class TestGenerator < Jekyll::Generator
    safe true

    def generate(site)
      site.pages << TestPage.new(site, site.source, '', 'test.txt')
    end
  end
end
