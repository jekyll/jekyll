require 'fileutils'
require 'rr'
require 'test/unit'
require 'time'

JEKYLL_SOURCE_DIR = File.dirname(File.dirname(File.dirname(__FILE__)))
TEST_DIR    = File.expand_path(File.join('..', '..', 'tmp', 'jekyll'), File.dirname(__FILE__))
JEKYLL_PATH = File.join(File.dirname(__FILE__), '..', '..', 'bin', 'jekyll')
JEKYLL_COMMAND_OUTPUT_FILE = File.join(File.dirname(TEST_DIR), 'jekyll_output.txt')

def source_dir(*files)
  File.join(TEST_DIR, *files)
end

def jekyll_output_file
  JEKYLL_COMMAND_OUTPUT_FILE
end

def jekyll_run_output
  File.read(jekyll_output_file)
end

def run_jekyll(args)
  system "#{JEKYLL_PATH} #{args} --trace > #{jekyll_output_file} 2>&1"
end

def slug(title)
  if title
    title.downcase.gsub(/[^\w]/, " ").strip.gsub(/\s+/, '-')
  else
    Time.now.strftime("%s%9N") # nanoseconds since the Epoch
  end
end

def location(folder, direction)
  if folder
    before = folder if direction == "in"
    after = folder if direction == "under"
  end
  [before || '.', after || '.']
end

def file_contents(path)
  File.open(path) do |file|
    file.readlines.join # avoid differences with \n and \r\n line endings
  end
end

def seconds_agnostic_datetime(datetime = Time.now)
  date, time, zone = datetime.to_s.split(" ")
  time = seconds_agnostic_time(time)
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
