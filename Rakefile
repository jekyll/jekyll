require 'rubygems'
require 'rake'
require 'rdoc'
require 'date'
require 'yaml'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))
require 'jekyll/version'

Dir.glob('rake/**.rake').each { |f| import f }

#############################################################################
#
# Helper functions
#
#############################################################################

def name
  "jekyll"
end

def version
  Jekyll::VERSION
end

def docs_name
  "#{name}-docs"
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{Gem::Version.new(version).to_s}.gem"
end

def normalize_bullets(markdown)
  markdown.gsub(/\n\s{2}\*{1}/, "\n-")
end

def linkify_prs(markdown)
  markdown.gsub(/#(\d+)/) do |word|
    "[#{word}]({{ site.repository }}/issues/#{word.delete("#")})"
  end
end

def linkify_users(markdown)
  markdown.gsub(/(@\w+)/) do |username|
    "[#{username}](https://github.com/#{username.delete("@")})"
  end
end

def linkify(markdown)
  linkify_users(linkify_prs(markdown))
end

def liquid_escape(markdown)
  markdown.gsub(/(`{[{%].+[}%]}`)/, "{% raw %}\\1{% endraw %}")
end

def custom_release_header_anchors(markdown)
  header_regexp = /^(\d{1,2})\.(\d{1,2})\.(\d{1,2}) \/ \d{4}-\d{2}-\d{2}/
  section_regexp = /^### \w+ \w+$/
  markdown.split(/^##\s/).map do |release_notes|
    _, major, minor, patch = *release_notes.match(header_regexp)
    release_notes
      .gsub(header_regexp, "\\0\n{: #v\\1-\\2-\\3}")
      .gsub(section_regexp) { |section| "#{section}\n{: ##{sluffigy(section)}-v#{major}-#{minor}-#{patch}}" }
  end.join("\n## ")
end

def sluffigy(header)
  header.gsub(/#/, '').strip.downcase.gsub(/\s+/, '-')
end

def remove_head_from_history(markdown)
  index = markdown =~ /^##\s+\d+\.\d+\.\d+/
  markdown[index..-1]
end

def converted_history(markdown)
  remove_head_from_history(
    custom_release_header_anchors(
      liquid_escape(
        linkify(
          normalize_bullets(markdown)))))
end

#############################################################################
#
# Standard tasks
#
#############################################################################

multitask :default => [:test, :features]

task :spec => :test
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "#{name} #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) do |t|
    t.profile = "travis"
  end
  Cucumber::Rake::Task.new(:"features:html", "Run Cucumber features and produce HTML output") do |t|
    t.profile = "html_report"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end
