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

def seconds_agnostic_datetime(datetime = Time.now)
  pieces = datetime.to_s.split(" ")
  if pieces.size == 6 # Ruby 1.8.7
    date = pieces[0..2].join(" ")
    time = seconds_agnostic_time(pieces[3]) 
    zone = pieces[4..5].join(" ")
  else # Ruby 1.9.1 or greater
    date, time, zone = pieces
    time = seconds_agnostic_time(time)
  end
  [
    Regexp.escape(date),
    "#{time}:\\d{2}",
    Regexp.escape(zone)
  ].join("\\ ")
end

def seconds_agnostic_time(time)
  if time.is_a? Time
    time = time.strftime("%H:%M:%S")
  end
  hour, minutes, _ = time.split(":")
  "#{hour}:#{minutes}"
end

# work around "invalid option: --format" cucumber bug (see #296)
Test::Unit.run = true if RUBY_VERSION < '1.9'
