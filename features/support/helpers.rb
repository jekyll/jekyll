# frozen_string_literal: true

require "fileutils"
require "jekyll"
require "time"
require "safe_yaml/load"

class Paths
  SOURCE_DIR = Pathname.new(File.expand_path("../..", __dir__))
  def self.test_dir; source_dir.join("tmp", "jekyll"); end

  def self.theme_gem_dir; source_dir.join("tmp", "jekyll", "my-cool-theme"); end

  def self.output_file; test_dir.join("jekyll_output.txt"); end

  def self.status_file; test_dir.join("jekyll_status.txt"); end

  def self.jekyll_bin; source_dir.join("exe", "jekyll"); end

  def self.source_dir; SOURCE_DIR; end
end

#

def file_content_from_hash(input_hash)
  matter_hash = input_hash.reject { |k, _v| k == "content" }
  matter = matter_hash.map do |k, v|
    "#{k}: #{v}\n"
  end

  matter = matter.join.chomp
  content = \
    if !input_hash["input"] || !input_hash["filter"]
      then input_hash["content"]
    else "{{ #{input_hash["input"]} | " \
        "#{input_hash["filter"]} }}"
    end

  Jekyll::Utils.strip_heredoc(<<-EOF)
    ---
    #{matter.gsub(
      %r!\n!, "\n    "
    )}
    ---
    #{content}
  EOF
end

#

def source_dir(*files)
  return Paths.test_dir(*files)
end

#

def all_steps_to_path(path)
  source = source_dir
  dest = Pathname.new(path).expand_path
  paths = []

  dest.ascend do |f|
    break if f == source
    paths.unshift f.to_s
  end

  paths
end

#

def jekyll_run_output
  if Paths.output_file.file?
    then return Paths.output_file.read
  end
end

#

def jekyll_run_status
  if Paths.status_file.file?
    then return Paths.status_file.read
  end
end

#

def run_bundle(args)
  run_in_shell("bundle", *args.strip.split(" "))
end

#

def run_rubygem(args)
  run_in_shell("gem", *args.strip.split(" "))
end

#

def run_jekyll(args)
  args = args.strip.split(" ") # Shellwords?
  process = run_in_shell("ruby", Paths.jekyll_bin.to_s, *args, "--trace")
  process.exitstatus.zero?
end

#
def run_in_shell(*args)
  p, output = Jekyll::Utils::Exec.run(*args)

  File.write(Paths.status_file, p.exitstatus)
  File.open(Paths.output_file, "wb") do |f|
    f.print "$ "
    f.puts args.join(" ")
    f.puts output
    f.puts "EXIT STATUS: #{p.exitstatus}"
  end

  p
end

#

def slug(title = nil)
  if !title
    then Time.now.strftime("%s%9N") # nanoseconds since the Epoch
  else title.downcase.gsub(%r![^\w]!, " ").strip.gsub(%r!\s+!, "-")
  end
end

#

def location(folder, direction)
  if folder
    before = folder if direction == "in"
    after  = folder if direction == "under"
  end

  [before || ".",
    after || ".",]
end

#

def file_contents(path)
  return Pathname.new(path).read
end

#

def seconds_agnostic_datetime(datetime = Time.now)
  date, time, zone = datetime.to_s.split(" ")
  time = seconds_agnostic_time(time)

  [
    Regexp.escape(date),
    "#{time}:\\d{2}",
    Regexp.escape(zone),
  ] \
    .join("\\ ")
end

#

def seconds_agnostic_time(time)
  time = time.strftime("%H:%M:%S") if time.is_a?(Time)
  hour, minutes, = time.split(":")
  "#{hour}:#{minutes}"
end

# Helper method for Windows
def dst_active?
  config = Jekyll.configuration("quiet" => true)
  ENV["TZ"] = config["timezone"]
  dst = Time.now.isdst

  # reset variable to default state on Windows
  ENV["TZ"] = nil
  dst
end
