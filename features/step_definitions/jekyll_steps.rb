def file_content_from_hash(input_hash)
  matter_hash = input_hash.reject { |k, v| k == "content" }
  matter = matter_hash.map { |k, v| "#{k}: #{v}\n" }.join.chomp

  content = if input_hash['input'] && input_hash['filter']
    "{{ #{input_hash['input']} | #{input_hash['filter']} }}"
  else
    input_hash['content']
  end

  <<EOF
---
#{matter}
---
#{content}
EOF
end


Before do
  FileUtils.mkdir(TEST_DIR)
  Dir.chdir(TEST_DIR)
end

After do
  FileUtils.rm_rf(TEST_DIR)
  FileUtils.rm_rf(JEKYLL_COMMAND_OUTPUT_FILE)
end

World(Test::Unit::Assertions)

Given /^I have a blank site in "(.*)"$/ do |path|
  FileUtils.mkdir_p(path)
end

Given /^I do not have a "(.*)" directory$/ do |path|
  File.directory?("#{TEST_DIR}/#{path}")
end

# Like "I have a foo file" but gives a yaml front matter so jekyll actually processes it
Given /^I have an? "(.*)" page(?: with (.*) "(.*)")? that contains "(.*)"$/ do |file, key, value, text|
  File.open(file, 'w') do |f|
    f.write <<EOF
---
#{key || 'layout'}: #{value || 'nil'}
---
#{text}
EOF
  end
end

Given /^I have an? "(.*)" file that contains "(.*)"$/ do |file, text|
  File.open(file, 'w') do |f|
    f.write(text)
  end
end

Given /^I have an? (.*) (layout|theme) that contains "(.*)"$/ do |name, type, text|
  folder = if type == 'layout'
    '_layouts'
  else
    '_theme'
  end
  destination_file = File.join(folder, name + '.html')
  destination_path = File.dirname(destination_file)
  unless File.exist?(destination_path)
    FileUtils.mkdir_p(destination_path)
  end
  File.open(destination_file, 'w') do |f|
    f.write(text)
  end
end

Given /^I have an? "(.*)" file with content:$/ do |file, text|
  File.open(file, 'w') do |f|
    f.write(text)
  end
end

Given /^I have an? (.*) directory$/ do |dir|
  FileUtils.mkdir_p(dir)
end

Given /^I have the following (draft|page|post)s?(?: (in|under) "([^"]+)")?:$/ do |status, direction, folder, table|
  table.hashes.each do |input_hash|
    title = slug(input_hash['title'])
    ext = input_hash['type'] || 'textile'
    before, after = location(folder, direction)

    case status
    when "draft"
      dest_folder = '_drafts'
      filename = "#{title}.#{ext}"
    when "page"
      dest_folder = ''
      filename = "#{title}.#{ext}"
    when "post"
      parsed_date = Time.xmlschema(input_hash['date']) rescue Time.parse(input_hash['date'])
      dest_folder = '_posts'
      filename = "#{parsed_date.strftime('%Y-%m-%d')}-#{title}.#{ext}"
    end

    path = File.join(before, dest_folder, after, filename)
    File.open(path, 'w') do |f|
      f.write file_content_from_hash(input_hash)
    end
  end
end

Given /^I have a configuration file with "(.*)" set to "(.*)"$/ do |key, value|
  File.open('_config.yml', 'w') do |f|
    f.write("#{key}: #{value}\n")
  end
end

Given /^I have a configuration file with:$/ do |table|
  File.open('_config.yml', 'w') do |f|
    table.hashes.each do |row|
      f.write("#{row["key"]}: #{row["value"]}\n")
    end
  end
end

Given /^I have a configuration file with "([^\"]*)" set to:$/ do |key, table|
  File.open('_config.yml', 'w') do |f|
    f.write("#{key}:\n")
    table.hashes.each do |row|
      f.write("- #{row["value"]}\n")
    end
  end
end


When /^I run jekyll$/ do
  run_jekyll_build
end

When /^I run jekyll in safe mode$/ do
  run_jekyll_build("--safe")
end

When /^I run jekyll with drafts$/ do
  run_jekyll_build("--drafts")
end

When /^I call jekyll new with test_blank --blank$/ do
  run_jekyll_new("test_blank --blank")
end

When /^I debug jekyll$/ do
  run_jekyll_build("--verbose")
end

When /^I change "(.*)" to contain "(.*)"$/ do |file, text|
  File.open(file, 'a') do |f|
    f.write(text)
  end
end

When /^I delete the file "(.*)"$/ do |file|
  File.delete(file)
end

Then /^the (.*) directory should +exist$/ do |dir|
  assert File.directory?(dir), "The directory \"#{dir}\" does not exist"
end

Then /^the (.*) directory should not exist$/ do |dir|
  assert !File.directory?(dir), "The directory \"#{dir}\" exists"
end

Then /^I should see "(.*)" in "(.*)"$/ do |text, file|
  assert_match Regexp.new(text), file_contents(file)
end

Then /^I should see exactly "(.*)" in "(.*)"$/ do |text, file|
  assert_equal text, file_contents(file).strip
end

Then /^I should not see "(.*)" in "(.*)"$/ do |text, file|
  assert_no_match Regexp.new(text), file_contents(file)
end

Then /^I should see escaped "(.*)" in "(.*)"$/ do |text, file|
  assert_match Regexp.new(Regexp.escape(text)), file_contents(file)
end

Then /^the "(.*)" file should +exist$/ do |file|
  assert File.file?(file), "The file \"#{file}\" does not exist"
end

Then /^the "(.*)" file should not exist$/ do |file|
  assert !File.exists?(file), "The file \"#{file}\" exists"
end

Then /^I should see today's time in "(.*)"$/ do |file|
  assert_match Regexp.new(seconds_agnostic_time(Time.now)), file_contents(file)
end

Then /^I should see today's date in "(.*)"$/ do |file|
  assert_match Regexp.new(Date.today.to_s), file_contents(file)
end
