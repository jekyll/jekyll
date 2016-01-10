require 'rubygems'
require 'rake'
require 'rdoc'
require 'date'
require 'yaml'

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require 'jekyll/version'

#

def name; "jekyll" end
def docs_name; "#{name}-docs" end
def gem_file; "#{name}-#{Gem::Version.new(version)}.gem"; end
def normalize_bullets(markdown); markdown.gsub(/\n\s{2}\*{1}/, "\n-") end
def gemspec_file; "#{name}.gemspec" end
def version; Jekyll::VERSION end

#

def linkify_prs(markdown)
  markdown.gsub(/#(\d+)/) do |word|
    "[#{word}]({{ site.repository }}/issues/#{word.delete("#")})"
  end
end

#

def linkify_users(markdown)
  markdown.gsub(/(@\w+)/) do |username|
    "[#{username}](https://github.com/#{username.delete("@")})"
  end
end

#

def linkify(markdown)
  linkify_users(linkify_prs(markdown))
end

#

def liquid_escape(markdown)
  markdown.gsub(/(`{[{%].+[}%]}`)/, "{% raw %}\\1{% endraw %}")
end

#

def custom_release_header_anchors(markdown)
  header_regexp = %r!^(\d{1,2})\.(\d{1,2})\.(\d{1,2}) \/ \d{4}-\d{2}-\d{2}!
  section_regexp = /^### \w+ \w+$/

  markdown.split(/^##\s/).map do |release_notes|
    _, major, minor, patch = *release_notes.match(header_regexp)
    release_notes
      .gsub(header_regexp, "\\0\n{: #v\\1-\\2-\\3}")
      .gsub(section_regexp) do |section|
        "#{section}\n{: ##{sluffigy(section)}-v#{major}-#{minor}-#{patch}}"
      end
  end \
    .join("\n## ")
end

#

def sluffigy(header)
  header.delete("#").strip.downcase.gsub(/\s+/, '-')
end

#

def remove_head_from_history(markdown)
  index = markdown =~ /^##\s+\d+\.\d+\.\d+/
  markdown[index..-1]
end

#

def converted_history(markdown)
  remove_head_from_history(custom_release_header_anchors(
    liquid_escape(linkify(
      normalize_bullets(markdown)
    ))
  ))
end

#

multitask :default => [:test, :features]
Dir.glob('rake/**.rake').each do |f|
  import f
end
