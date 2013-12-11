require 'coveralls'
Coveralls.wear_merged!

require 'fileutils'
require 'rr'
require 'test/unit'
require 'time'

TEST_DIR    = File.join('/', 'tmp', 'jekyll')
JEKYLL_PATH = File.join(File.dirname(__FILE__), '..', '..', 'bin', 'jekyll')
JEKYLL_COMMAND_OUTPUT_FILE = File.join('/', 'tmp', 'jekyll_output.txt')

def jekyll_output_file
  JEKYLL_COMMAND_OUTPUT_FILE
end

def jekyll_run_output
  File.read(jekyll_output_file)
end

def run_jekyll(args, output_file)
  command = "#{JEKYLL_PATH} #{args} > #{jekyll_output_file} 2>&1"
  system command
end

def run_jekyll_build(build_args = "")
  if !run_jekyll("build #{build_args}", jekyll_output_file) || build_args.eql?("--verbose")
    puts jekyll_run_output
  end
end

def run_jekyll_new(new_args = "")
  unless run_jekyll("new #{new_args}", jekyll_output_file)
    puts jekyll_run_output
  end
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
