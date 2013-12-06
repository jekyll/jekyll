# Ease the installation of gem-based plugins by auto-requiring
# plugins in the Gemfile's :jekyll_plugin group
# 
# Example Gemfile file:
# 
# group :jekyll_plugins do
#   gem 'jekyll-liquid-plus'
# end
# 

begin
  require "rubygems"
  require "bundler/setup"
  Bundler.require(:jekyll_plugins)
rescue LoadError
end
