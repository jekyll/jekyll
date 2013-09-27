if RUBY_VERSION > '1.9'
  require 'coveralls'
  Coveralls.wear_merged!
end

require 'fileutils'
require 'rr'
require 'test/unit'
require 'time'

TEST_DIR    = File.join('/', 'tmp', 'jekyll')
JEKYLL_PATH = File.join(File.dirname(__FILE__), '..', '..', 'bin', 'jekyll')

def run_jekyll(opts = {})
  command = JEKYLL_PATH.clone
  command << " build"
  command << " --drafts" if opts[:drafts]
  command << " >> /dev/null 2>&1" if opts[:debug].nil?
  system command
end

def call_jekyll_new(opts = {})
  command = JEKYLL_PATH.clone
  command << " new"
  command << " #{opts[:path]}" if opts[:path]
  command << " --blank" if opts[:blank]
  command << " >> /dev/null 2>&1" if opts[:debug].nil?
  system command
end

def slug(title)
  title.downcase.gsub(/[^\w]/, " ").strip.gsub(/\s+/, '-')
end

def location(folder, direction)
  if folder
    before = folder if direction == "in"
    after = folder if direction == "under"
  end
  [before || '.', after || '.']
end

def seconds_agnostic_time(datetime = Time.now)
  pieces = datetime.to_s.split(" ")
  time = "#{pieces[1].split(':').first}:#{pieces[1].split(':')[1]}:\\d{2}"
  [
    Regexp.escape(pieces[0]),
    time,
    Regexp.escape(pieces.last)
  ].join("\\ ")
end

# work around "invalid option: --format" cucumber bug (see #296)
Test::Unit.run = true if RUBY_VERSION < '1.9'
