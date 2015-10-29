require 'fileutils'
require 'posix-spawn'
require 'minitest/spec'
require 'time'

class MinitestWorld
  extend Minitest::Assertions
  attr_accessor :assertions

  def initialize
    self.assertions = 0
  end
end

JEKYLL_SOURCE_DIR = File.dirname(File.dirname(File.dirname(__FILE__)))
TEST_DIR    = File.expand_path(File.join('..', '..', 'tmp', 'jekyll'), File.dirname(__FILE__))
JEKYLL_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'bin', 'jekyll'))
JEKYLL_COMMAND_OUTPUT_FILE = File.join(File.dirname(TEST_DIR), 'jekyll_output.txt')
JEKYLL_COMMAND_STATUS_FILE = File.join(File.dirname(TEST_DIR), 'jekyll_status.txt')

def source_dir(*files)
  File.join(TEST_DIR, *files)
end

def all_steps_to_path(path)
  source = Pathname.new(source_dir('_site')).expand_path
  dest   = Pathname.new(path).expand_path
  paths  = []
  dest.ascend do |f|
    break if f.eql? source
    paths.unshift f.to_s
  end
  paths
end

def jekyll_output_file
  JEKYLL_COMMAND_OUTPUT_FILE
end

def jekyll_status_file
  JEKYLL_COMMAND_STATUS_FILE
end

def jekyll_run_output
  File.read(jekyll_output_file) if File.file?(jekyll_output_file)
end

def jekyll_run_status
  (File.read(jekyll_status_file) rescue 0).to_i
end

def run_bundle(args)
  run_in_shell('bundle', *args.strip.split(' '))
end

def run_jekyll(args)
  child = run_in_shell(JEKYLL_PATH, *args.strip.split(' '), "--trace")
  child.status.exitstatus == 0
end

# -----------------------------------------------------------------------------
# XXX: POSIX::Spawn::Child does not write output when the exit status is > 0
#        for example when doing [:out, :err] => [file, "w"] it will skip
#        writing the file entirely, we sould switch to Open.
# -----------------------------------------------------------------------------

def run_in_shell(*args)
  spawned = POSIX::Spawn::Child.new(*args)
  status = spawned.status.exitstatus
  File.write(JEKYLL_COMMAND_STATUS_FILE, status)
  File.open(JEKYLL_COMMAND_OUTPUT_FILE, "w+") do |file|
    status == 0 ? file.write(spawned.out) : file.write(spawned.err)
  end

  spawned
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
