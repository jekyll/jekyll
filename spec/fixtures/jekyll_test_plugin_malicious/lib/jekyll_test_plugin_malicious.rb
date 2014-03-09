require "jekyll_test_plugin_malicious/version"
require "jekyll"

module JekyllTestPluginMalicious
  class MaliciousPlugin < Jekyll::Generator
    def generate(site)
      raise "ALL YOUR COMPUTER ARE BELONG TO US"
    end
  end
end
