Before do
  FileUtils.mkdir_p(Paths.test_dir) unless Paths.test_dir.directory?
  Dir.chdir(Paths.test_dir)
end

#

After do
  Paths.test_dir.rmtree if Paths.test_dir.exist?
  Paths.output_file.delete if Paths.output_file.exist?
  Paths.status_file.delete if Paths.status_file.exist?
  Dir.chdir(Paths.test_dir.parent)
end

#

Given %r{^I have a blank site in "(.*)"$} do |path|
  if !File.exist?(path)
    then FileUtils.mkdir_p(path)
  end
end

#

Given %r{^I do not have a "(.*)" directory$} do |path|
  Paths.test_dir.join(path).directory?
end

#

Given %r{^I have an? "(.*)" page(?: with (.*) "(.*)")? that contains "(.*)"$} do |file, key, value, text|
  File.write(file, Jekyll::Utils.strip_heredoc(<<-DATA))
    ---
    #{key || 'layout'}: #{value || 'nil'}
    ---

    #{text}
  DATA
end

#

Given %r{^I have an? "(.*)" file that contains "(.*)"$} do |file, text|
  File.write(file, text)
end

#

Given %r{^I have an? (.*) (layout|theme) that contains "(.*)"$} do |name, type, text|
  folder = type == "layout" ? "_layouts" : "_theme"

  destination_file = Pathname.new(File.join(folder, "#{name}.html"))
  FileUtils.mkdir_p(destination_file.parent) unless destination_file.parent.directory?
  File.write(destination_file, text)
end

#

Given %r{^I have an? "(.*)" file with content:$} do |file, text|
  File.write(file, text)
end

#

Given %r{^I have an? (.*) directory$} do |dir|
  if !File.directory?(dir)
    then FileUtils.mkdir_p(dir)
  end
end

#

Given %r{^I have the following (draft|page|post)s?(?: (in|under) "([^"]+)")?:$} do |status, direction, folder, table|
  table.hashes.each do |input_hash|
    title = slug(input_hash["title"])
    ext = input_hash["type"] || "markdown"
    filename = filename = "#{title}.#{ext}" if %w(draft page).include?(status)
    before, after = location(folder, direction)
    dest_folder = "_drafts" if status == "draft"
    dest_folder = "_posts"  if status ==  "post"
    dest_folder = "" if status == "page"

    if status == "post"
      parsed_date = Time.xmlschema(input_hash['date']) rescue Time.parse(input_hash['date'])
      filename = "#{parsed_date.strftime('%Y-%m-%d')}-#{title}.#{ext}"
    end

    path = File.join(before, dest_folder, after, filename)
    File.write(path, file_content_from_hash(input_hash))
  end
end

#

Given %r{^I have a configuration file with "(.*)" set to "(.*)"$} do |key, value|
  config = if source_dir.join("_config.yml").exist?
    SafeYAML.load_file(source_dir.join("_config.yml"))
  else
    {}
  end
  config[key] = YAML.load(value)
  File.write("_config.yml", YAML.dump(config))
end

#

Given %r{^I have a configuration file with:$} do |table|
  table.hashes.each do |row|
    step %(I have a configuration file with "#{row["key"]}" set to "#{row["value"]}")
  end
end

#

Given %r{^I have a configuration file with "([^\"]*)" set to:$} do |key, table|
  File.open("_config.yml", "w") do |f|
    f.write("#{key}:\n")
    table.hashes.each do |row|
      f.write("- #{row["value"]}\n")
    end
  end
end

#

Given %r{^I have fixture collections$} do
  FileUtils.cp_r Paths.source_dir.join("test", "source", "_methods"), source_dir
end

#

Given %r{^I wait (\d+) second(s?)$} do |time, plural|
  sleep(time.to_f)
end

#

When %r{^I run jekyll(.*)$} do |args|
  run_jekyll(args)
  if args.include?("--verbose") || ENV["DEBUG"]
    $stderr.puts "\n#{jekyll_run_output}\n"
  end
end

#

When %r{^I run bundle(.*)$} do |args|
  run_bundle(args)
  if args.include?("--verbose") || ENV['DEBUG']
    $stderr.puts "\n#{jekyll_run_output}\n"
  end
end

#

When %r{^I change "(.*)" to contain "(.*)"$} do |file, text|
  File.open(file, "a") do |f|
    f.write(text)
  end
end

#

When %r{^I delete the file "(.*)"$} do |file|
  File.delete(file)
end

#

Then %r{^the (.*) directory should +exist$} do |dir|
  expect(Pathname.new(dir)).to exist
end

#

Then %r{^the (.*) directory should not exist$} do |dir|
  expect(Pathname.new(dir)).not_to exist
end

#
Then %r{^I should see "(.*)" in "(.*)"$} do |text, file|
  regexp = Regexp.new(text, Regexp::MULTILINE)
  expect(file_contents(file)).to match regexp
end

#

Then %r{^I should see exactly "(.*)" in "(.*)"$} do |text, file|
  expect(file_contents(file).strip).to eq text
end

#

Then %r{^I should not see "(.*)" in "(.*)"$} do |text, file|
  regexp = Regexp.new(text, Regexp::MULTILINE)
  expect(file_contents(file)).not_to match regexp
end

#

Then %r{^I should see escaped "(.*)" in "(.*)"$} do |text, file|
  regexp = Regexp.new(Regexp.escape(text))
  expect(file_contents(file)).to match regexp
end

#

Then %r{^the "(.*)" file should +exist$} do |file|
  expect(Pathname.new(file)).to exist
end

#

Then %r{^the "(.*)" file should not exist$} do |file|
  expect(Pathname.new(file)).to_not exist
end

#

Then %r{^I should see today's time in "(.*)"$} do |file|
  seconds = seconds_agnostic_time(Time.now)
  expect(file_contents(file)).to match Regexp.new(seconds)
end

#

Then %r{^I should see today's date in "(.*)"$} do |file|
  regexp = Regexp.new(Date.today.to_s)
  expect(file_contents(file)).to match regexp
end

#

Then %r{^I should see "(.*)" in the build output$} do |text|
  expect(jekyll_run_output).to match Regexp.new(text)
end

#

Then %r{^I should get a zero exit(?:\-| )status$} do
  step %(I should see "EXIT STATUS: 0" in the build output)
end

#

Then %r{^I should get a non-zero exit(?:\-| )status$} do
  expect(jekyll_run_status.to_i).not_to match(%r{EXIT STATUS: 0})
end
